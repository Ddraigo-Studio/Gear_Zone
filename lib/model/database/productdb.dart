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
        id: 'prod1',
        name: 'Acer Swift 3',
        description: 'Laptop mỏng nhẹ, hiệu năng cao cho công việc văn phòng.',
        price: 17390000,
        originalPrice: 20990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        additionalImages: [
          'https://i.imgur.com/another_image1.jpg',
          'https://i.imgur.com/another_image2.jpg',
        ],
        category: 'Laptop',
        brand: 'Acer',
        processor: 'AMD Ryzen™ 7 6800U',
        ram: '16GB LPDDR5 6400MHz',
        storage: '1TB PCIe NVMe SSD',
        graphicsCard: 'AMD Radeon Graphics',
        display: '16" WQUXGA OLED',
        operatingSystem: 'Windows 11 Home',
        keyboard: 'Backlit, có phím số',
        audio: 'DTS Audio',
        wifi: 'Wi-Fi 6E AX211',
        bluetooth: 'Bluetooth 5.2',
        battery: '54 Wh 3-cell Li-ion',
        weight: '1.1 kg',
        color: 'Flax White',
        dimensions: '356.7 x 242.3 x 13.95 mm',
        security: 'Fingerprint',
        webcam: '1080p HD',
        ports: ['USB Type-C', 'HDMI', 'USB 3.2', '3.5mm Audio'],
        quantity: '50',
        status: 'Còn hàng',
        inStock: true,
        discount: 17,
        promotions: ['Tặng balo', 'Giảm thêm 500k khi thanh toán online'],
        warranty: '12 tháng',
      ),
      ProductModel(
        id: 'prod2',
        name: 'Dell XPS 13',
        description: 'Laptop cao cấp với màn hình InfinityEdge.',
        price: 21990000,
        originalPrice: 24990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Laptop',
        brand: 'Dell',
        processor: 'Intel Core i7-1165G7',
        ram: '16GB LPDDR4x',
        storage: '512GB SSD',
        graphicsCard: 'Intel Iris Xe',
        display: '13.4" 4K UHD+',
        operatingSystem: 'Windows 11 Pro',
        keyboard: 'Backlit',
        audio: 'Waves MaxxAudio',
        wifi: 'Wi-Fi 6 AX1650',
        bluetooth: 'Bluetooth 5.1',
        battery: '52 Wh',
        weight: '1.2 kg',
        color: 'Silver',
        dimensions: '295.7 x 198.7 x 14.8 mm',
        security: 'Fingerprint',
        webcam: '720p HD',
        ports: ['Thunderbolt 4', 'USB-C', '3.5mm Audio'],
        quantity: '30',
        status: 'Còn hàng',
        inStock: true,
        discount: 12,
        promotions: ['Tặng chuột không dây'],
        warranty: '24 tháng',
      ),
      // Thêm 8 sản phẩm khác (tương tự như trong code trước)
      ProductModel(
        id: 'prod3',
        name: 'Asus ROG Zephyrus G14',
        description: 'Laptop gaming mạnh mẽ, thiết kế nhỏ gọn.',
        price: 29990000,
        originalPrice: 34990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Laptop Gaming',
        brand: 'Asus',
        processor: 'AMD Ryzen 9 5900HS',
        ram: '32GB DDR4',
        storage: '1TB NVMe SSD',
        graphicsCard: 'NVIDIA RTX 3060',
        display: '14" QHD 120Hz',
        operatingSystem: 'Windows 10 Home',
        keyboard: 'RGB Backlit',
        audio: 'Dolby Atmos',
        wifi: 'Wi-Fi 6',
        bluetooth: 'Bluetooth 5.0',
        battery: '76 Wh',
        weight: '1.6 kg',
        color: 'Moonlight White',
        dimensions: '324 x 222 x 19.9 mm',
        security: 'None',
        webcam: 'None',
        ports: ['USB Type-C', 'HDMI 2.0b', 'USB 3.2'],
        quantity: '20',
        status: 'Còn hàng',
        inStock: true,
        discount: 14,
        promotions: ['Tặng bàn di chuột'],
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod4',
        name: 'LG UltraFine 27UL850',
        description: 'Màn hình 27 inch, độ phân giải 4K.',
        price: 7990000,
        originalPrice: 9990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Màn hình',
        brand: 'LG',
        display: '27" 4K UHD IPS',
        ports: ['HDMI', 'DisplayPort', 'USB-C'],
        quantity: '15',
        status: 'Còn hàng',
        inStock: true,
        discount: 20,
        warranty: '12 tháng',
      ),
      ProductModel(
        id: 'prod5',
        name: 'Intel Core i9-12900K',
        description: 'CPU cao cấp cho hiệu năng vượt trội.',
        price: 14990000,
        originalPrice: 16990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'CPU',
        brand: 'Intel',
        processor: '16 cores, 24 threads',
        quantity: '25',
        status: 'Còn hàng',
        inStock: true,
        discount: 12,
        warranty: '36 tháng',
      ),
      ProductModel(
        id: 'prod6',
        name: 'Corsair Vengeance RGB Pro 32GB',
        description: 'RAM DDR4 với hiệu năng cao và đèn RGB.',
        price: 3990000,
        originalPrice: 4990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'RAM',
        brand: 'Corsair',
        ram: '32GB DDR4 3200MHz',
        quantity: '40',
        status: 'Còn hàng',
        inStock: true,
        discount: 20,
        warranty: '36 tháng',
      ),
      ProductModel(
        id: 'prod7',
        name: 'Samsung 970 EVO Plus 1TB',
        description: 'Ổ SSD NVMe tốc độ cao.',
        price: 3990000,
        originalPrice: 4990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Ổ cứng',
        brand: 'Samsung',
        storage: '1TB NVMe SSD',
        quantity: '50',
        status: 'Còn hàng',
        inStock: true,
        discount: 20,
        warranty: '60 tháng',
      ),
      ProductModel(
        id: 'prod8',
        name: 'Logitech G Pro X',
        description: 'Tai nghe gaming với âm thanh vòm 7.1.',
        price: 2990000,
        originalPrice: 3490000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Tai nghe',
        brand: 'Logitech',
        audio: '7.1 Surround Sound',
        quantity: '30',
        status: 'Còn hàng',
        inStock: true,
        discount: 14,
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod9',
        name: 'Razer DeathAdder V2',
        description: 'Chuột gaming với cảm biến 20K DPI.',
        price: 1990000,
        originalPrice: 2490000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Chuột',
        brand: 'Razer',
        quantity: '35',
        status: 'Còn hàng',
        inStock: true,
        discount: 20,
        warranty: '24 tháng',
      ),
      ProductModel(
        id: 'prod10',
        name: 'Cooler Master MasterBox Q300L',
        description: 'Vỏ case PC nhỏ gọn, hỗ trợ tản nhiệt tốt.',
        price: 1490000,
        originalPrice: 1990000,
        imageUrl: 'https://i.imgur.com/OdAO6rc.jpg',
        category: 'Case',
        brand: 'Cooler Master',
        dimensions: '381 x 210 x 370 mm',
        quantity: '20',
        status: 'Còn hàng',
        inStock: true,
        discount: 25,
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