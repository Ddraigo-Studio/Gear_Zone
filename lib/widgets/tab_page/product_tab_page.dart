import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_text_style.dart';

class ProductTabTabPage extends StatefulWidget {
  const ProductTabTabPage({super.key});

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
            unselectedLabelColor: Colors.white,
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
            height: 300.h,
            child: TabBarView(
              children: [
                // Tab 1: Thông tin
                _buildTabInfoSummary(context),
                // Tab 2: Cấu hình
                _buildTabInfoInfoConfig(context),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Column(
        spacing: 10.h,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informational section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông tin chung:",
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleMediumGabaritoGray900Bold.copyWith(
                  height: 1.60,
                ),
              ),
              Text(
                "- Hỗ trợ đổi mới trong 7 ngày.",
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.bodyMediumBlack900.copyWith(
                  height: 1.60,
                ),
              ),
              Text(
                "- Nhà sản xuất: ViewSonic",
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.bodyMediumBlack900.copyWith(
                  height: 1.60,
                ),
              ),
            ],
          ),
          // Promotions section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Khuyến mãi",
                style: CustomTextStyles.titleMediumGabaritoGray900Bold,
              ),
              Text(
                maxLines: isExpandedSummary ? null : 3,
                "Mua thêm giá treo màn hình máy tính North Bayou NB-P80 giá chỉ 290.000đ.Mua thêm giá treo màn hình Warrior WA-MH0802 hoặc Warrior WA-MH0801 giá chỉ 290.000đ.",
                style: CustomTextStyles.bodySmallBalooBhaiGray900_1.copyWith(
                  height: 1.60,
                ),
              ),
            ],
          ),
          // Button to expand/collapse content
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
                    isExpandedSummary ? "Thu gọn" : "Xem chi tiết",
                  ),
                  Transform.rotate(
                    angle: isExpandedSummary
                        ? 3.14159
                        : 0, // 3.14159 radians is 180 degrees for flipping the image
                    child: Image.asset(
                      "assets/icons/icon_arrow_down_purple.png",
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
    );
  }


  // Tab 2: Cấu hình
  Widget _buildTabInfoInfoConfig(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isExpandedConfig
                ? null
                : 100.h, 
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.purple.shade200),
                verticalInside: BorderSide(color: Colors.purple.shade200),
              ),
              children: [
                TableRow(
                  children: [
                    Text('Độ phân giải',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('2K (2560 × 1440)'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Phụ kiện trong hộp',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Dây nguồn; dây HDMI; dây DisplayPort (optional)'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Kích thước',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('27 inch'),
                  ],
                ),
              ],
            ),
          ),
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
                    isExpandedConfig
                        ? "Xem thông tin chi tiết"
                        : "Thu gọn",
                  ),
                  Transform.rotate(
                    angle: isExpandedConfig
                        ? 3.14159
                        : 0,
                    child: Image.asset(
                      "assets/icons/icon_arrow_down_purple.png",
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
    );
  }

  // Tab 3: Mô tả
  Widget _buildTabInfoDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 6.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đánh giá màn hình ViewSonic VA2708-2K-MHD 27\" IPS 2K 100Hz",
                style: CustomTextStyles.titleMediumGabaritoGray900Bold,
              ),
              Text(
                "Bạn đang có nhu cầu tìm kiếm một màn hình phục vụ cho công việc, mục đích giải trí mà vẫn đáp ứng được các yêu cầu cần thiết về hình ảnh và chất lượng. Màn hình ViewSonic VA2708-2K-MHD là một lựa chọn mà bạn có thể tham khảo qua, đây là một sản phẩm được tối ưu nhằm phục vụ cho cả 2 nhu cầu đó. Cùng xem qua tính năng và những điểm mạnh mà sản phẩm mang lại nhé!",
                maxLines: isExpandedDescription
                    ? null
                    : 5, 
                style: CustomTextStyles.bodyMediumBalooBhaijaanGray900,
              ),
            ],
          ),
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
                    ),
                    Transform.rotate(
                      angle: isExpandedDescription
                          ? 3.14159
                          : 0, 
                      child: Image.asset(
                        "assets/icons/icon_arrow_down_purple.png",
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
    );
  }
}
