import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../controller/cart_controller.dart';
import '../routes/app_routes.dart';

class AuthController with ChangeNotifier {
  // Singleton pattern
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User state
  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null;
  String? get error => _error;
  String? get successMessage => _successMessage;
  // Khởi tạo - kiểm tra phiên đăng nhập hiện tại
  Future<void> initAuth() async {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _fetchUserData(user.uid);

        // Kiểm tra xem tài khoản có bị cấm không sau khi lấy được dữ liệu
        if (_userModel != null && (_userModel!.isBanned ?? false)) {
          // Đăng xuất ngay lập tức nếu tài khoản bị cấm
          await signOut();
          _setError(
              "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ với bộ phận hỗ trợ.");
        }
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  // Đăng ký người dùng mới với email và mật khẩu
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? phoneNumber,
    required CartController cartController,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      // Tạo tài khoản trong Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kiểm tra xem đăng ký có thành công không
      if (userCredential.user == null) {
        _setError("Không thể tạo tài khoản. Vui lòng thử lại sau.");
        return false;
      }

      // Tạo đối tượng UserModel mới
      final newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name ?? "",
        email: email,
        phoneNumber: phoneNumber ?? "",
        createdAt: DateTime.now(),
        role: "user", // Mặc định vai trò là người dùng thông thường
      );

      // Lưu thông tin người dùng vào Firestore
      await _saveUserToFirestore(newUser);

      // Cập nhật userModel
      _userModel = newUser;

      // Xử lý giỏ hàng sau khi đăng ký thành công
      await cartController.handleUserLogin(userCredential.user!.uid);

