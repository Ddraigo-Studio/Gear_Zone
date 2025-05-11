import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../product.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Create Sample Products')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await createSampleProducts();
            },
            child: Text('Create 10 Sample Products'),
          ),
        ),
      ),
    );
  }
}

Future<void> createSampleProducts() async {
  try {
    // Kiểm tra Firebase đã khởi tạo chưa
    if (Firebase.apps.isEmpty) {
      print('Error: Firebase is not initialized');
      return;
    }
    print('Firebase initialized successfully');

    final firestore = FirebaseFirestore.instance;
    final productsCollection = firestore.collection('products');
    final batch = firestore.batch(); // Sử dụng batch để thêm nhiều document

    // Danh sách 10 sản phẩm mẫu
    final sampleProducts = [
      ProductModel(
        id: 'prod11',
        name: 'Gigabyte Laptop Gaming Model 11',
        description: 'Laptop Gaming chất lượng cao từ Gigabyte.',
        price: 21129141,
        originalPrice: 32301142,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Laptop Gaming',
        brand: 'Gigabyte',
        processor: 'Intel Core i7',
        ram: '16GB DDR4',
        storage: '1TB SSD',
        graphicsCard: 'NVIDIA RTX 3070',
        display: '15.6" FHD 144Hz',
        operatingSystem: 'Windows 11 Home',
        keyboard: 'RGB Backlit',
        audio: 'Dolby Audio',
        wifi: 'Wi-Fi 6',
        bluetooth: 'Bluetooth 5.2',
        battery: '76 Wh',
        weight: '2.6 kg',
        color: 'Gray',
        dimensions: '381 x 266 x 23 mm',
        security: 'Fingerprint',
        webcam: '720p HD',
        ports: ['USB Type-C', 'HDMI', 'USB 3.2'],
        quantity: '13',
        status: 'Còn hàng',
        inStock: true,
        discount: 18,
        promotions: ['Tặng balo'],
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod12',
        name: 'AOC Màn hình Model 12',
        description: 'Màn hình chất lượng cao từ AOC.',
        price: 24483585,
        originalPrice: 15374672,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Màn hình',
        brand: 'AOC',
        display: '27" FHD IPS',
        ports: ['HDMI', 'DisplayPort', 'USB-C'],
        quantity: '13',
        status: 'Còn hàng',
        inStock: true,
        discount: 15,
        warranty: '12 tháng',
      ),
      ProductModel(
        id: 'prod13',
        name: 'Logitech Loa Model 13',
        description: 'Loa chất lượng cao từ Logitech.',
        price: 8025749,
        originalPrice: 6290285,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Loa',
        brand: 'Logitech',
        audio: '5.1 Surround',
        quantity: '47',
        status: 'Còn hàng',
        inStock: true,
        discount: 14,
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod14',
        name: 'Thermaltake Case Model 14',
        description: 'Case chất lượng cao từ Thermaltake.',
        price: 22362216,
        originalPrice: 31640111,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Case',
        brand: 'Thermaltake',
        dimensions: '422 x 212 x 470 mm',
        quantity: '38',
        status: 'Còn hàng',
        inStock: true,
        discount: 18,
        warranty: '12 tháng',
      ),
      ProductModel(
        id: 'prod15',
        name: 'BenQ Màn hình Model 15',
        description: 'Màn hình chất lượng cao từ BenQ.',
        price: 7441712,
        originalPrice: 31254708,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Màn hình',
        brand: 'BenQ',
        display: '24" 144Hz TN',
        ports: ['HDMI', 'DisplayPort', 'USB-C'],
        quantity: '18',
        status: 'Còn hàng',
        inStock: true,
        discount: 20,
        warranty: '12 tháng',
      ),
      ProductModel(
        id: 'prod16',
        name: 'MSI Laptop Gaming Model 16',
        description: 'Laptop Gaming chất lượng cao từ MSI.',
        price: 25600000,
        originalPrice: 30000000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Laptop Gaming',
        brand: 'MSI',
        processor: 'AMD Ryzen 7',
        ram: '32GB DDR5',
        storage: '512GB SSD',
        graphicsCard: 'AMD RX 6700XT',
        display: '17.3" QHD 165Hz',
        operatingSystem: 'Windows 11 Home',
        keyboard: 'RGB Backlit',
        audio: 'Dolby Audio',
        wifi: 'Wi-Fi 6',
        bluetooth: 'Bluetooth 5.2',
        battery: '78 Wh',
        weight: '2.5 kg',
        color: 'Black',
        dimensions: '389 x 255 x 27 mm',
        security: 'Fingerprint',
        webcam: '720p HD',
        ports: ['USB Type-C', 'HDMI', 'USB 3.2'],
        quantity: '20',
        status: 'Còn hàng',
        inStock: true,
        discount: 15,
        promotions: ['Tặng chuột'],
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod17',
        name: 'Edifier Loa Model 17',
        description: 'Loa chất lượng cao từ Edifier.',
        price: 3900000,
        originalPrice: 4990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Loa',
        brand: 'Edifier',
        audio: '2.1 Stereo',
        quantity: '22',
        status: 'Còn hàng',
        inStock: true,
        discount: 22,
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod18',
        name: 'NZXT Case Model 18',
        description: 'Case chất lượng cao từ NZXT.',
        price: 1890000,
        originalPrice: 2490000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Case',
        brand: 'NZXT',
        dimensions: '430 x 210 x 460 mm',
        quantity: '28',
        status: 'Còn hàng',
        inStock: true,
        discount: 24,
        warranty: '12 tháng',
      ),
      ProductModel(
        id: 'prod19',
        name: 'ASUS Màn hình Model 19',
        description: 'Màn hình chất lượng cao từ ASUS.',
        price: 8590000,
        originalPrice: 9990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Màn hình',
        brand: 'ASUS',
        display: '32" QHD VA',
        ports: ['HDMI', 'DisplayPort', 'USB-C'],
        quantity: '25',
        status: 'Còn hàng',
        inStock: true,
        discount: 14,
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod20',
        name: 'Phanteks Case Model 20',
        description: 'Case chất lượng cao từ Phanteks.',
        price: 1790000,
        originalPrice: 2290000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Case',
        brand: 'Phanteks',
        dimensions: '410 x 215 x 450 mm',
        quantity: '17',
        status: 'Còn hàng',
        inStock: true,
        discount: 21,
        warranty: '12 tháng',
      ),
    ];

    // Thêm từng sản phẩm vào batch
    for (var product in sampleProducts) {
      print('Preparing to add product: ${product.name}');
      batch.set(productsCollection.doc(product.id), product.toMap());
    }

    // Thực thi batch
    print('Committing batch to Firestore...');
    await batch.commit();
    print('Successfully created 10 sample products!');
  } catch (e) {
    print('Error creating sample products: $e');
  }
}
