// Phương thức dispose để giải phóng tài nguyên
// Được thêm vào trong OrderTabPage để gọi đúng thời điểm
@override
void dispose() {
  // Giải phóng tài nguyên của OrdersController
  // khi màn hình order history bị hủy
  _ordersController.dispose();
  super.dispose();
}
