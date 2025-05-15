
class CategoryModel {
  final String id;
  final String imagePath;
  final String categoryName;
  String ceatedAt;
  
  CategoryModel({
    required this.id,
    required this.imagePath,
    required this.categoryName,
    String? ceatedAt,  }) : this.ceatedAt = ceatedAt ?? DateTime.now().toIso8601String();

  // From Map method to create a CategoryModel from a Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      imagePath: map['imagePath'] ?? '',
      categoryName: map['categoryName'] ?? '',
      ceatedAt: map['ceatedAt'] ?? DateTime.now().toIso8601String(),
    );  }
  
  // To Map method to convert CategoryModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'categoryName': categoryName,
      'ceatedAt': ceatedAt,
    };
  }
  
  // Create a copy of this CategoryModel with given attributes
  CategoryModel copyWith({
    String? id,
    String? imagePath,
    String? categoryName,
    String? ceatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      categoryName: categoryName ?? this.categoryName,
      ceatedAt: ceatedAt ?? this.ceatedAt,
    );
  }
}

// List of all categories
