import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../theme/custom_text_style.dart';
import '../../model/product.dart';

class ProductTabTabPage extends StatefulWidget {
  final ProductModel product;
  
  const ProductTabTabPage({
    super.key,
    required this.product,
  });

  @override
  _ProductTabTabPageState createState() => _ProductTabTabPageState();
}

class _ProductTabTabPageState extends State<ProductTabTabPage> {
  // Variable to track the state of each section for expansion
  bool isExpandedSummary = false;
  bool isExpandedConfig = false;
  bool isExpandedDescription = false;

  // Tạo một hàng thông tin
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.h,
            child: Text(
              "$label:",
              style: CustomTextStyles.bodyMediumBlack900.copyWith(
                height: 1.60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "Chưa cập nhật" : value,
              style: CustomTextStyles.bodyMediumBlack900.copyWith(
                height: 1.60,
                color: valueColor ?? (value.isEmpty ? Colors.grey : null),
                fontStyle: value.isEmpty ? FontStyle.italic : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                child: Text("Thông tin",
                    style: CustomTextStyles.bodySmallBalooBhaiGray900),
              ),
              Tab(
                child: Text("Cấu hình",
                    style: CustomTextStyles.bodySmallBalooBhaiGray900),
              ),
              Tab(
                child: Text("Mô tả",
                    style: CustomTextStyles.bodySmallBalooBhaiGray900),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 200.h,
              maxHeight: 400.h, // Cho phép co giãn từ 200-400
            ),
            child: TabBarView(
              children: [
                // Tab 1: Thông tin
                _buildTabInfoSummary(context),
                // Tab 2: Cấu hình
                _buildTabInfoConfig(context),
                // Tab 3: Mô tả
                _buildTabInfoDescription(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: Thông tin chung
  Widget _buildTabInfoSummary(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin chung
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thông tin chung",
                    style: CustomTextStyles.titleMediumGabaritoGray900Bold.copyWith(
                      height: 1.60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow("Nhà sản xuất", widget.product.brand),
                  if (widget.product.seriNumber.isNotEmpty)
                    _buildInfoRow("Series", widget.product.seriNumber),
                  _buildInfoRow("Bảo hành", widget.product.warranty),
                  _buildInfoRow(
                    "Tình trạng", 
                    widget.product.inStock ? "Còn hàng" : "Hết hàng",
                    valueColor: widget.product.inStock ? Colors.green : Colors.red,
                  ),
                  if (widget.product.color.isNotEmpty)
                    _buildInfoRow("Màu sắc", widget.product.color),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // Khuyến mãi
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Khuyến mãi",
                    style: CustomTextStyles.titleMediumGabaritoGray900Bold,
                  ),
                  SizedBox(height: 8.h),
                  if (widget.product.promotions.isNotEmpty)
                    Text(
                      maxLines: isExpandedSummary ? null : 3,
                      widget.product.promotions.map((promo) => "• $promo").join("\n"),
                      style: CustomTextStyles.bodySmallBalooBhaiGray900_1.copyWith(
                        height: 1.60,
                      ),
                    )
                  else
                    Text(
                      "Hiện tại sản phẩm chưa có chương trình khuyến mãi",
                      style: CustomTextStyles.bodySmallBalooBhaiGray900_1.copyWith(
                        height: 1.60,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              
              // Nút mở rộng/thu gọn cho phần khuyến mãi nếu có nhiều khuyến mãi
              if (widget.product.promotions.isNotEmpty && widget.product.promotions.length > 1)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpandedSummary = !isExpandedSummary;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExpandedSummary ? "Thu gọn" : "Xem thêm khuyến mãi",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(width: 4.h),
                        Transform.rotate(
                          angle: isExpandedSummary ? 3.14159 : 0,
                          child: SvgPicture.asset(
                            "assets/icons/icon_arrow_down_purple.svg",
                            height: 16.h,
                            width: 18.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  // Tab 2: Cấu hình
  Widget _buildTabInfoConfig(BuildContext context) {
    // Danh sách đầy đủ các cặp thông số kỹ thuật từ product model
    // Nhóm các thông số theo danh mục để hiển thị có cấu trúc
    
    // Thông số hiệu năng
    final Map<String, String> performanceSpecs = {
      'CPU': widget.product.processor,
      'RAM': widget.product.ram,
      'Ổ cứng': widget.product.storage,
      'Card đồ họa': widget.product.graphicsCard,
    };
    
    // Thông số màn hình và hiển thị
    final Map<String, String> displaySpecs = {
      'Màn hình': widget.product.display,
      'Webcam': widget.product.webcam,
    };
    
    // Thông số phần mềm
    final Map<String, String> softwareSpecs = {
      'Hệ điều hành': widget.product.operatingSystem,
      'Bảo mật': widget.product.security,
    };
    
    // Thông số thiết bị ngoại vi
    final Map<String, String> peripheralSpecs = {
      'Bàn phím': widget.product.keyboard,
      'Audio': widget.product.audio,
    };
    
    // Thông số kết nối
    final Map<String, String> connectivitySpecs = {
      'Wi-Fi': widget.product.wifi,
      'Bluetooth': widget.product.bluetooth,
    };
    
    // Thông số vật lý
    final Map<String, String> physicalSpecs = {
      'Pin': widget.product.battery,
      'Trọng lượng': widget.product.weight,
      'Kích thước': widget.product.dimensions,
      'Màu sắc': widget.product.color,
      'Series': widget.product.seriNumber,
    };
    
    // Gộp tất cả thông số lại, ưu tiên hiển thị theo thứ tự trên
    final Map<String, String> specifications = {}
      ..addAll(performanceSpecs)
      ..addAll(displaySpecs)
      ..addAll(softwareSpecs)
      ..addAll(peripheralSpecs)
      ..addAll(connectivitySpecs)
      ..addAll(physicalSpecs);
      
    // Lọc ra các thông số không trống
    final nonEmptySpecs = specifications.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();
    
    // Thêm các cổng kết nối nếu có
    if (widget.product.ports.isNotEmpty) {
      // Thêm bullet point cho từng cổng kết nối để hiển thị dạng danh sách
      nonEmptySpecs.add(MapEntry('Cổng giao tiếp', widget.product.ports.join(', ')));
    }
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông số kỹ thuật",
                style: CustomTextStyles.titleMediumGabaritoGray900Bold,
              ),
              SizedBox(height: 12.h),
              
              if (nonEmptySpecs.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Column(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey, size: 36.h),
                        SizedBox(height: 8.h),
                        Text(
                          "Thông số kỹ thuật đang được cập nhật",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey[200]!),
                      verticalInside: BorderSide(color: Colors.grey[200]!),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(3),
                    },
                    children: nonEmptySpecs.map((spec) {                      // Xử lý đặc biệt nếu là cổng kết nối (ports)
                      Widget valueWidget;
                      
                      if (spec.key == 'Cổng giao tiếp') {
                        // Hiển thị danh sách cổng kết nối với bullets
                        List<String> portsList = spec.value.split(', ');
                        valueWidget = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: portsList.map((port) => Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Text(port)),
                              ],
                            ),
                          )).toList(),
                        );
                      } else {
                        valueWidget = Text(
                          spec.value,
                          style: TextStyle(height: 1.5),
                        );
                      }
                      
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        children: [
                          Container(
                            color: Colors.grey[50],
                            padding: EdgeInsets.all(12.h),
                            child: Text(
                              spec.key,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.h),
                            child: valueWidget,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                
              // Nút mở rộng/thu gọn cho cấu hình nếu có nhiều thông số
              if (nonEmptySpecs.length > 8) // Chỉ hiển thị nếu có nhiều thông số
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpandedConfig = !isExpandedConfig;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExpandedConfig ? "Thu gọn" : "Xem thêm thông số",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(width: 4.h),
                        Transform.rotate(
                          angle: isExpandedConfig ? 3.14159 : 0,
                          child: SvgPicture.asset(
                            "assets/icons/icon_arrow_down_purple.svg",
                            height: 16.h,
                            width: 18.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab 3: Mô tả
  Widget _buildTabInfoDescription(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: CustomTextStyles.titleMediumGabaritoGray900Bold,
              ),
              SizedBox(height: 12.h),
              if (widget.product.description.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Column(
                      children: [
                        Icon(Icons.description_outlined, color: Colors.grey, size: 36.h),
                        SizedBox(height: 8.h),
                        Text(
                          "Mô tả sản phẩm đang được cập nhật",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  widget.product.description,
                  maxLines: isExpandedDescription ? null : 5,
                  style: CustomTextStyles.bodyMediumBalooBhaijaanGray900,
                ),
                  
              // Nút mở rộng/thu gọn nếu mô tả dài
              if (widget.product.description.length > 100)
                Align(
                  alignment: Alignment.center, 
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpandedDescription = !isExpandedDescription;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExpandedDescription ? "Thu gọn" : "Đọc tiếp bài viết",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(width: 4.h),
                        Transform.rotate(
                          angle: isExpandedDescription ? 3.14159 : 0, 
                          child: SvgPicture.asset(
                            "assets/icons/icon_arrow_down_purple.svg",
                            height: 16.h,
                            width: 18.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
