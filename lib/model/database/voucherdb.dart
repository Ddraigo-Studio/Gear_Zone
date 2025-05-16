import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../firebase_options.dart';
import '../Voucher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(VoucherApp());
}

class VoucherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Create Sample Vouchers')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await createSampleVouchers();
            },
            child: Text('Create 10 Sample Vouchers'),
          ),
        ),
      ),
    );
  }
}

Future<void> createSampleVouchers() async {
  try {
    if (Firebase.apps.isEmpty) {
      print('Error: Firebase is not initialized');
      return;
    }
    print('Firebase initialized successfully');

    final firestore = FirebaseFirestore.instance;
    final vouchersCollection = firestore.collection('vouchers');
    final batch = firestore.batch();

    final sampleVouchers = [
      Voucher(
        id: 'voucher001',
        code: 'GEAR10OFF',
        discountPercentage: 10,
        minimumOrderAmount: 1000000,
        maximumDiscountAmount: 500000,
        expirationDate: DateTime(2025, 12, 31),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2025, 12, 31),
        applicableProducts: ['Laptop Gaming', 'Màn hình'],
        paymentMethods: ['Thẻ nội địa Napas', 'Thanh toán ví Momo'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher002',
        code: 'SUMMER20',
        discountPercentage: 20,
        minimumOrderAmount: 2000000,
        maximumDiscountAmount: 1000000,
        expirationDate: DateTime(2025, 8, 31),
        validFromDate: DateTime(2025, 6, 1),
        validToDate: DateTime(2025, 8, 31),
        applicableProducts: ['Loa', 'Case'],
        paymentMethods: ['Thanh toán ví Momo'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher003',
        code: 'WELCOME15',
        discountPercentage: 15,
        minimumOrderAmount: 500000,
        maximumDiscountAmount: 300000,
        expirationDate: DateTime(2026, 1, 31),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2026, 1, 31),
        applicableProducts: [],
        paymentMethods: ['All'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher004',
        code: 'GAMING25',
        discountPercentage: 25,
        minimumOrderAmount: 3000000,
        maximumDiscountAmount: 1500000,
        expirationDate: DateTime(2025, 11, 30),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2025, 11, 30),
        applicableProducts: ['Laptop Gaming'],
        paymentMethods: ['Thẻ nội địa Napas', 'Thanh toán khi nhận hàng'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher005',
        code: 'FLASH5',
        discountPercentage: 5,
        minimumOrderAmount: 200000,
        maximumDiscountAmount: 100000,
        expirationDate: DateTime(2025, 6, 30),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2025, 6, 30),
        applicableProducts: ['Màn hình', 'Loa'],
        paymentMethods: ['Thanh toán khi nhận hàng'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher006',
        code: 'BIGSALE30',
        discountPercentage: 30,
        minimumOrderAmount: 5000000,
        maximumDiscountAmount: 2000000,
        expirationDate: DateTime(2025, 12, 15),
        validFromDate: DateTime(2025, 11, 1),
        validToDate: DateTime(2025, 12, 15),
        applicableProducts: ['Laptop Gaming', 'Case'],
        paymentMethods: ['Thẻ nội địa Napas'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher007',
        code: 'NEWUSER10',
        discountPercentage: 10,
        minimumOrderAmount: 300000,
        maximumDiscountAmount: 200000,
        expirationDate: DateTime(2026, 3, 31),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2026, 3, 31),
        applicableProducts: [],
        paymentMethods: ['All'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher008',
        code: 'MONITOR15',
        discountPercentage: 15,
        minimumOrderAmount: 1000000,
        maximumDiscountAmount: 500000,
        expirationDate: DateTime(2025, 10, 31),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2025, 10, 31),
        applicableProducts: ['Màn hình'],
        paymentMethods: ['Thanh toán ví Momo', 'Thanh toán khi nhận hàng'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher009',
        code: 'CASE20',
        discountPercentage: 20,
        minimumOrderAmount: 500000,
        maximumDiscountAmount: 300000,
        expirationDate: DateTime(2025, 9, 30),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2025, 9, 30),
        applicableProducts: ['Case'],
        paymentMethods: ['Thẻ nội địa Napas'],
        isActive: true,
      ),
      Voucher(
        id: 'voucher010',
        code: 'FREESHIP',
        discountPercentage: 100,
        minimumOrderAmount: 1000000,
        maximumDiscountAmount: 100000,
        expirationDate: DateTime(2025, 7, 31),
        validFromDate: DateTime(2025, 5, 17),
        validToDate: DateTime(2025, 7, 31),
        applicableProducts: [],
        paymentMethods: ['All'],
        isActive: true,
      ),
    ];

    for (var voucher in sampleVouchers) {
      print('Preparing to add voucher: ${voucher.code}');
      batch.set(vouchersCollection.doc(voucher.id), voucher.toMap());
    }

    print('Committing batch to Firestore...');
    await batch.commit();
    print('Successfully created 10 sample vouchers!');
  } catch (e) {
    print('Error creating sample vouchers: $e');
  }
}