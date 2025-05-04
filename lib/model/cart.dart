class CartItem {
  final String productId;
  final String imagePath;
  final String productName;
  final String color;
  int quantity;
  final double originalPrice;
  final double discountedPrice;
  bool isSelected;

  CartItem({
    required this.productId,
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.quantity,
    required this.originalPrice,
    required this.discountedPrice,
    this.isSelected = false,
  });

  double get totalPrice => discountedPrice * quantity;

  CartItem copyWith({
    String? productId,
    String? imagePath,
    String? productName,
    String? color,
    int? quantity,
    double? originalPrice,
    double? discountedPrice,
    bool? isSelected,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      imagePath: imagePath ?? this.imagePath,
      productName: productName ?? this.productName,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
