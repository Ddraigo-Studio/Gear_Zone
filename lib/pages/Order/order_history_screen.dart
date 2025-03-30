import 'package:flutter/material.dart';
import '../../core/app_export.dart';
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
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPurchaseHistoryRow(context),
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
  Widget _buildPurchaseHistoryRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 24.h),
      decoration: AppDecoration.outlineBlack9001,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lịch sử mua hàng",
            style: theme.textTheme.headlineSmall,
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.h, bottom: 24.h),
            child: CustomIconButton(
              height: 36.h,
              width: 44.h,
              padding: EdgeInsets.all(6.h),
              decoration: IconButtonStyleHelper.outlineBlack,
              child: CustomImageView(
                imagePath: ImageConstant.imgIconsaxBrokenBag2WhiteA700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 24.h),
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
      height: 30,
      child: Container(
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
