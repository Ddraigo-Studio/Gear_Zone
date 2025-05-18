import 'package:flutter/material.dart';
import '../../pages/Order/order_detail_screen.dart';
import '../items/ordered_item.dart';
import '../../core/app_export.dart';
import '../../model/order.dart';

class OrderTabPage extends StatelessWidget {
  final String status;
  final Stream<List<OrderModel>>? orderStream;
  
  const OrderTabPage({
    super.key, 
    required this.status, 
    this.orderStream,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: orderStream == null
          ? _buildEmptyOrderMessage(context)
          : StreamBuilder<List<OrderModel>>(
              stream: orderStream,
              builder: (context, snapshot) {                // Show loading indicator only during initial load, avoid infinite spinner
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16.h),
                        Text(
                          "Đang tải đơn hàng...",
                          style: TextStyle(fontSize: 14.h, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Đã xảy ra lỗi: ${snapshot.error}",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyOrderMessage(context);
                }
                  // Optimize filtering by status - store the result
                final List<OrderModel> orders = [];
                
                // Immediately check if we have any orders with the current status
                for (var order in snapshot.data!) {
                  if (order.status == status) {
                    orders.add(order);
                  }
                }
                
                if (orders.isEmpty) {
                  return _buildEmptyOrderMessage(context);
                }
                
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    // Find the first item in the order to display
                    final firstItem = order.items.isNotEmpty ? order.items.first : null;
                    final productName = firstItem?.productName ?? 'Unknown Product';
                    final color = firstItem?.color ?? 'N/A';
                    final quantity = order.items.fold(0, (sum, item) => sum + item.quantity);
                      // Determine image path with proper validation
                    String imagePath;
                    if (firstItem?.productImage != null && 
                        firstItem!.productImage!.isNotEmpty &&
                        (firstItem.productImage!.startsWith('http') || firstItem.productImage!.startsWith('https'))) {
                      imagePath = firstItem.productImage!;
                    } else if (firstItem?.productImage != null && 
                               firstItem!.productImage!.isNotEmpty &&
                               firstItem.productImage!.startsWith('assets/')) {
                      imagePath = firstItem.productImage!;
                    } else {
                      // Fallback to default placeholder for missing images
                      imagePath = 'assets/images/img_check_out.png';
                    }
                    
                    return OrderedItem(
                      imagePath: imagePath,
                      productName: productName,
                      color: color,
                      quantity: quantity,
                      price: order.total,
                      status: order.status,
                      onReviewPressed: order.status == 'Đã nhận' ? () {
                        // Xử lý nút đánh giá
                      } : null,
                      onDetailsPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersDetailScreen(orderId: order.id)),
                        );
                      },
                    );
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
            "Bạn chưa có đơn hàng nào thuộc trạng thái này",
            style: TextStyle(fontSize: 16.h, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(            onPressed: () {
              // Navigate to product screen
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/productsScreen', 
                (route) => false
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.h),
              ),
            ),
            child: Text(
              "Tiếp tục mua hàng",
              style: CustomTextStyles.titleMediumBalooBhai2Gray900.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
