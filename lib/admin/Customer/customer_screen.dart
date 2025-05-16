import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/user_controller.dart';
import 'package:gear_zone/model/user.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:intl/intl.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final UserController _userController = UserController();
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem có cần tải lại danh sách không
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.reloadCustomerList) {
        appProvider.setReloadCustomerList(false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and search bar
            _buildHeader(context),
            const SizedBox(height: 16),
            
            // Filters and actions
            _buildFilters(context),
            const SizedBox(height: 16),

            // Customers list
            Expanded(
              child: _buildCustomersList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách khách hàng',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<int>(
                future: _userController.getUsersCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return Text(
                    '$count người dùng',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isMobile ? 12 : 14,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm khách hàng...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm khách hàng...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
      ],
    );
  }

  Widget _buildCustomersList(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return StreamBuilder<List<UserModel>>(
      stream: _searchQuery.isEmpty
          ? _userController.getUsers()
          : _userController.searchUsers(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Đã có lỗi xảy ra: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final users = snapshot.data ?? [];

        if (users.isEmpty) {
          return const Center(
            child: Text(
              'Không có người dùng nào',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return isMobile
            ? _buildMobileCustomersList(users, appProvider)
            : _buildDesktopCustomersList(users, appProvider);
      },
    );
  }

  Widget _buildMobileCustomersList(List<UserModel> users, AppProvider appProvider) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isBanned = user.isBanned ?? false;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              appProvider.setCurrentCustomerId(user.uid);
              appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty 
                        ? NetworkImage(user.photoURL!) 
                        : null,
                    child: user.photoURL == null || user.photoURL!.isEmpty 
                        ? const Icon(Icons.person, color: Colors.grey) 
                        : null,
                  ),
                  const SizedBox(width: 16),
                  
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isBanned ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                            if (isBanned)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.red, width: 1),
                                ),
                                child: Text(
                                  'Đã cấm',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: isBanned ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.phoneNumber,
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: isBanned ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ngày đăng ký: ${DateFormat('dd/MM/yyyy').format(user.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _showBanUserDialog(context, user),
                              child: Text(
                                isBanned ? 'Bỏ cấm' : 'Cấm',
                                style: TextStyle(
                                  color: isBanned ? Colors.orange : Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                appProvider.setCurrentCustomerId(user.uid);
                                appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: false);
                              },
                              child: const Text('Sửa'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopCustomersList(List<UserModel> users, AppProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Avatar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tên',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Số điện thoại',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Ngày đăng ký',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Vai trò',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Trạng thái',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Thao tác',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Table divider
          Divider(height: 1, color: Colors.grey[300]),

          // Table data
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                final isBanned = user.isBanned ?? false;
                
                return InkWell(
                  onTap: () {
                    appProvider.setCurrentCustomerId(user.uid);
                    appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Avatar
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty 
                                ? NetworkImage(user.photoURL!) 
                                : null,
                            child: user.photoURL == null || user.photoURL!.isEmpty 
                                ? const Icon(Icons.person, color: Colors.grey) 
                                : null,
                          ),
                        ),
                        
                        // Name
                        Expanded(
                          flex: 2,
                          child: Text(
                            user.name,
                            style: TextStyle(
                              decoration: isBanned ? TextDecoration.lineThrough : null,
                              color: isBanned ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                        
                        // Email
                        Expanded(
                          flex: 2,
                          child: Text(
                            user.email,
                            style: TextStyle(
                              decoration: isBanned ? TextDecoration.lineThrough : null,
                              color: isBanned ? Colors.grey : Colors.grey[800],
                            ),
                          ),
                        ),
                        
                        // Phone
                        Expanded(
                          flex: 2,
                          child: Text(
                            user.phoneNumber,
                            style: TextStyle(
                              decoration: isBanned ? TextDecoration.lineThrough : null,
                              color: isBanned ? Colors.grey : Colors.grey[800],
                            ),
                          ),
                        ),
                        
                        // Registration date
                        Expanded(
                          flex: 1,
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(user.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        
                        // Role
                        Expanded(
                          flex: 1,
                          child: Text(
                            user.role?.toUpperCase() ?? 'USER',
                            style: TextStyle(
                              color: user.role?.toLowerCase() == 'admin' ? Colors.deepPurple : Colors.grey[700],
                              fontWeight: user.role?.toLowerCase() == 'admin' ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        
                        // Status
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isBanned ? Colors.red[50] : Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isBanned ? Colors.red : Colors.green,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              isBanned ? 'Đã cấm' : 'Hoạt động',
                              style: TextStyle(
                                color: isBanned ? Colors.red : Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        
                        // Actions
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  appProvider.setCurrentCustomerId(user.uid);
                                  appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: false);
                                },
                                tooltip: 'Chỉnh sửa',
                                splashRadius: 20,
                              ),
                              IconButton(
                                icon: Icon(
                                  isBanned ? Icons.check_circle_outline : Icons.block,
                                  size: 18,
                                  color: isBanned ? Colors.orange : Colors.red,
                                ),
                                onPressed: () => _showBanUserDialog(context, user),
                                tooltip: isBanned ? 'Bỏ cấm' : 'Cấm người dùng',
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBanUserDialog(BuildContext context, UserModel user) {
    final isBanned = user.isBanned ?? false;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBanned ? 'Bỏ cấm người dùng' : 'Cấm người dùng'),
        content: Text(
          isBanned
              ? 'Bạn có chắc chắn muốn bỏ cấm người dùng ${user.name} không?'
              : 'Bạn có chắc chắn muốn cấm người dùng ${user.name} không? Họ sẽ không thể đăng nhập vào hệ thống.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              
              try {
                await _userController.banUser(user.uid, !isBanned);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isBanned 
                        ? 'Đã bỏ cấm người dùng ${user.name}'
                        : 'Đã cấm người dùng ${user.name}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: $e'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: Text(
              isBanned ? 'Bỏ cấm' : 'Cấm',
              style: TextStyle(
                color: isBanned ? Colors.orange : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
