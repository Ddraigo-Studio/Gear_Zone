import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'core/app_export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'controller/cart_controller.dart';
import 'controller/auth_controller.dart';
import 'controller/review_controller.dart';
import 'core/app_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          // Initialize AuthController
          final authController = AuthController();
          authController.initAuth();
          return authController;
        }),
        ChangeNotifierProvider(create: (context) {
          // Initialize CartController
          final cartController = CartController();

          // Load real cart data instead of sample items
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Tải giỏ hàng local cho trường hợp khách vãng lai
            // Nếu sau này user đăng nhập, sẽ tự động merge với dữ liệu Firestore
            await cartController.loadCartFromLocalStorage();

            // Kiểm tra user đã đăng nhập
            final auth = FirebaseAuth.instance;
            if (auth.currentUser != null) {
              await cartController.loadCartFromFirestore(auth.currentUser!.uid);
            }
          });

          return cartController;
        }),
        ChangeNotifierProvider(
          create: (_) => ReviewController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: theme,
            title: 'gear_zone',
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
