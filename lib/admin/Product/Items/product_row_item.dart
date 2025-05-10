import 'package:flutter/material.dart';
import '../../../model/product.dart';
import '../../../core/app_provider.dart';  // Import AppProvider
import 'package:provider/provider.dart';   // Import Provider

final List<ProductModel> sampleProducts = [
  ProductModel(
    id: "A1001",
    name: "Laptop Asus Zenbook 14",
    description: "Laptop mỏng nhẹ, hiệu năng cao",
    price: 20990000,
    originalPrice: 23990000,
    imageUrl: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-W2WjXRd99YcTLHtj2JK4mRgqq9KzVJ.png",
    category: "Laptop",
    status: "Có sẵn",
    quantity: "25",
    inStock: true,
  ),
  ProductModel(
    id: "A1002",
    name: "Laptop Dell XPS 13",
    description: "Laptop cao cấp cho doanh nhân",
    price: 32990000,
    originalPrice: 35990000,
    imageUrl: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-W2WjXRd99YcTLHtj2JK4mRgqq9KzVJ.png",
    category: "Laptop",
    status: "Có sẵn",
    quantity: "12",
    inStock: true,
  ),
  ProductModel(
    id: "A1003",
    name: "MacBook Air M2",
    description: "Laptop mỏng nhẹ, chip M2 mạnh mẽ",
    price: 28990000,
    originalPrice: 30990000,
    imageUrl: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-W2WjXRd99YcTLHtj2JK4mRgqq9KzVJ.png",
    category: "Laptop",
    status: "Hết hàng",
    quantity: "0",
    inStock: false,
  ),
];

/// Tạo TableRow dựa trên ProductModel được cung cấp
/// 
/// [context] Context hiện tại để lấy Theme
/// [index] Chỉ số của sản phẩm trong danh sách
/// [products] Danh sách các sản phẩm để hiển thị
/// 
/// Quan trọng: Hàm này và buildMobileProductItem nên sử dụng cùng một danh sách products để đảm bảo
/// tính nhất quán giữa chế độ xem desktop và mobile.
TableRow buildProductTableRow(
    BuildContext context, int index, List<ProductModel> products) {
  final product = products[index % products.length];
  final isAvailable = product.status == 'Có sẵn' || product.inStock;
  final appProvider = Provider.of<AppProvider>(context, listen: false);

  return TableRow(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    children: [
      // Checkbox
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      ),
      // Sản phẩm
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.id,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Giá
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            "${product.price.toStringAsFixed(0)}đ",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
      // Số lượng
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            product.quantity,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
      // Ngày nhập
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          child: Text(
            product.createdAt?.toString().substring(0, 16) ?? 'N/A',
            style: const TextStyle(
              fontSize: 13, // Tăng kích thước font
              height: 1.4, // Thêm line height để dòng cách nhau
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // Trạng thái
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16), // Tăng padding
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6), // Tăng padding của badge
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.status,
              style: TextStyle(
                fontSize: 13, // Tăng kích thước font
                fontWeight: FontWeight.w500, // Làm đậm hơn
                color: isAvailable ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      // Hành động
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16), // Tăng padding
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [              IconButton(
                icon: const Icon(Icons.visibility_outlined,
                    size: 20), // Tăng kích thước icon
                onPressed: () {
                  // Chuyển đến màn hình chi tiết sản phẩm ở chế độ xem
                  appProvider.setCurrentScreen(2, isViewOnly: true); // Index 2 là ProductDetail
                },
                color: Colors.grey,
                padding: const EdgeInsets.all(4), // Thêm padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xem sản phẩm',
              ),
              const SizedBox(width: 8), // Thêm khoảng cách giữa các icon
              IconButton(
                onPressed: () {
                  // Chuyển đến màn hình chi tiết sản phẩm ở chế độ sửa
                  appProvider.setCurrentScreen(2, isViewOnly: false); // Index 2 là ProductDetail
                },
                icon: const Icon(Icons.edit_outlined,
                    size: 20), // Tăng kích thước icon
                color: Colors.grey,
                padding: const EdgeInsets.all(4), // Thêm padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Sửa sản phẩm',
              ),
              const SizedBox(width: 8), // Thêm khoảng cách giữa các icon
              IconButton(
                icon: const Icon(Icons.delete_outlined,
                    size: 20), // Tăng kích thước icon
                onPressed: () {},
                color: Colors.grey,
                padding: const EdgeInsets.all(4), // Thêm padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Xây dựng mục sản phẩm dạng mobile
/// 
/// [context] Context hiện tại để lấy Theme
/// [index] Chỉ số của sản phẩm trong danh sách
/// [product] Sản phẩm cần hiển thị
/// [isExpanded] Trạng thái mở rộng/thu gọn của item
/// [onExpandToggle] Callback khi người dùng bấm vào nút mở rộng/thu gọn
/// 
/// Quan trọng: Hàm này và buildProductTableRow nên sử dụng cùng một danh sách products để đảm bảo
/// tính nhất quán giữa chế độ xem desktop và mobile.
Widget buildMobileProductItem(
    BuildContext context, 
    int index, 
    ProductModel product,
    {bool isExpanded = false, 
    Function(int)? onExpandToggle}) {
  
  bool isAvailable = product.status == 'Có sẵn' || product.inStock;
  final appProvider = Provider.of<AppProvider>(context, listen: false);

  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              child: Checkbox(
                value: false,
                onChanged: (value) {},
              ),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.id,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
              ),
              onPressed: () {
                if (onExpandToggle != null) {
                  onExpandToggle(index);
                }
              },
            ),
          ],
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 76, bottom: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Giá',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      "${product.price.toStringAsFixed(0)}đ",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Số lượng',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      product.quantity,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Ngày nhập',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      product.createdAt?.toString().substring(0, 16) ?? 'N/A',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Trạng thái',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.status,
                        style: TextStyle(
                          fontSize: 11,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Hành động',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      children: [                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          onPressed: () {
                            // Chuyển đến màn hình chi tiết sản phẩm ở chế độ xem
                            appProvider.setCurrentScreen(2, isViewOnly: true); // Index 2 là ProductDetail
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Xem sản phẩm',
                        ),
                        const SizedBox(width: 16),                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {
                            // Chuyển đến màn hình chi tiết sản phẩm ở chế độ sửa
                            appProvider.setCurrentScreen(2, isViewOnly: false); // Index 2 là ProductDetail
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Sửa sản phẩm',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined, size: 20),
                          onPressed: () {},
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

/// Xây dựng bảng sản phẩm hoàn chỉnh với danh sách sản phẩm tùy chỉnh
/// 
/// [context] Context hiện tại để lấy Theme
/// [products] Danh sách các sản phẩm để hiển thị, nếu không cung cấp sẽ sử dụng dữ liệu mẫu
Table buildProductTable(BuildContext context, {List<ProductModel>? products}) {
  final productList = products ?? sampleProducts;
  
  return Table(
    columnWidths: const {
      0: FixedColumnWidth(40), // Checkbox
      1: FlexColumnWidth(3), // Sản phẩm
      2: FlexColumnWidth(1), // Giá
      3: FlexColumnWidth(1), // Số lượng
      4: FlexColumnWidth(1), // Ngày nhập
      5: FlexColumnWidth(1), // Trạng thái
      6: FlexColumnWidth(1), // Hành động
    },
    children: List.generate(
      productList.length,
      (index) => buildProductTableRow(context, index, productList),
    ),
  );
}
