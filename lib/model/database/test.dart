import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
// Chỉ dùng khi chạy web; sẽ được tree-shaken khỏi native build.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'dart:io' show File, Directory, Platform;
import 'package:flutter/services.dart';

import '../../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khóa chỉ dọc
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> exportProductsToJson() =>
      exportCollectionToJson('products', 'products.json');
  Future<void> exportUsersToJson() =>
      exportCollectionToJson('users', 'users.json');
  Future<void> exportOrdersToJson() =>
      exportCollectionToJson('orders', 'orders.json');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Export Data',
      home: Scaffold(
        appBar: AppBar(title: Text('Export Collections to JSON')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: exportProductsToJson,
                child: Text('Export Products'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: exportUsersToJson,
                child: Text('Export Users'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: exportOrdersToJson,
                child: Text('Export Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chuyển đổi các giá trị Firestore thành dạng JSON-serializable
dynamic _toEncodable(dynamic value) {
  if (value is Timestamp) {
    return value.toDate().toIso8601String();
  } else if (value is GeoPoint) {
    return {'latitude': value.latitude, 'longitude': value.longitude};
  } else if (value is DocumentReference) {
    return value.path;
  } else if (value is List) {
    return value.map(_toEncodable).toList();
  } else if (value is Map) {
    return value.map((k, v) => MapEntry(k as String, _toEncodable(v)));
  }
  return value;
}

Future<void> exportCollectionToJson(String collection, String fileName) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    // Chuyển từng document map với conversion
    final dataList = snapshot.docs.map((d) {
      return d.data().map((key, value) => MapEntry(key, _toEncodable(value)));
    }).toList();
    final jsonString = jsonEncode(dataList);

    if (kIsWeb) {
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = fileName;
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
      print('Downloaded $fileName via browser');
    } else {
      final dirPath = r'D:\HOCTAP\CrossplatformMobileApp\DOANCK';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        print('Created directory: $dirPath');
      }
      final filePath = '$dirPath${Platform.pathSeparator}$fileName';
      final file = File(filePath);
      await file.writeAsString(jsonString);
      print('Saved $fileName at: $filePath');
    }
  } catch (e) {
    print('Error exporting $collection to JSON: $e');
  }
}
