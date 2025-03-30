import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/bottom_sheet/add_voucher_bottomsheet.dart';
import '../../widgets/bottom_sheet/product_variant_bottomsheet.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Text(
                        "App Navigation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF000000),
                          fontSize: 20.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: Text(
                        "Check your app's UI from the below demo screens of your app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 16.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: Color(0xFF000000),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add_Profile",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.addProfileScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Address new",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.addressNewScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.homeScreen),
                        ),
                        // _buildScreenTitle(
                        //   context,
                        //   screenTitle: "PlashScreenTwo",
                        //   onTapScreenTitle: () => onTapScreenTitle(
                        //     context, AppRoutes.plashscreentwoScreen),
                        // ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "PlashScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.plashScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification_Empty",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.notificationEmptyScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notifications",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.notificationsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Orders History",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.ordersHistoryScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Orders History_Empty",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.ordersHistoryEmptyScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Orders_Detail",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.ordersDetailScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "CategoriesOne",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.categoriesScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "CategoriesTwo",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.categoriestwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search_Result_Empty",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.searchResultEmptyScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search Result",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.searchResultScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Product",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.productDetail),
                        ),
                      
                        _buildScreenTitle(
                          context,
                          screenTitle: "Empty_Cart",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.emptyCartScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "My_Cart",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.myCartScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Checkout",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.checkoutScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Method_Checkout",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.methodCheckoutScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Order_Placed",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.orderPlacedScreen),
                        ),
                        // _buildScreenTitle(
                        //   context,
                        //   screenTitle: "Add_Voucher - BottomSheet",
                        //   onTapScreenTitle: () => onTapBottomSheetTitle(
                        //     context, AddVoucherBottomsheet()),
                        // ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Voucher_Detail",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.voucherDetailScreen),
                        ),
                        // _buildScreenTitle(
                        //   context,
                        //   screenTitle: "Product_Variant - BottomSheet",
                        //   onTapScreenTitle: () => onTapBottomSheetTitle(
                        //     context, ProductVariantBottomSheet()),
                        // ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Settings",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.settingsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Edit_Profile",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.editProfileScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "List_Address",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.listAddressScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add_Address",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.addAddressScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "List_Favorite",
                          onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.listFavoriteScreen),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Common click event for bottomsheets
  void onTapBottomSheetTitle(
    BuildContext context,
    Widget className,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return className;
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 5.h),
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: Color(0xFF888888),
            ),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
  
}
