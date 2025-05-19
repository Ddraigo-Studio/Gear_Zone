import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../firebase_options.dart';

/// Tạo đơn mẫu dựa trên dữ liệu users và products
Future<void> createSampleOrders({int count = 50}) async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final usersSnap = await firestore.collection('users').get();
  final productsSnap = await firestore.collection('products').get();
  final userDocs = usersSnap.docs;
  final productDocs = productsSnap.docs;

  if (userDocs.isEmpty || productDocs.isEmpty) {
    print('Không có users hoặc products để tạo đơn.');
    return;
  }

  final rng = Random();
  final statuses = ['Chờ xử lý', 'Đã xác nhận', 'Đang giao', 'Hoàn thành', 'Đã hủy'];
  final paymentMethods = ['Thanh toán khi nhận hàng', 'Chuyển khoản', 'Ví điện tử'];

  for (int i = 0; i < count; i++) {
    final user = userDocs[rng.nextInt(userDocs.length)];
    final int itemCount = rng.nextInt(5) + 1;
    double subtotal = 0;
    final List<Map<String, dynamic>> items = [];

    for (int j = 0; j < itemCount; j++) {
      final prod = productDocs[rng.nextInt(productDocs.length)];
      final data = prod.data();
      final price = (data['price'] as num).toDouble();
      final qty = rng.nextInt(3) + 1;
      subtotal += price * qty;
      items.add({
        'productId': prod.id,
        'productName': data['name'],
        'quantity': qty,
        'price': price,
      });
    }

    const double shippingFee = 30000;
    final double voucherDiscount = rng.nextBool()
        ? (rng.nextBool() ? 50000 : 100000)
        : 0;
    final double total = subtotal + shippingFee - voucherDiscount;

    final DateTime now = DateTime.now();
    final DateTime orderDate = now.subtract(Duration(
      days: rng.nextInt(180),
      hours: rng.nextInt(24),
      minutes: rng.nextInt(60),
    ));

    final String orderId = firestore.collection('orders').doc().id;
    batch.set(firestore.collection('orders').doc(orderId), {
      'id': orderId,
      'userId': user.id,
      'items': items,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'voucherDiscount': voucherDiscount,
      'total': total,
      'status': statuses[rng.nextInt(statuses.length)],
      'paymentMethod': paymentMethods[rng.nextInt(paymentMethods.length)],
      'orderDate': orderDate.toIso8601String(),
    });
  }

  await batch.commit();
  print('Đã tạo xong $count đơn hàng mẫu!');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Tạo mẫu đơn (thay 100 bằng số lượng mong muốn)
  await createSampleOrders(count: 100);

  // Khởi chạy UI
  runApp(MyApp());
}

/// Ứng dụng đơn giản sau khi tạo mẫu đơn
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Orders Generator',
      home: Scaffold(
        appBar: AppBar(title: Text('Order Generator')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  'Đã tạo xong đơn hàng mẫu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text('Tạo lại đơn mẫu'),
                  onPressed: () async {
                    await createSampleOrders(count: 100);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã sinh thêm 100 đơn mẫu')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
