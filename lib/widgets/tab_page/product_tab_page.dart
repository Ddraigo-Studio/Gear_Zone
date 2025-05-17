import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
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
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).primaryColor,
            automaticIndicatorColorAdjustment: true,
            labelStyle: CustomTextStyles.bodySmallBalooBhaiGray900.copyWith(fontWeight: FontWeight.bold, fontSize: 18.h),
            unselectedLabelStyle: CustomTextStyles.bodySmallBalooBhaiGray900.copyWith(fontWeight: FontWeight.normal, fontSize: 16.h),
            tabs: [
              Tab(
                child: Text("Thông tin"),
              ),
              Tab(
                child: Text("Cấu hình"),
              ),
              Tab(
                child: Text("Mô tả"),
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

    // Tạo một hàng thông tin
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.h,
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
  // Tab 1: Thông tin chung
  Widget _buildTabInfoSummary(BuildContext context) {
    // Kiểm tra xem tab có nhiều thông tin không để quyết định có hiển thị nút thu gọn/mở rộng hay không
    bool hasLongContent = widget.product.promotions.length > 3;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Column(
          children: [
            // Phần nội dung có thể ẩn hiện
            Container(
              padding: EdgeInsets.all(16.h),
              constraints: isExpandedSummary 
                ? null 
                : BoxConstraints(maxHeight: 350.h), // Giới hạn chiều cao khi thu gọn
              child: ClipRect(
                child: SingleChildScrollView(
                  // Khi không mở rộng, tắt cuộn vì chúng ta sẽ cắt bớt nội dung
                  physics: isExpandedSummary ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(), 
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
                          _buildInfoRow("Nhà sản xuất", widget.product.brand, 
                              valueColor: Colors.blue),
                          if (widget.product.seriNumber.isNotEmpty)
                          _buildInfoRow("Bảo hành", widget.product.warranty),
                          // if (widget.product.color.isNotEmpty)
                          //   _buildInfoRow("Màu sắc", widget.product.color),
                        ],
                      ),
                      SizedBox(height: 16.h),
                    
                      // Khuyến mãi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with pink background and gift icon
                          Container(
                            width: Responsive.isDesktop(context) ? 600.h : double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.h),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE4E8), // Light pink background
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.h),
                                topRight: Radius.circular(8.h),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.card_giftcard,
                                  color: Colors.red,
                                  size: 20.h,
                                ),
                                SizedBox(width: 8.h),
                                Text(
                                  "Quà tặng khuyến mãi",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.fSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Promotions container
                          Container(
                            width: Responsive.isDesktop(context) ? 600.h : double.infinity,
                            padding: EdgeInsets.all(12.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.h),
                                bottomRight: Radius.circular(8.h),
                              ),
                            ),
                            child: widget.product.promotions.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.product.promotions.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(8.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Numbered circle
                                          Container(
                                            padding: EdgeInsets.only(bottom: 4.h),
                                            width: 20.h,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.fSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.h),
                                          // Promotion text
                                          Expanded(
                                            child: Text(
                                              widget.product.promotions[index],
                                              style: TextStyle(
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Text(
                                    "Hiện tại sản phẩm chưa có chương trình khuyến mãi",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Nút mở rộng/thu gọn
            if (hasLongContent)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Center(
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
                          isExpandedSummary ? "Thu gọn" : "Xem tất cả nội dung",
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
              ),
          ],
        ),
      ),
    );
  }  // Tab 2: Cấu hình
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
    
    // Xác định xem có cần nút mở rộng/thu gọn không
    bool hasLongContent = nonEmptySpecs.length > 8;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Column(
          children: [
            // Phần nội dung có thể ẩn hiện
            Container(
              padding: EdgeInsets.all(16.h),
              constraints: isExpandedConfig 
                ? null 
                : BoxConstraints(maxHeight: 350.h), // Giới hạn chiều cao khi thu gọn
              child: ClipRect(
                child: SingleChildScrollView(
                  // Khi không mở rộng, tắt cuộn vì chúng ta sẽ cắt bớt nội dung
                  physics: isExpandedConfig ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(), 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        )
                      else
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
                            children: nonEmptySpecs.map((spec) {
                              // Xử lý đặc biệt nếu là cổng kết nối (ports)
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
                    ],
                  ),
                ),
              ),
            ),
            
            // Nút mở rộng/thu gọn
            if (hasLongContent)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Center(
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
                          isExpandedConfig ? "Thu gọn" : "Xem tất cả nội dung",
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
              ),
          ],
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
                  maxLines: isExpandedDescription ? null : 10,
                  style: CustomTextStyles.bodyMediumBalooBhaijaanGray900.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
                  
              // Nút mở rộng/thu gọn nếu mô tả dài
              if (widget.product.description.length > 300)
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
