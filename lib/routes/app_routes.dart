import 'package:flutter/material.dart';

// Account
import '../pages/Account/login.dart';
import '../pages/Account/signup.dart';

//Home
import '../pages/Home/home_screen.dart';

// Create_Profile
import '../pages/Create_Profile/add_profile_screen.dart';
import '../pages/Create_Profile/address_new_screen.dart';

// Profile
import '../pages/Profile/add_address_screen.dart';

// import '../pages/address_new_screen/address_new_screen.dart';
// import '../pages/app_navigation_screen/app_navigation_screen.dart';
// import '../pages/categoriesone_screen/categoriesone_screen.dart';
// import '../pages/categoriestwo_screen/categoriestwo_screen.dart';
// import '../pages/checkout_screen/checkout_screen.dart';
// import '../pages/edit_profile_screen/edit_profile_screen.dart';
// import '../pages/empty_cart_screen/empty_cart_screen.dart';

// import '../pages/list_address_screen/list_address_screen.dart';
// import '../pages/list_favorite_screen/list_favorite_screen.dart';
// import '../pages/method_checkout_screen/method_checkout_screen.dart';
// import '../pages/my_cart_screen/my_cart_screen.dart';
// import '../pages/notification_empty_screen/notification_empty_screen.dart';
// import '../pages/notifications_screen/notifications_screen.dart';
// import '../pages/order_placed_screen/order_placed_screen.dart';
// import '../pages/orders_detail_screen/orders_detail_screen.dart';
// import '../pages/orders_history_empty_screen/orders_history_empty_screen.dart';
// import '../pages/orders_history_screen/orders_history_screen.dart';
// import '../pages/plasscreenthree_one_screen/plasscreenthree_one_screen.dart';
// import '../pages/plasscreenthree_screen/plasscreenthree_screen.dart';
// import '../pages/plasscreentwo_screen/plasscreentwo_screen.dart';
// import '../pages/product_one_screen/product_one_screen.dart';
// import '../pages/product_screen/product_screen.dart';
// import '../pages/search_result_screen/search_result_screen.dart';
// import '../pages/search_result_screen/search_result_empty_screen.dart';
// import '../pages/settings_screen/settings_screen.dart';
// import '../pages/voucher_detail_screen/voucher_detail_screen.dart';

class AppRoutes {
  static const String addProfileScreen = '/add_profile_screen';
  static const String addressNewScreen = '/address_new_screen';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homeScreen = '/home_screen';
  static const String homeInitialPage = '/home_initial_page';
  static const String plashtwoscreentwoScreen = '/plashtwoscreentwo_screen';
  static const String plashtwoscreennoneScreen = '/plashtwoscreennone_screen';
  static const String plashtscreenthreeScreen = '/plashtscreenthree_screen';
  static const String plashtscreenthreeOneScreen = '/plashtscreenthree_one_screen';
  static const String notificationEmptyScreen = '/notification_empty_screen';
  static const String notificationsScreen = '/notifications_screen';
  static const String ordersHistoryScreen = '/orders_history_screen';
  static const String ordersTabPage = '/orders_tab_page';
  static const String ordersHistoryEmptyScreen = '/orders_history_empty_screen';
  static const String ordersTab1Page = '/orders_tab1_page';
  static const String ordersDetailScreen = '/orders_detail_screen';
  static const String categoriesoneScreen = '/categoriesone_screen';
  static const String categoriestwoScreen = '/categoriestwo_screen';
  static const String searchResultEmptyScreen = '/search_result_empty_screen';
  static const String searchResultScreen = '/search_result_screen';
  static const String productScreen = '/product_screen';
  static const String productUTabPage = '/product_u_tab_page';
  static const String productOneScreen = '/product_one_screen';
  static const String productTwoPage = '/product_two_page';
  static const String emptyCartScreen = '/empty_cart_screen';
  static const String myCartScreen = '/my_cart_screen';
  static const String checkoutScreen = '/checkout_screen';
  static const String methodCheckoutScreen = '/method_checkout_screen';
  static const String orderPlacedScreen = '/order_placed_screen';
  static const String voucherDetailScreen = '/voucher_detail_screen';
  static const String settingsScreen = '/settings_screen';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String listAddressScreen = '/list_address_screen';
  static const String addAddressScreen = '/add_address_screen';
  static const String listFavoriteScreen = '/list_favorite_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    addProfileScreen: (context) => AddProfileScreen(),
    addressNewScreen: (context) => AddressNewScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignUpScreen(),
    homeScreen: (context) => HomeScreen(),
    // plashscreentwoScreen: (context) => PlashscreentwoScreen(),
    // plashscreenoneScreen: (context) => PlashscreenoneScreen(),
    // plashscreenthreeScreen: (context) => PlashscreenthreeScreen(),
    // plashscreenthreeOneScreen: (context) => PlashscreenthreeOneScreen(),
    // notificationEmptyScreen: (context) => NotificationEmptyScreen(),
    // notificationsScreen: (context) => NotificationsScreen(),
    // ordersHistoryScreen: (context) => OrdersHistoryScreen(),
    // ordersHistoryEmptyScreen: (context) => OrdersHistoryEmptyScreen(),
    // ordersDetailScreen: (context) => OrdersDetailScreen(),
    // categoriesoneScreen: (context) => CategoriesoneScreen(),
    // categoriestwoScreen: (context) => CategoriestwoScreen(),
    // searchResultEmptyScreen: (context) => SearchResultEmptyScreen(),
    // searchResultScreen: (context) => SearchResultScreen(),
    // productScreen: (context) => ProductScreen(),
    // productOneScreen: (context) => ProductOneScreen(),
    // emptyCartScreen: (context) => EmptyCartScreen(),
    // myCartScreen: (context) => MyCartScreen(),
    // checkoutScreen: (context) => CheckoutScreen(),
    // methodCheckoutScreen: (context) => MethodCheckoutScreen(),
    // orderPlacedScreen: (context) => OrderPlacedScreen(),
    // voucherDetailScreen: (context) => VoucherDetailScreen(),
    // settingsScreen: (context) => SettingsScreen(),
    // editProfileScreen: (context) => EditProfileScreen(),
    // listAddressScreen: (context) => ListAddressScreen(),
    addAddressScreen: (context) => AddAddressScreen(),
    // listFavoriteScreen: (context) => ListFavoriteScreen(),
    // appNavigationScreen: (context) => AppNavigationScreen(),
    // initialRoute: (context) => PlashscreenthreeOneScreen()
  };



}
