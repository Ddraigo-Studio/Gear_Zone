// Voucher model for Gear Zone application

import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String id;
  final String code;
  final int discountPercentage;
  final double minimumOrderAmount;
  final double maximumDiscountAmount;
  final DateTime expirationDate;
  final DateTime validFromDate;
  final DateTime validToDate;
  final List<String> applicableProducts;
  final List<String> paymentMethods;
  final bool isActive;

  Voucher({
    required this.id,
    required this.code,
    required this.discountPercentage,
    required this.minimumOrderAmount,
    required this.maximumDiscountAmount, 
    required this.expirationDate,
    required this.validFromDate,
    required this.validToDate,
    required this.applicableProducts,
    required this.paymentMethods,
    this.isActive = true,
  });

  // Convert voucher to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'discountPercentage': discountPercentage,
      'minimumOrderAmount': minimumOrderAmount,
      'maximumDiscountAmount': maximumDiscountAmount,
      'expirationDate': Timestamp.fromDate(expirationDate),
      'validFromDate': Timestamp.fromDate(validFromDate),
      'validToDate': Timestamp.fromDate(validToDate),
      'applicableProducts': applicableProducts,
      'paymentMethods': paymentMethods,
      'isActive': isActive,
    };
  }

  // Create voucher from Firestore document
  factory Voucher.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Voucher(
      id: doc.id,
      code: data['code'] ?? '',
      discountPercentage: data['discountPercentage'] ?? 0,
      minimumOrderAmount: (data['minimumOrderAmount'] ?? 0).toDouble(),
      maximumDiscountAmount: (data['maximumDiscountAmount'] ?? 0).toDouble(),
      expirationDate: (data['expirationDate'] as Timestamp).toDate(),
      validFromDate: (data['validFromDate'] as Timestamp).toDate(),
      validToDate: (data['validToDate'] as Timestamp).toDate(),
      applicableProducts: List<String>.from(data['applicableProducts'] ?? []),
      paymentMethods: List<String>.from(data['paymentMethods'] ?? []),
      isActive: data['isActive'] ?? false,
    );
  }

  // Create a copy of a voucher with some changes
  Voucher copyWith({
    String? id,
    String? code,
    int? discountPercentage,
    double? minimumOrderAmount,
    double? maximumDiscountAmount,
    DateTime? expirationDate,
    DateTime? validFromDate,
    DateTime? validToDate,
    List<String>? applicableProducts,
    List<String>? paymentMethods,
    bool? isActive,
  }) {
    return Voucher(
      id: id ?? this.id,
      code: code ?? this.code,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      maximumDiscountAmount: maximumDiscountAmount ?? this.maximumDiscountAmount,
      expirationDate: expirationDate ?? this.expirationDate,
      validFromDate: validFromDate ?? this.validFromDate,
      validToDate: validToDate ?? this.validToDate,
      applicableProducts: applicableProducts ?? this.applicableProducts,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      isActive: isActive ?? this.isActive,
    );
  }

  // Check if voucher is valid for a given order amount and date
  bool isValidForOrder(double orderAmount, DateTime currentDate, List<String> productCategories) {
    // Check if voucher is active
    if (!isActive) return false;

    // Check if order meets minimum amount
    if (orderAmount < minimumOrderAmount) return false;
    
    // Check if voucher is expired
    if (currentDate.isAfter(expirationDate) || 
        currentDate.isBefore(validFromDate) || 
        currentDate.isAfter(validToDate)) return false;
    
    // Check if product categories match
    if (applicableProducts.isNotEmpty && 
        !productCategories.any((category) => applicableProducts.contains(category))) {
      return false;
    }

    return true;
  }

  // Calculate discount amount
  double calculateDiscount(double orderAmount) {
    if (orderAmount < minimumOrderAmount) return 0.0;
    
    double discountAmount = orderAmount * discountPercentage / 100;
    // Apply maximum discount limit
    return discountAmount > maximumDiscountAmount ? maximumDiscountAmount : discountAmount;
  }

  @override
  String toString() {
    return 'Voucher{id: $id, code: $code, discount: $discountPercentage%, '
           'minimumOrder: $minimumOrderAmount, maximumDiscount: $maximumDiscountAmount}';
  }
}