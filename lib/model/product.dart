class ProductModel {
  String id; // ID sản phẩm (do Firestore tạo hoặc tự định nghĩa)
  String name; // Tên sản phẩm
  String description; // Mô tả sản phẩm
  double price; // Giá sản phẩm
  String imageUrl; // URL hình ảnh sản phẩm
  String category; // Danh mục sản phẩm

  // Constructor để tạo ProductModel
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  // Chuyển dữ liệu từ Firestore (Map) thành đối tượng ProductModel
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

  // Chuyển đối tượng ProductModel thành Map để lưu vào Firestore
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
