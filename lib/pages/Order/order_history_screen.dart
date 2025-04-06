import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/tab_page/order_tab_page.dart';

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
      if (tabIndex != tabviewController.index) {
        setState(() {
          tabIndex = tabviewController.index;
        });
      }
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
                    OrderTabPage(),
                    OrderTabPage(),
                    OrderTabPage(),
                    OrderTabPage(),
                    OrderTabPage(),
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
      elevation: 2,
      toolbarHeight: 80.h,
      backgroundColor: appTheme.whiteA700,
      leading: IconButton(
        icon: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          height: 25.h,
          width: 25.h,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 45.h,
            height: 45.h,
            decoration: AppDecoration.fillDeepPurpleF.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder28,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            padding: EdgeInsets.all(8.h),
            child: AppbarImage(
              imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
              height: 20.h,
              width: 20.h,
            ),
          ),
          onPressed: () {
            // Hành động khi nhấn vào nút giỏ hàng
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tabIndex == index
              ? theme.colorScheme.primary
              : appTheme.gray100,
          borderRadius: BorderRadius.circular(14.h),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
          child: Text(title),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmptyOrderMessage(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 22,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgOrderEmpty,
            height: 100.h,
            width: 102.h,
          ),
          Text(
            "Bạn chưa có đơn hàng nào cả",
            style: CustomTextStyles.headlineSmallBalooBhai,
          ),
          CustomElevatedButton(
            height: 58.h,
            text: "Tiếp tục mua hàng",
            margin: EdgeInsets.only(
              left: 66.h,
              right: 68.h,
            ),
            buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
          ),
        ],
      ),
    );
  }

}
