import 'package:flutter/material.dart';
import '../../controller/orders_controller.dart';
import '../../routes/app_routes.dart';
import '../items/ordered_item.dart';
import '../../core/app_export.dart';

class OrderTabPage extends StatelessWidget {
  final String status;
  const OrderTabPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo trực tiếp OrdersController
    final ordersController = OrdersController();
    final filteredOrders = ordersController.getOrdersByStatus(status);

    return Padding(
      padding: EdgeInsets.all(16.h),
      child: filteredOrders.isEmpty
          ? _buildEmptyOrderMessage(context)
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredOrders.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return OrderedItem(
                  imagePath: order.imagePath,
                  productName: order.productName,
                  color: order.color,
                  quantity: order.quantity,
                  price: order.price,
                  status: order.status,
                  onReviewPressed: () {
                    // Xử lý nút đánh giá
                  },
                  onDetailsPressed: () {
                    // Since the Order class doesn't have an ID, we need to navigate to the screen differently
                    // This is a temporary solution - eventually we should use real order IDs from Firestore
                    Navigator.pushNamed(context, AppRoutes.ordersDetailScreen,
                        // Use a placeholder orderId for demo purposes
                        arguments: {'orderId': 'sample-order-id'});
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyOrderMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/img_check_out.png',
            width: 100.h,
            height: 100.h,
          ),
          SizedBox(height: 12.h),
          Text(
            "Bạn chưa có đơn hàng nào :<<<",
            style: TextStyle(fontSize: 16.h, color: Colors.black54),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              // Hành động "Tiếp tục mua hàng"
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.h),
              ),
            ),
            child: Text(
              "Tiếp tục mua hàng",
              style: CustomTextStyles.titleMediumBalooBhai2Gray900
                  .copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
