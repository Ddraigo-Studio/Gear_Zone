import 'package:flutter/material.dart';
import 'package:gear_zone/core/app_export.dart';
import '../../theme/custom_text_style.dart';

class ProductTabTabPage extends StatelessWidget {
  const ProductTabTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              _buildTabInfoSummary(context),
              _buildTabInfoInfoConfig(context),
              _buildTabInfoDescription(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabInfoSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thông tin chung:\n- Nhà sản xuất: ViewSonic\n- Hỗ trợ đổi mới trong 7 ngày.",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodyMediumBlack900.copyWith(
              height: 1.60,
            ),
          ),
          Text(
            "Khuyến mãi",
            style: CustomTextStyles.titleMediumGabaritoGray900Bold,
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.h),
            child: Text(
              "Mua thêm giá treo màn hình máy tính North Bayou NB-P80 giá chỉ 290.000đ.\nMua thêm giá treo màn hình Warrior WA-MH0802 hoặc Warrior WA-MH0801 giá chỉ 290.000đ.",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodySmallBalooBhaiGray900_1.copyWith(
                height: 1.60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabInfoInfoConfig(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tạo bảng
          Container(
            decoration: AppDecoration.fillDeepPurple,
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.purple.shade200),
                verticalInside: BorderSide(color: Colors.purple.shade200),
              ),
              children: [
                // Dòng 1
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Độ phân giải',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('2K (2560 × 1440)'),
                    ),
                  ],
                ),
                // Dòng 2
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Phụ kiện trong hộp',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Dây nguồn; dây HDMI; dây DisplayPort (optional)'),
                    ),
                  ],
                ),
                // Dòng 3
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Kích thước',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('27 inch'),
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

  Widget _buildTabInfoDescription(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 4.h),
      child: Column(
        spacing: 16,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Đánh giá màn hình ViewSonic VA2708-2K-MHD 27\" IPS 2K 100Hz\n",
                  style: CustomTextStyles.bodyMediumBlack90015,
                ),
                TextSpan(
                  text:
                      "Bạn đang có nhu cầu tìm kiếm một màn hình phục vụ cho công việc, mục đích giải trí mà vẫn đáp ứng được các yêu cầu cần thiết về hình ảnh và chất lượng. Màn hình ViewSonic VA2708-2K-MHD là một lựa chọn mà bạn có thể tham khảo qua, đây là một sản phẩm được tối ưu nhằm phục vụ cho cả 2 nhu cầu đó. Cùng xem qua tính năng và những điểm mạnh mà sản phẩm mang lại nhé!",
                  style: CustomTextStyles.bodyMediumBalooBhaijaanGray900,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Đọc tiếp bài viết",
                style: CustomTextStyles.titleSmallBaloo2Primary,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgArrowDown,
                height: 22.h,
                width: 24.h,
                alignment: Alignment.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
