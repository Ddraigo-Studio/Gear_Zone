import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/tab_page/order_tab_page.dart';
import '../../widgets/cart_icon_button.dart';
import '../../controller/auth_controller.dart';
import '../../controller/order_controller.dart';
import '../../model/order.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  OrdersHistoryScreenState createState() => OrdersHistoryScreenState();
}

// ignore_for_file: must_be_immutable
class OrdersHistoryScreenState extends State<OrdersHistoryScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  int tabIndex = 0;
  final OrderController _orderController = OrderController();
  Stream<List<OrderModel>>? _userOrdersStream;
  bool _isLoading = true;
  String? _errorMessage;
    
  // Define status options to match admin's status values
  final List<Map<String, dynamic>> _statusOptions = [
    {'value': 'Chờ xử lý', 'label': 'Chờ xử lý', 'color': Colors.orange},
    {'value': 'Đã xác nhận', 'label': 'Đã xác nhận', 'color': Colors.purple},
    {'value': 'Đang giao', 'label': 'Đang giao', 'color': Colors.blue},
    {'value': 'Đã nhận', 'label': 'Đã nhận', 'color': Colors.green},
    {'value': 'Trả hàng', 'label': 'Trả hàng', 'color': Colors.amber},
    {'value': 'Đã hủy', 'label': 'Đã hủy', 'color': Colors.red},
  ];
    @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: _statusOptions.length, vsync: this);

    tabviewController.addListener(() {
      if (tabviewController.indexIsChanging) {
        // This ensures we only update state when the tab is actually changing
        setState(() {
          tabIndex = tabviewController.index;
        });
      }
    });
    
    // Load user's orders after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserOrders();
    });
  }
    // Load orders for the current user - optimized to prevent unnecessary rebuilds
  void _loadUserOrders() {
    final authController = Provider.of<AuthController>(context, listen: false);
    
    if (authController.isAuthenticated && authController.userModel != null) {
      final userId = authController.userModel!.uid;
      
      // Create the stream before updating state to avoid multiple rebuilds
      final ordersStream = _orderController.getOrdersByUserId(userId);
      
      // Only do a single setState call with all updates
      setState(() {
        _userOrdersStream = ordersStream;
        _isLoading = false;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _userOrdersStream = null;
        _errorMessage = "Vui lòng đăng nhập để xem lịch sử đơn hàng";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAppBar(context),
              SizedBox(height: 16.h),
              
              if (_isLoading)
                // Show loading state
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                // Show authentication error
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _errorMessage!,
                          style: TextStyle(fontSize: 16.h, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/loginScreen');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.h),
                            ),
                          ),
                          child: Text(
                            "Đăng nhập",
                            style: CustomTextStyles.titleMediumBalooBhai2Gray900.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Show order tabs
                Expanded(
                  child: Column(
                    children: [
                      _buildTabview(context),
                      Expanded(
                        child: TabBarView(
                          controller: tabviewController,
                          children: _statusOptions.map((status) => 
                            OrderTabPage(status: status['value'], orderStream: _userOrdersStream)
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: appTheme.whiteA700,
      centerTitle: true,
      title: AppbarSubtitleTwo(
        text: "Lịch sử đơn hàng",
      ),
      actions: [
        CartIconButton(),
      ],
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: TabBar(
        controller: tabviewController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: appTheme.whiteA700,
        labelStyle: CustomTextStyles.titleMediumBalooBhai2Gray900,
        unselectedLabelColor: appTheme.gray700,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Baloo Bhai',
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        onTap: (index) {
          setState(() {
            tabIndex = index; // Update tabIndex immediately on tap
          });
        },
        tabs: List.generate(
          _statusOptions.length,
          (index) => _buildTabItem(_statusOptions[index]['label'], index),
        ),
      ),
    );
  }

  Tab _buildTabItem(String title, int index) {
    return Tab(
      height: 50,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 300), // Smooth animation duration
        curve: Curves.easeInOut, // Smooth animation curve
        margin: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              tabIndex == index ? theme.colorScheme.primary : appTheme.gray100,
          borderRadius: BorderRadius.circular(14.h),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
          child: Text(title),
        ),
      ),
    );
  }
}
