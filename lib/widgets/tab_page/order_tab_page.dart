import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/orders_controller.dart';
import '../../routes/app_routes.dart';
import '../items/ordered_item.dart';
import '../../core/app_export.dart';
import '../../controller/auth_controller.dart';
import '../../model/order.dart';
import 'package:intl/intl.dart';
import '../custom_image_view.dart';

class OrderTabPage extends StatefulWidget {
  final String status;
  const OrderTabPage({super.key, required this.status});

  @override
  State<OrderTabPage> createState() => _OrderTabPageState();
}

class _OrderTabPageState extends State<OrderTabPage>
    with AutomaticKeepAliveClientMixin {
  // Giữ trạng thái tab để không tải lại khi người dùng chuyển tab
  @override
  bool get wantKeepAlive => true;

  // Khởi tạo controller tĩnh để duy trì cùng instance trên tất cả các tab
  static final OrdersController _ordersController = OrdersController();

  @override
  void dispose() {
    // Không cần gọi _ordersController.dispose() tại đây vì nó là static và được dùng chung
    // giữa các tab, sẽ được dọn dẹp khi OrderHistoryScreen bị dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Lấy userId từ AuthController
    final authController = Provider.of<AuthController>(context, listen: false);
    final userId = authController.userModel?.uid;

    if (userId == null) {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: Center(
          child: Text(
            'Bạn cần đăng nhập để xem đơn hàng',
            style: TextStyle(fontSize: 16.h, color: Colors.grey),
          ),
        ),
      );
    }

    // Chọn stream dựa trên loại tab
    Stream<List<OrderModel>> orderStream;
    if (widget.status == 'Tất cả') {
      orderStream = _ordersController.getAllOrdersStream(userId);
    } else {
      orderStream =
          _ordersController.getOrdersByStatusStream(userId, widget.status);
    }

    return Padding(
      padding: EdgeInsets.all(16.h),
      child: StreamBuilder<List<OrderModel>>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Đang tải đơn hàng...',
                    style: TextStyle(fontSize: 16.h, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Đã xảy ra lỗi: ${snapshot.error}',
                style: TextStyle(fontSize: 16.h, color: Colors.red),
              ),
            );
          }

          final orders = snapshot.data ?? [];
          final legacyOrders = _ordersController.convertToLegacyOrders(orders);

          if (legacyOrders.isEmpty) {
            return _buildEmptyOrderMessage(context);
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: legacyOrders.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final order = legacyOrders[index];
              final orderModel = orders[index]; // Original OrderModel with ID

              return OrderedItem(
                imagePath: order.imagePath,
                productName: order.productName,
                color: order.color,
                quantity: order.quantity,
                price: order.price,
                status: order.status,
                onReviewPressed: () {
                  // Xử lý nút đánh giá
                  if (order.status == OrdersController.STATUS_COMPLETED) {
                    // Tạm thời bỏ qua nếu chưa có màn hình review
                    // Navigator.pushNamed(context, AppRoutes.reviewScreen,
                    //     arguments: {'orderId': orderModel.id});
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Tính năng đánh giá đang được phát triển')));
                  }
                },
                onDetailsPressed: () {
                  Navigator.pushNamed(context, AppRoutes.ordersDetailScreen,
                      arguments: {'orderId': orderModel.id});
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
            "Bạn chưa có đơn hàng nào ${widget.status != 'Tất cả' ? 'ở trạng thái ${widget.status}' : ''} :<<<",
            style: TextStyle(fontSize: 16.h, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              // Hành động "Tiếp tục mua hàng"
              Navigator.pushNamed(context, AppRoutes.homeScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
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
