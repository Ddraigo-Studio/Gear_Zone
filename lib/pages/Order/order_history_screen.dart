import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/tab_page/order_tab_page.dart';
import '../../widgets/cart_icon_button.dart';

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

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 5, vsync: this);

    tabviewController.addListener(() {
      setState(() {
        tabIndex = tabviewController.index;
      });
    });
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
              _buildTabview(context),
              Expanded(
                child: TabBarView(
                  controller: tabviewController,
                  children: const [
                    OrderTabPage(status: "Chờ xử lý"),
                    OrderTabPage(status: "Đang giao"),
                    OrderTabPage(status: "Đã nhận"),
                    OrderTabPage(status: "Trả hàng"),
                    OrderTabPage(status: "Đã hủy"),
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
        CartIconButton(
          onPressed: () {
            // Navigate to cart screen
            Navigator.pushNamed(context, AppRoutes.myCartScreen);
          },
        ),
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
        tabs: [
          _buildTabItem("Chờ xác nhận", 0),
          _buildTabItem("Chờ giao hàng", 1),
          _buildTabItem("Đã giao", 2),
          _buildTabItem("Trả hàng", 3),
          _buildTabItem("Đã hủy", 4),
        ],
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
