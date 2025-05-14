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
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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
          errorMessage = "Email này đã được sử dụng. Vui lòng sử dụng email khác.";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Đăng ký với email và mật khẩu hiện không được cho phép.";
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
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        _setError("Đăng nhập thất bại. Vui lòng thử lại.");
        return false;
      }

      await _fetchUserData(userCredential.user!.uid);
      
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
      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

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
      context, 
      AppRoutes.homeScreen, 
      (route) => false
    );
  }
  
  // Phương thức để đổi mật khẩu
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _setLoading(true);
    _clearMessages();
    
    try {
      // Kiểm tra xem người dùng đã đăng nhập chưa
      if (_firebaseUser == null || _firebaseUser!.email == null) {
        _setError("Người dùng chưa đăng nhập hoặc không có email");
        return false;
      }
      
      // Tái xác thực người dùng với mật khẩu hiện tại
      AuthCredential credential = EmailAuthProvider.credential(
        email: _firebaseUser!.email!,
        password: currentPassword,
      );
      
      await _firebaseUser!.reauthenticateWithCredential(credential);
      
      // Đổi mật khẩu
      await _firebaseUser!.updatePassword(newPassword);
      
      _setSuccessMessage("Đổi mật khẩu thành công!");
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = "Mật khẩu hiện tại không chính xác";
          break;
        case 'weak-password':
          errorMessage = "Mật khẩu mới quá yếu. Vui lòng chọn mật khẩu mạnh hơn";
          break;
        case 'requires-recent-login':
          errorMessage = "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại để đổi mật khẩu";
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
}
