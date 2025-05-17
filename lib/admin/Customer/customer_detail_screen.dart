import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/user_controller.dart';
import 'package:gear_zone/model/user.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends StatefulWidget {
  final bool isViewOnly;
  
  const CustomerDetailScreen({
    super.key,
    this.isViewOnly = true,
  });

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final UserController _userController = UserController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  UserModel? _user;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRole = 'user';
  bool _isBanned = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    if (appProvider.currentCustomerId.isEmpty) {
      Navigator.pop(context); // Trở về nếu không có ID
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _userController.getUserById(appProvider.currentCustomerId);
      if (user != null) {
        setState(() {
          _user = user;
          _nameController.text = user.name;
          _phoneController.text = user.phoneNumber;
          _selectedRole = user.role ?? 'user';
          _isBanned = user.isBanned ?? false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi tải dữ liệu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate() || _user == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Cập nhật thông tin người dùng
      final updatedUser = UserModel(
        uid: _user!.uid,
        email: _user!.email,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        photoURL: _user!.photoURL,
        addressList: _user!.addressList,
        defaultAddressId: _user!.defaultAddressId,
        role: _selectedRole,
        isBanned: _isBanned,
        createdAt: _user!.createdAt,
      );

      await _userController.updateUser(updatedUser);
      
      // Cập nhật trạng thái cấm nếu có thay đổi
      if (_isBanned != (_user!.isBanned ?? false)) {
        await _userController.banUser(_user!.uid, _isBanned);
      }
      
      // Cập nhật vai trò nếu có thay đổi
      if (_selectedRole != (_user!.role ?? 'user')) {
        await _userController.updateUserRole(_user!.uid, _selectedRole);
      }
      
      _showSuccessSnackBar('Đã cập nhật thông tin người dùng.');

      // Tải lại danh sách người dùng
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.setReloadCustomerList(true);
      
      // Trở về chế độ xem sau khi lưu
      if (!widget.isViewOnly) {
        appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
      }
      
      // Tải lại dữ liệu
      await _loadUserData();

    } catch (e) {
      _showErrorSnackBar('Lỗi khi cập nhật: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('Không tìm thấy người dùng'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header and breadcrumb
                      _buildHeader(context),
                      const SizedBox(height: 24),

                      // User profile
                      isMobile
                          ? _buildMobileUserProfile()
                          : _buildDesktopUserProfile(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                appProvider.setCurrentScreen(AppScreen.customerList);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              widget.isViewOnly ? 'Thông tin khách hàng' : 'Chỉnh sửa thông tin',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isMobile && _user != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  appProvider.setCurrentScreen(AppScreen.customerList);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Danh sách khách hàng',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                _nameController.text,
                style: TextStyle(
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMobileUserProfile() {
    if (_user == null) return Container();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar and basic info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _user!.photoURL != null && _user!.photoURL!.isNotEmpty 
                        ? NetworkImage(_user!.photoURL!) 
                        : null,
                    child: _user!.photoURL == null || _user!.photoURL!.isEmpty 
                        ? const Icon(Icons.person, color: Colors.grey, size: 50) 
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      hintText: 'Nhập họ và tên',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                    enabled: !widget.isViewOnly,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      return null;
                    },
                    enabled: !widget.isViewOnly,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    child: Text(_user!.email),
                  ),
                  const SizedBox(height: 16),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ngày đăng ký',
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    child: Text(DateFormat('dd/MM/yyyy').format(_user!.createdAt)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // User role and status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quyền và trạng thái',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Vai trò',
                    ),
                    value: _selectedRole,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'admin',
                        child: Text('Admin'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'user',
                        child: Text('User'),
                      ),
                    ],
                    onChanged: widget.isViewOnly ? null : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Cấm người dùng'),
                    subtitle: Text(
                      'Người dùng sẽ không thể đăng nhập khi bị cấm',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _isBanned,
                    onChanged: widget.isViewOnly ? null : (value) {
                      setState(() {
                        _isBanned = value;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  if (_isBanned && !widget.isViewOnly)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Cảnh báo: Người dùng sẽ không thể đăng nhập hoặc sử dụng tài khoản của họ!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Address information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),                  if (_user!.addressList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Người dùng chưa thêm địa chỉ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )                  else
                    Builder(
                      builder: (context) {
                        // Lấy địa chỉ mặc định sử dụng phương thức mới từ UserModel
                        final defaultAddress = _user!.getDefaultAddress();
                        
                        if (defaultAddress == null || defaultAddress.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Không tìm thấy địa chỉ mặc định',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          );
                        }
                        
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            defaultAddress['title'] ?? 'Địa chỉ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${defaultAddress['name'] ?? ''} | ${defaultAddress['phoneNumber'] ?? ''}'),
                              Text(defaultAddress['fullAddress'] ?? _user!.getDefaultAddressText()),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(
                              'Mặc định',
                              style: TextStyle(
                                fontSize: 12, 
                                color: Colors.green,
                              ),
                            ),
                            backgroundColor: Colors.green[50],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action buttons
          if (!widget.isViewOnly) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                    appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: Text('Hủy'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: Text('Lưu thay đổi'),
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                    appProvider.setCurrentScreen(AppScreen.customerList);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Quay lại'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                    appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Chỉnh sửa'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopUserProfile() {
    if (_user == null) return Container();

    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column - User details
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin cơ bản',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: _user!.photoURL != null && _user!.photoURL!.isNotEmpty 
                                      ? NetworkImage(_user!.photoURL!) 
                                      : null,
                                  child: _user!.photoURL == null || _user!.photoURL!.isEmpty 
                                      ? const Icon(Icons.person, color: Colors.grey, size: 50) 
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(width: 32),
                            
                            // Form fields
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Họ và tên',
                                            hintText: 'Nhập họ và tên',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Vui lòng nhập họ và tên';
                                            }
                                            return null;
                                          },
                                          enabled: !widget.isViewOnly,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _phoneController,
                                          decoration: const InputDecoration(
                                            labelText: 'Số điện thoại',
                                            hintText: 'Nhập số điện thoại',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Vui lòng nhập số điện thoại';
                                            }
                                            return null;
                                          },
                                          enabled: !widget.isViewOnly,
                                          keyboardType: TextInputType.phone,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          child: Text(_user!.email),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            labelText: 'Ngày đăng ký',
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          child: Text(DateFormat('dd/MM/yyyy').format(_user!.createdAt)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Address information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Địa chỉ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 24),                        if (_user!.addressList.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Người dùng chưa thêm địa chỉ',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          )
                        else if (_user!.defaultAddressId == null || _user!.defaultAddressId!.isEmpty) 
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Không có địa chỉ mặc định',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          )
                        else
                          Builder(
                            builder: (context) {
                              // Tìm địa chỉ mặc định
                              final defaultAddress = _user!.addressList.firstWhere(
                                (address) => address['id'] == _user!.defaultAddressId,
                                orElse: () => {},
                              );
                              
                              if (defaultAddress.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Không tìm thấy địa chỉ mặc định',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                );
                              }
                              
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  children: [
                                    Text(
                                      defaultAddress['title'] ?? 'Địa chỉ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        'Mặc định',
                                        style: TextStyle(
                                          fontSize: 12, 
                                          color: Colors.green,
                                        ),
                                      ),
                                      backgroundColor: Colors.green[50],
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('${defaultAddress['name']} | ${defaultAddress['phoneNumber']}'),
                                    Text(defaultAddress['fullAddress'] ?? ''),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right column - User role and status
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quyền và trạng thái',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Vai trò',
                          ),
                          value: _selectedRole,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'user',
                              child: Text('User'),
                            ),
                          ],
                          onChanged: widget.isViewOnly ? null : (value) {
                            if (value != null) {
                              setState(() {
                                _selectedRole = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        SwitchListTile(
                          title: Text('Cấm người dùng'),
                          subtitle: Text(
                            'Người dùng sẽ không thể đăng nhập khi bị cấm',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _isBanned,
                          onChanged: widget.isViewOnly ? null : (value) {
                            setState(() {
                              _isBanned = value;
                            });
                          },
                          activeColor: Colors.red,
                        ),
                        if (_isBanned && !widget.isViewOnly)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              'Cảnh báo: Người dùng sẽ không thể đăng nhập hoặc sử dụng tài khoản của họ!',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thao tác',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (!widget.isViewOnly) ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                                    appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: Text('Hủy'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveUser,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: Text('Lưu thay đổi'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                                    appProvider.setCurrentScreen(AppScreen.customerList);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Quay lại'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                                    appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Chỉnh sửa'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _showResetPasswordDialog(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    foregroundColor: Colors.orange,
                                  ),
                                  child: const Text('Đặt lại mật khẩu'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    if (_user == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt lại mật khẩu'),
        content: Text(
          'Bạn có chắc chắn muốn gửi email đặt lại mật khẩu cho ${_user!.email} không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await _userController.resetPassword(_user!.email);
                _showSuccessSnackBar('Đã gửi email đặt lại mật khẩu.');
              } catch (e) {
                _showErrorSnackBar('Lỗi khi gửi email: $e');
              }
            },
            child: Text(
              'Gửi email',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
