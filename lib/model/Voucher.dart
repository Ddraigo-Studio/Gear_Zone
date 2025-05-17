// Voucher model for Gear Zone application

import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String id;
  final String code;
  final double discountAmount; // Giá trị giảm giá cố định (VND)
  final DateTime createdAt; // Thời gian tạo mã
  final int maxUsageCount; // Số lần sử dụng tối đa
  final int currentUsageCount; // Số lần đã sử dụng
  final List<String> appliedOrderIds; // Danh sách ID đơn hàng đã áp dụng mã
  final Map<String, int> userUsageCounts; // Số lần sử dụng của mỗi user
  final bool isActive; // Trạng thái kích hoạt của voucher
  
  Voucher({
    required this.id,
    required this.code,
    this.discountAmount = 0,
    DateTime? createdAt,
    this.maxUsageCount = 10,
    this.currentUsageCount = 0,
    this.appliedOrderIds = const [],
    this.userUsageCounts = const {},
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();  // Convert voucher to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'discountAmount': discountAmount,
      'createdAt': Timestamp.fromDate(createdAt),
      'maxUsageCount': maxUsageCount,
      'currentUsageCount': currentUsageCount,
      'appliedOrderIds': appliedOrderIds,
      'userUsageCounts': userUsageCounts,
      'isActive': isActive,
    };
  }
  // Create voucher from Firestore document
  factory Voucher.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Convert userUsageCounts from Firestore
    Map<String, int> userCounts = {};
    if (data['userUsageCounts'] != null) {
      final Map<String, dynamic> rawCounts = Map<String, dynamic>.from(data['userUsageCounts']);
      rawCounts.forEach((key, value) {
        userCounts[key] = (value as num).toInt();
      });
    }
    
    return Voucher(
      id: doc.id,
      code: data['code'] ?? '',
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      maxUsageCount: data['maxUsageCount'] ?? 10,
      currentUsageCount: data['currentUsageCount'] ?? 0,
      appliedOrderIds: List<String>.from(data['appliedOrderIds'] ?? []),
      userUsageCounts: userCounts,
      isActive: data['isActive'] ?? true,
    );
  }  // Create a copy of a voucher with updated usage or details
  Voucher copyWith({
    String? id,
    String? code,
    double? discountAmount,
    DateTime? createdAt,
    int? maxUsageCount,
    int? currentUsageCount,
    List<String>? appliedOrderIds,
    Map<String, int>? userUsageCounts,
    bool? isActive,
  }) {
    return Voucher(
      id: id ?? this.id,
      code: code ?? this.code,
      discountAmount: discountAmount ?? this.discountAmount,
      createdAt: createdAt ?? this.createdAt,
      maxUsageCount: maxUsageCount ?? this.maxUsageCount,
      currentUsageCount: currentUsageCount ?? this.currentUsageCount,
      appliedOrderIds: appliedOrderIds ?? this.appliedOrderIds,
      userUsageCounts: userUsageCounts ?? this.userUsageCounts,
      isActive: isActive ?? this.isActive,
    );
  }
  
  // Apply voucher to an order (increment usage and add orderId)
  Voucher applyToOrder(String orderId, String userId) {
    // Check if voucher can be used
    if (appliedOrderIds.contains(orderId) || 
        currentUsageCount >= maxUsageCount || 
        !isActive) {
      return this;
    }
    
    // Get current user usage count
    int userCount = userUsageCounts[userId] ?? 0;
    
    // Update user usage counts
    final updatedUserCounts = Map<String, int>.from(userUsageCounts);
    updatedUserCounts[userId] = userCount + 1;
    
    // Update order IDs
    final updatedIds = List<String>.from(appliedOrderIds)..add(orderId);
    
    return copyWith(
      currentUsageCount: currentUsageCount + 1,
      appliedOrderIds: updatedIds,
      userUsageCounts: updatedUserCounts,
    );
  }
  
  // Remaining usage count
  int get remainingUsageCount => maxUsageCount - currentUsageCount;
  // Factory to create a new fixed discount voucher
  static Voucher createVoucher({
    required String code,
    required double amount,
    int maxUsageCount = 10,
    bool isActive = true,
  }) {
    if (code.length != 5 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(code)) {
      throw ArgumentError('Mã giảm giá phải gồm 5 ký tự chữ và số');
    }
    const allowed = [10000, 20000, 50000, 100000];
    if (!allowed.contains(amount)) {
      throw ArgumentError('Giá trị giảm phải là 10k,20k,50k hoặc 100k VND');
    }    return Voucher(
      id: '',
      code: code,
      discountAmount: amount,
      createdAt: DateTime.now(),
      maxUsageCount: maxUsageCount,
      isActive: isActive,
      userUsageCounts: {},
      currentUsageCount: 0,
      appliedOrderIds: [],
    );
  }
}