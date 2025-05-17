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
  Voucher(id: 'voucher001', code: 'A1B2C', discountAmount: 10000, isActive: true),
  Voucher(id: 'voucher002', code: 'D3E4F', discountAmount: 20000, isActive: true),
  Voucher(id: 'voucher003', code: 'G5H6I', discountAmount: 50000, isActive: true),
  Voucher(id: 'voucher004', code: 'J7K8L', discountAmount: 100000, isActive: true),
  Voucher(id: 'voucher005', code: 'M9N0P', discountAmount: 10000, isActive: true),
  Voucher(id: 'voucher006', code: 'Q1R2S', discountAmount: 20000, isActive: true),
  Voucher(id: 'voucher007', code: 'T3U4V', discountAmount: 50000, isActive: true),
  Voucher(id: 'voucher008', code: 'W5X6Y', discountAmount: 100000, isActive: true),
  Voucher(id: 'voucher009', code: 'Z7A8B', discountAmount: 10000, isActive: true),
  Voucher(id: 'voucher010', code: 'C9D0E', discountAmount: 50000, isActive: true),
  Voucher(id: 'voucher011', code: 'F1G2H', discountAmount: 20000, isActive: true),
  Voucher(id: 'voucher012', code: 'I3J4K', discountAmount: 100000, isActive: true),
  Voucher(id: 'voucher013', code: 'L5M6N', discountAmount: 10000, isActive: true),
  Voucher(id: 'voucher014', code: 'O7P8Q', discountAmount: 50000, isActive: true),
  Voucher(id: 'voucher015', code: 'R9S0T', discountAmount: 20000, isActive: true),
  Voucher(id: 'voucher016', code: 'U1V2W', discountAmount: 100000, isActive: true),
  Voucher(id: 'voucher017', code: 'X3Y4Z', discountAmount: 10000, isActive: true),
  Voucher(id: 'voucher018', code: 'A5C6E', discountAmount: 50000, isActive: true),
  Voucher(id: 'voucher019', code: 'B7D8F', discountAmount: 20000, isActive: true),
Voucher(id: 'voucher020', code: 'G9H0I', discountAmount: 100000, isActive: true),
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
