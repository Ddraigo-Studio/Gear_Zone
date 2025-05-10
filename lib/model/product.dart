class ProductModel {
  String id; 
  String name; 
  String description; 
  double price;
  double originalPrice; // Giá gốc để hiển thị giá khuyến mãi
  String imageUrl;
  List<String> additionalImages; // Thêm danh sách ảnh phụ  
  String category;
  String brand; // Thêm thương hiệu (Acer, Dell, etc.)
  String seriNumber; // Mã model (SFA16 41 R3L6)
  DateTime? createdAt; // Thời gian tạo sản phẩm
  
  // Thông số kỹ thuật cơ bản
  String processor; // CPU: AMD Ryzen™ 7 6800U
  String ram; // 16GB LPDDR5 6400MHz
  String storage; // Ổ cứng: 1TB PCIe NVMe SSD
  String graphicsCard; // Card đồ họa: AMD Radeon Graphics
  String display; // Màn hình: 16" WQUXGA OLED
  
  // Thông số kỹ thuật mở rộng
  String operatingSystem; // Hệ điều hành: Windows 11 Home
  String keyboard; // Bàn phím: thường, có phím số, có hỗ trợ LED
  String audio; // Âm thanh: DTS Audio, etc.
  String wifi; // Chuẩn WIFI: Wi-Fi 6e AX211
  String bluetooth; // Bluetooth 5.2
  String battery; // Pin: 54 Wh 3-cell Li-ion
  String weight; // Trọng lượng: 1.1 kg
  String color; // Màu sắc: Flax White
  String dimensions; // Kích thước: 356.7 (W) x 242.3 (D) x 13.95 (H) mm
  String security; // Bảo mật: Vân tay
  String webcam; // Webcam: 1080p HD
  
  // Thông tin cổng kết nối
  List<String> ports; // Cổng giao tiếp: USB Type-C, HDMI, etc.
  
  // Thông tin bán hàng
  String quantity; // Số lượng tồn kho
  String status; // Trạng thái: Còn hàng, Hết hàng
  bool inStock; // Có sẵn hay không
  int discount; // Phần trăm giảm giá
  List<String> promotions; // Quà tặng kèm, khuyến mãi
  String warranty; // Thông tin bảo hành

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice = 0.0,
    required this.imageUrl,
    this.additionalImages = const [],
    required this.category,
    this.brand = "",
    this.seriNumber = "",
    this.processor = "",
    this.ram = "",
    this.storage = "",
    this.graphicsCard = "",
    this.display = "",
    this.operatingSystem = "",
    this.keyboard = "",
    this.audio = "",
    this.wifi = "",
    this.bluetooth = "",
    this.battery = "",
    this.weight = "",
    this.color = "",
    this.dimensions = "",
    this.security = "",
    this.webcam = "",
    this.ports = const [],
    this.quantity = "0",
    this.status = "Hết hàng",
    this.inStock = false,
    this.discount = 0,
    this.promotions = const [],
    this.warranty = "12 tháng",
    this.createdAt,
  }) {
    // Nếu createdAt không được chỉ định, sẽ tự động gán thời gian hiện tại
    this.createdAt ??= DateTime.now();
  }

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data["id"] ?? "",
      name: data["name"] ?? "Sản phẩm chưa đặt tên",
      description: data["description"] ?? "Không có mô tả",
      price: (data["price"] ?? 0).toDouble(),
      originalPrice: (data["originalPrice"] ?? 0).toDouble(),
      imageUrl: data["imageUrl"] ?? "",
      additionalImages: data["additionalImages"] != null 
          ? List<String>.from(data["additionalImages"]) 
          : [],
      category: data["category"] ?? "Chưa phân loại",
      brand: data["brand"] ?? "",
      seriNumber: data["seriNumber"] ?? "",
      processor: data["processor"] ?? "",
      ram: data["ram"] ?? "",
      storage: data["storage"] ?? "",
      graphicsCard: data["graphicsCard"] ?? "",
      display: data["display"] ?? "",
      operatingSystem: data["operatingSystem"] ?? "",
      keyboard: data["keyboard"] ?? "",
      audio: data["audio"] ?? "",
      wifi: data["wifi"] ?? "",
      bluetooth: data["bluetooth"] ?? "",
      battery: data["battery"] ?? "",
      weight: data["weight"] ?? "",
      color: data["color"] ?? "",
      dimensions: data["dimensions"] ?? "",
      security: data["security"] ?? "",
      webcam: data["webcam"] ?? "",
      ports: data["ports"] != null ? List<String>.from(data["ports"]) : [],
      quantity: data["quantity"] ?? "0",
      status: data["status"] ?? "Hết hàng",
      inStock: data["inStock"] ?? false,
      discount: data["discount"] ?? 0,
      promotions: data["promotions"] != null 
          ? List<String>.from(data["promotions"]) 
          : [],
      warranty: data["warranty"] ?? "12 tháng",
      createdAt: data["createdAt"] != null 
          ? DateTime.parse(data["createdAt"]) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "originalPrice": originalPrice,
      "imageUrl": imageUrl,
      "additionalImages": additionalImages,
      "category": category,
      "brand": brand,
      "seriNumber": seriNumber,
      "processor": processor,
      "ram": ram,
      "storage": storage,
      "graphicsCard": graphicsCard,
      "display": display,
      "operatingSystem": operatingSystem,
      "keyboard": keyboard,
      "audio": audio,
      "wifi": wifi,
      "bluetooth": bluetooth,
      "battery": battery,
      "weight": weight,
      "color": color,
      "dimensions": dimensions,
      "security": security,
      "webcam": webcam,
      "ports": ports,
      "quantity": quantity,
      "status": status,
      "inStock": inStock,
      "discount": discount,
      "promotions": promotions,
      "warranty": warranty,
      "createdAt": createdAt?.toIso8601String(), // Chuyển DateTime sang chuỗi ISO để lưu trữ
    };
  }
}
