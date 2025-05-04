class ProductModel {
  String id; 
  String name; 
  String description; 
  double price; 
  String imageUrl; 
  String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data["id"] ?? "",
      name: data["name"] ?? "Sản phẩm chưa đặt tên",
      description: data["description"] ?? "Không có mô tả",
      price: (data["price"] ?? 0).toDouble(), // Chuyển đổi về double
      imageUrl: data["imageUrl"] ?? "",
      category: data["category"] ?? "Chưa phân loại",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
      "category": category,
    };
  }
}