      // Đặt thông báo thành công
      _setSuccessMessage("Đăng ký thành công!");

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              "Email này đã được sử dụng. Vui lòng sử dụng email khác.";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "Đăng ký với email và mật khẩu hiện không được cho phép.";
          break;
        case 'weak-password':
          errorMessage = "Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.";
          break;
        default:
          errorMessage = "Đã xảy ra lỗi: ${e.message}";
      }
      _setError(errorMessage);
      return false;
    } catch (e) {
      _setError("Đã xảy ra lỗi không xác định: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng nhập với email và mật khẩu
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
    required CartController cartController,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        _setError("Đăng nhập thất bại. Vui lòng thử lại.");
        return false;
      }

      await _fetchUserData(userCredential.user!.uid);

      // Kiểm tra xem tài khoản có bị cấm không
      if (_userModel != null && (_userModel!.isBanned ?? false)) {
        // Đăng xuất người dùng ngay lập tức nếu họ bị cấm
        await signOut();
        _setError(
            "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ với bộ phận hỗ trợ.");
        return false;
      }

      // Xử lý giỏ hàng sau khi đăng nhập thành công
      await cartController.handleUserLogin(userCredential.user!.uid);

      // Đặt thông báo thành công
      _setSuccessMessage("Đăng nhập thành công!");

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Không tìm thấy tài khoản với email này.";
          break;
        case 'wrong-password':
          errorMessage = "Mật khẩu không chính xác.";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ.";
          break;
        case 'user-disabled':
          errorMessage = "Tài khoản này đã bị vô hiệu hóa.";
          break;
        default:
          errorMessage = "Đăng nhập thất bại: ${e.message}";
      }
      _setError(errorMessage);
      return false;
    } catch (e) {
      _setError("Đã xảy ra lỗi không xác định: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    _setLoading(true);
    _clearMessages();

    try {
      await _auth.signOut();
      _userModel = null;
      _setSuccessMessage("Đăng xuất thành công!");
      notifyListeners();
    } catch (e) {
      _setError("Đăng xuất thất bại: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Lấy thông tin người dùng từ Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = uid; // Đảm bảo uid được đặt chính xác
        _userModel = UserModel.fromMap(data);
      } else {
        // Nếu không tìm thấy dữ liệu trong Firestore, có thể tạo bản ghi mới
        print("Không tìm thấy dữ liệu người dùng trong Firestore");
        final authUser = _auth.currentUser!;
        _userModel = UserModel(
          uid: uid,
          name: authUser.displayName ?? "",
          email: authUser.email ?? "",
          phoneNumber: authUser.phoneNumber ?? "",
          createdAt: DateTime.now(),
        );
        await _saveUserToFirestore(_userModel!);
      }
      notifyListeners();
    } catch (e) {
      print("Lỗi khi lấy dữ liệu người dùng: $e");
      _setError("Không thể lấy thông tin người dùng: $e");
    }
  }

  // Refresh user data from Firestore - used after checkout to update loyalty points
  Future<void> refreshUserData() async {
    if (_firebaseUser != null) {
      await _fetchUserData(_firebaseUser!.uid);
    }
  }

  // Lưu thông tin người dùng vào Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(
            user.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      print("Lỗi khi lưu dữ liệu người dùng: $e");
      _setError("Không thể lưu thông tin người dùng: $e");
    }
  }

  Future<void> saveUserAddress({
    required String province,
    required String district,
    required String ward,
    required String street,
    String? name,
    String? phoneNumber,
    String? title,
    bool isDefault = true,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Không tìm thấy người dùng hiện tại');
      }

      // Tạo ID duy nhất cho địa chỉ mới
      final String addressId = DateTime.now().millisecondsSinceEpoch.toString();

      // Lấy tên và số điện thoại từ model nếu không được cung cấp
      String userName = name ?? _userModel?.name ?? "";
      String userPhone = phoneNumber ?? _userModel?.phoneNumber ?? "";
      String addressTitle = title ?? "Địa chỉ";

      // Tạo dữ liệu địa chỉ mới
      Map<String, dynamic> newAddress = {
        'id': addressId,
        'province': province,
        'district': district,
        'ward': ward,
        'street': street,
        'fullAddress': '$street, $ward, $district, $province',
        'name': userName,
        'phoneNumber': userPhone,
        'title': addressTitle,
        'isDefault': isDefault,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Nếu đã có userModel, thêm địa chỉ vào danh sách hiện có
      if (_userModel != null) {
        List<Map<String, dynamic>> updatedAddressList =
            List.from(_userModel!.addressList);
        updatedAddressList.add(newAddress);

        // Chỉ đặt địa chỉ mới làm mặc định nếu:
        // 1. isDefault = true (được yêu cầu đặt làm mặc định), hoặc
        // 2. Đây là địa chỉ đầu tiên (không có địa chỉ mặc định nào trước đó)
        String? newDefaultAddressId = _userModel!.defaultAddressId;
        if (isDefault ||
            _userModel!.defaultAddressId == null ||
            _userModel!.defaultAddressId!.isEmpty) {
          newDefaultAddressId = addressId;
        }

        // Cập nhật userModel với địa chỉ mới
        _userModel = _userModel!.copyWith(
          addressList: updatedAddressList,
          defaultAddressId: newDefaultAddressId,
        );

        // Lưu vào Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'addressList': updatedAddressList,
          'defaultAddressId': newDefaultAddressId,
        });
      } else {
        // Nếu chưa có userModel, tạo document địa chỉ riêng
        // Địa chỉ đầu tiên luôn là mặc định
        await _firestore.collection('users').doc(user.uid).update({
          'addressList': FieldValue.arrayUnion([newAddress]),
          'defaultAddressId': addressId,
        });

        // Cập nhật dữ liệu người dùng
        await _fetchUserData(user.uid);
      }

      print('Đã lưu địa chỉ thành công: $province, $district, $ward, $street');
      notifyListeners();
    } catch (e) {
      print('Lỗi khi lưu địa chỉ: $e');
      throw Exception('Lỗi khi lưu địa chỉ: $e');
    }
  }

  // Cập nhật thông tin người dùng
  Future<bool> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? photoURL,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      if (_firebaseUser == null || _userModel == null) {
        _setError("Người dùng chưa đăng nhập");
        return false;
      }

      // Cập nhật userModel với thông tin mới
      _userModel = _userModel!.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
      );

      // Lưu vào Firestore
      await _saveUserToFirestore(_userModel!);
      _setSuccessMessage("Cập nhật thông tin thành công!");
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Không thể cập nhật thông tin: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đặt trạng thái loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Xóa thông báo
  void _clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  // Đặt thông báo lỗi
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  // Đặt thông báo thành công
  void _setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
  }

  // Phương thức để xử lý chuyển hướng sau khi đăng nhập/đăng ký thành công
  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.homeScreen, (route) => false);
  }

  // Phương thức để đổi mật khẩu
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    _setLoading(true);
    _clearMessages();

    try {
      // Kiểm tra xem người dùng đã đăng nhập chưa
      if (_firebaseUser == null || _firebaseUser!.email == null) {
        _setError("Người dùng chưa đăng nhập hoặc không có email");
        return false;
      }

      // Nếu người dùng mới (chưa đổi mật khẩu từ khi tài khoản tạo tự động)
      bool isFirstPasswordChange = isUsingGeneratedPassword();

      // Chỉ xác thực lại với mật khẩu hiện tại nếu không phải là lần đầu thay đổi mật khẩu
      if (!isFirstPasswordChange) {
        // Tái xác thực người dùng với mật khẩu hiện tại
        AuthCredential credential = EmailAuthProvider.credential(
          email: _firebaseUser!.email!,
          password: currentPassword,
        );

        await _firebaseUser!.reauthenticateWithCredential(credential);
      } // Đổi mật khẩu
      await _firebaseUser!.updatePassword(newPassword);

      // Cập nhật trạng thái đổi mật khẩu
      if (_userModel != null) {
        final updatedUserModel = _userModel!.copyWith(hasChangedPassword: true);
        await _saveUserToFirestore(updatedUserModel);
        _userModel = updatedUserModel;
      }

      _setSuccessMessage("Đổi mật khẩu thành công!");
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = "Mật khẩu hiện tại không chính xác";
          break;
        case 'weak-password':
          errorMessage =
              "Mật khẩu mới quá yếu. Vui lòng chọn mật khẩu mạnh hơn";
          break;
        case 'requires-recent-login':
          errorMessage =
              "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại để đổi mật khẩu";
          break;
        default:
          errorMessage = "Lỗi đổi mật khẩu: ${e.message}";
      }
      _setError(errorMessage);
      return false;
    } catch (e) {
      _setError("Đã xảy ra lỗi không xác định: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Kiểm tra xem người dùng có đang sử dụng mật khẩu tự động không
  bool isUsingGeneratedPassword() {
    if (_userModel == null) return false;
    return !_userModel!.hasChangedPassword;
  }

  // Phương thức gửi email khôi phục mật khẩu
  Future<bool> sendPasswordResetEmail({
    required String email,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _setSuccessMessage(
          "Đã gửi email khôi phục mật khẩu thành công! Vui lòng kiểm tra hộp thư của bạn.");
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Không tìm thấy tài khoản với email này.";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ.";
          break;
        default:
          errorMessage = "Lỗi gửi email khôi phục: ${e.message}";
      }
      _setError(errorMessage);
      return false;
    } catch (e) {
      _setError("Đã xảy ra lỗi không xác định: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Phương thức cập nhật địa chỉ
  Future<bool> updateUserAddress({
    required String addressId,
    required String province,
    required String district,
    required String ward,
    required String street,
    String? title,
    String? name,
    String? phoneNumber,
    bool? setAsDefault,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        _setError('Không tìm thấy người dùng hiện tại');
        return false;
      }

      if (_userModel == null) {
        _setError('Không tìm thấy thông tin người dùng');
        return false;
      }

      // Tìm địa chỉ cần cập nhật trong danh sách
      int addressIndex = _userModel!.addressList
          .indexWhere((address) => address['id'] == addressId);

      if (addressIndex == -1) {
        _setError('Không tìm thấy địa chỉ cần cập nhật');
        return false;
      }

      // Clone danh sách địa chỉ hiện tại
      List<Map<String, dynamic>> updatedAddressList =
          List<Map<String, dynamic>>.from(_userModel!.addressList);

      // Cập nhật địa chỉ
      updatedAddressList[addressIndex] = {
        'id': addressId,
        'province': province,
        'district': district,
        'ward': ward,
        'street': street,
        'fullAddress': '$street, $ward, $district, $province',
        'title':
            title ?? updatedAddressList[addressIndex]['title'] ?? 'Địa chỉ',
        'name': name ?? updatedAddressList[addressIndex]['name'] ?? '',
        'phoneNumber': phoneNumber ??
            updatedAddressList[addressIndex]['phoneNumber'] ??
            '',
        'isDefault': updatedAddressList[addressIndex]['isDefault'] ?? false,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Cập nhật địa chỉ mặc định nếu được yêu cầu
      String? newDefaultAddressId = _userModel!.defaultAddressId;
      if (setAsDefault == true) {
        newDefaultAddressId = addressId;
      }

      // Cập nhật userModel
      _userModel = _userModel!.copyWith(
        addressList: updatedAddressList,
        defaultAddressId: newDefaultAddressId,
      );

      // Lưu vào Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'addressList': updatedAddressList,
        'defaultAddressId': newDefaultAddressId,
      });

      _setSuccessMessage('Cập nhật địa chỉ thành công');
      return true;
    } catch (e) {
      _setError('Lỗi khi cập nhật địa chỉ: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Phương thức xóa địa chỉ
  Future<bool> deleteUserAddress({
    required String addressId,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        _setError('Không tìm thấy người dùng hiện tại');
        return false;
      }

      if (_userModel == null) {
        _setError('Không tìm thấy thông tin người dùng');
        return false;
      }

      // Tìm địa chỉ cần xóa trong danh sách
      int addressIndex = _userModel!.addressList
          .indexWhere((address) => address['id'] == addressId);

      if (addressIndex == -1) {
        _setError('Không tìm thấy địa chỉ cần xóa');
        return false;
      }

      // Clone danh sách địa chỉ hiện tại và xóa địa chỉ
      List<Map<String, dynamic>> updatedAddressList =
          List<Map<String, dynamic>>.from(_userModel!.addressList);
      updatedAddressList.removeAt(addressIndex);

      // Kiểm tra nếu địa chỉ bị xóa là địa chỉ mặc định
      String? newDefaultAddressId = _userModel!.defaultAddressId;
      if (addressId == _userModel!.defaultAddressId) {
        // Nếu còn địa chỉ khác, đặt địa chỉ đầu tiên là mặc định
        newDefaultAddressId = updatedAddressList.isNotEmpty
            ? updatedAddressList.first['id']
            : null;
      }

      // Cập nhật userModel
      _userModel = _userModel!.copyWith(
        addressList: updatedAddressList,
        defaultAddressId: newDefaultAddressId,
      );

      // Lưu vào Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'addressList': updatedAddressList,
        'defaultAddressId': newDefaultAddressId,
      });

      _setSuccessMessage('Xóa địa chỉ thành công');
      return true;
    } catch (e) {
      _setError('Lỗi khi xóa địa chỉ: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Navigate to admin screen
  void navigateToAdminScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.admin, (route) => false);
  }
}
