import 'package:flutter/material.dart';

class Order {
  final String imagePath;
  final String productName;
  final String color;
  final int quantity;
  final double price;
  final String status;

  Order({
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.quantity,
    required this.price,
    required this.status,
  });
}