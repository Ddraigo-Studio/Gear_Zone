import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../category.dart';
import 'package:flutter/services.dart';
import '../../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Create Sample Categories')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await createSampleCategories();
            },
            child: Text('Upload Categories to Firebase'),
          ),
        ),
      ),
    );
  }
}

Future<void> createSampleCategories() async {
  try {
    // Kiểm tra Firebase đã khởi tạo chưa
    if (Firebase.apps.isEmpty) {
      print('Error: Firebase is not initialized');
      return;
    }
    print('Firebase initialized successfully');

    final firestore = FirebaseFirestore.instance;
    final categoriesCollection = firestore.collection('categories');
    final batch = firestore.batch(); // Sử dụng batch để thêm nhiều document

    // Danh sách các danh mục
    final sampleCategories = [
      CategoryModel(
        id: 'cate1',
        imagePath: 'https://i.imgur.com/N1Dv3pw.png',
        categoryName: 'Laptop',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate2',
        imagePath: 'https://i.imgur.com/N1Dv3pw.png',
        categoryName: 'Laptop Gaming',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate3',
        imagePath: 'https://i.imgur.com/4Qw0lmd.png',
        categoryName: 'PC',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate4',
        imagePath: 'https://i.imgur.com/0yMhS1R.png',
        categoryName: 'Màn hình',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate5',
        imagePath: 'https://i.imgur.com/nEyJTEK.png',
        categoryName: 'Mainboard',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate6',
        imagePath: 'https://i.imgur.com/LmEoUkv.png',
        categoryName: 'CPU',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate7',
        imagePath: 'https://i.imgur.com/nY37Hjd.png',
        categoryName: 'VGA',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate8',
        imagePath: 'https://i.imgur.com/ktYbmtd.png',
        categoryName: 'RAM',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate9',
        imagePath: 'https://i.imgur.com/Xx9NBUE.png',
        categoryName: 'Ổ cứng',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate10',
        imagePath: 'https://i.imgur.com/ppGKk80.png',
        categoryName: 'Case',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate11',
        imagePath: 'https://i.imgur.com/c2rDlae.png',
        categoryName: 'Tản nhiệt',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate12',
        imagePath: 'https://i.imgur.com/6Coz29c.png',
        categoryName: 'Nguồn',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate13',
        imagePath: 'https://i.imgur.com/nEyJTEK.png',
        categoryName: 'Bàn phím',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate14',
        imagePath: 'https://i.imgur.com/IWvvZin.png',
        categoryName: 'Chuột',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate15',
        imagePath: 'https://i.imgur.com/OTN7mRy.png',
        categoryName: 'Tai nghe',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate16',
        imagePath: 'https://i.imgur.com/SDRzcJZ.png',
        categoryName: 'Loa',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
      CategoryModel(
        id: 'cate17',
        imagePath: 'https://i.imgur.com/7xMJ2k4.png',
        categoryName: 'Micro',
        ceatedAt: DateTime.now().toIso8601String(),
      ),
    ];    

    // Thêm từng danh mục vào batch
    for (var category in sampleCategories) {
      print('Preparing to add category: ${category.categoryName}');
      batch.set(categoriesCollection.doc(category.id), category.toMap());
    }

    // Thực thi batch
    print('Committing batch to Firestore...');
    await batch.commit();
    print('Successfully created ${sampleCategories.length} sample categories!');
  } catch (e) {
    print('Error creating sample categories: $e');
  }
}
