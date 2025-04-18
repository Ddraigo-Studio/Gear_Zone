import 'package:flutter/material.dart';

// Account
import '../pages/Account/login.dart';
import '../pages/Account/signup.dart';

// Cart
import '../pages/Cart/cart_screen.dart';

// Checkout
import '../pages/Checkout/checkout_screen.dart';
import '../pages/Checkout/payment_method_screen.dart';
import '../pages/Checkout/payment_success.dart';

// Create_Profile
import '../pages/Create_Profile/add_profile_screen.dart';
import '../pages/Create_Profile/address_new_screen.dart';

//Home
import '../pages/Home/home_screen.dart';
import '../pages/Home/home_initial_page.dart'; // Add this import for HomeInitialPage

// Order
import '../pages/Order/order_detail_screen.dart';
import '../pages/Order/order_history_screen.dart';

// Plash_Screen
import '../pages/Plash_Screen/plash_screen.dart';

// Products
import '../pages/Products/category_screen.dart';
import '../pages/Products/product_detail.dart';

// Profile
import '../pages/Profile/edit_profile_screen.dart';
import '../pages/Profile/list_address_screen.dart'; 
import '../pages/Profile/add_address_screen.dart'; 

// Search Product
import '../pages/Search_Product/search_result_screen.dart';

// Setting
import '../pages/Setting/setting_screen.dart';

import '../pages/Voucher/voucher_detail_screen.dart';


class AppRoutes {
  static const String addProfileScreen = '/add_profile_screen';
  static const String addressNewScreen = '/address_new_screen';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homeScreen = '/home_screen';
  static const String homeInitialPage = '/home_initial_page';
  static const String plashScreen = '/plash_screen';
  static const String notificationEmptyScreen = '/notification_empty_screen';
  static const String notificationsScreen = '/notifications_screen';
  static const String ordersHistoryScreen = '/orders_history_screen';
  static const String ordersHistoryEmptyScreen = '/orders_history_empty_screen';
  static const String ordersDetailScreen = '/order_detail_screen';
  static const String categoriesScreen = '/category_screen';
  static const String categoriestwoScreen = '/categoriestwo_screen';
  static const String searchResultEmptyScreen = '/search_result_empty_screen';
  static const String searchResultScreen = '/search_result_screen';
  static const String productDetail = '/product_detail';
  static const String emptyCartScreen = '/empty_cart_screen';
  static const String myCartScreen = '/cart_screen';
  static const String checkoutScreen = '/checkout_screen';
  static const String methodCheckoutScreen = '/payment_method_screen';
  static const String orderPlacedScreen = '/payment_success';
  static const String voucherDetailScreen = '/voucher_detail_screen';
  static const String settingsScreen = '/setting_screen';
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
    homeInitialPage: (context) => HomeInitialPage(), 
    plashScreen: (context) => PlashScreenScreen(),
    categoriesScreen: (context) => CategoriesScreen(),
    productDetail: (context) => ProductDetailScreen(),
    myCartScreen: (context) => MyCartScreen(),
    checkoutScreen: (context) => CheckoutScreen(), 
    methodCheckoutScreen: (context) => PaymentMethodScreen(),
    ordersDetailScreen: (context) => OrdersDetailScreen(), 
    // orderPlacedScreen: (context) => PaymentSuccess(), 
    // voucherDetailScreen: (context) => VoucherDetailScreen(),
    settingsScreen: (context) => SettingsScreen(),
    editProfileScreen: (context) => EditProfileScreen(), 
    listAddressScreen: (context) => ListAddressScreen(), 
    addAddressScreen: (context) => AddAddressScreen(),
    initialRoute: (context) => HomeScreen(),
  };
}