import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../model/order.dart'; // Import OrderModel
import '../../model/product.dart';

class EmailService {
  // Cấu hình thông tin SMTP
  final String _email = 'laithanh1000@gmail.com'; // Thay bằng email của bạn
  final String _appPassword = 'excj hagq wzxf myzs'; // Thay bằng mật khẩu ứng dụng

  Future<void> sendOrderConfirmation(
    String orderId,
    String userEmail,
    OrderModel order, // Thay List<CartItem> bằng OrderModel
    Map<String, dynamic> shippingAddress,
  ) async {
    // Tạo SMTP server cho Gmail
    final smtpServer = gmail(_email, _appPassword);

    // Tạo nội dung email
    final message = Message()
      ..from = Address(_email, 'Gear Zone') // Tên ứng dụng của bạn
      ..recipients.add(userEmail)
      ..subject = 'Xác nhận đơn hàng - Mã đơn #$orderId'
      ..html = _buildOrderEmailContent(orderId, order, shippingAddress);

    try {
      final sendReport = await send(message, smtpServer);
      print('Email xác nhận đơn hàng đã gửi: ${sendReport.toString()}');
    } catch (e) {
      print('Lỗi khi gửi email: $e');
      throw Exception('Không thể gửi email xác nhận đơn hàng: $e');
    }
  }

  String _buildOrderEmailContent(
    String orderId,
    OrderModel order, // Thay List<CartItem> bằng OrderModel
    Map<String, dynamic> shippingAddress,
  ) {
    // Tạo nội dung HTML cho email
    final buffer = StringBuffer()
      ..writeln('''
        <html>
          <body style="font-family: Arial, sans-serif; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee;">
              <h2 style="color: #6B38FB; text-align: center;">Xác nhận đơn hàng</h2>
              <p>Cảm ơn bạn đã đặt hàng! Đơn hàng <strong>#$orderId</strong> của bạn đã được đặt thành công.</p>
              <h3 style="color: #6B38FB;">Chi tiết đơn hàng</h3>
              <ul style="list-style-type: none; padding: 0;">
      ''');

    // Thêm danh sách sản phẩm từ OrderModel
    for (var item in order.items) {
      buffer.writeln('''
        <li style="margin-bottom: 10px;">
          ${item.productName} ${item.color != null ? '(Màu: ${item.color})' : ''} ${item.size != null ? '(Kích thước: ${item.size})' : ''}, Số lượng: ${item.quantity} - ${ProductModel.formatPrice(item.price * item.quantity)}
        </li>
      ''');
    }

    // Thêm thông tin chi tiết thanh toán
    buffer.writeln('''
              </ul>
              <h3 style="color: #6B38FB;">Thông tin thanh toán</h3>
              <p><strong>Tổng tiền hàng:</strong> ${ProductModel.formatPrice(order.subtotal)}</p>
              <p><strong>Phí vận chuyển:</strong> ${ProductModel.formatPrice(order.shippingFee)}</p>
              <p><strong>Thuế:</strong> ${ProductModel.formatPrice(order.discount)}</p>
    ''');

    // Thêm thông tin giảm giá nếu có
    if (order.voucherDiscount > 0) {
      buffer.writeln('''
        <p><strong>Giảm giá voucher (${order.voucherCode}):</strong> -${ProductModel.formatPrice(order.voucherDiscount)}</p>
      ''');
    }
    if (order.pointsDiscount > 0) {
      buffer.writeln('''
        <p><strong>Giảm giá điểm tích lũy (${order.pointsUsed} điểm):</strong> -${ProductModel.formatPrice(order.pointsDiscount)}</p>
      ''');
    }

    buffer.writeln('''
              <p><strong>Tổng cộng:</strong> ${ProductModel.formatPrice(order.total)}</p>
              <h3 style="color: #6B38FB;">Thông tin giao hàng</h3>
              <p><strong>Tên:</strong> ${order.userName}</p>
              <p><strong>Số điện thoại:</strong> ${order.userPhone}</p>
              <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
              <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
              <p style="margin-top: 20px;">Chúng tôi sẽ thông báo khi đơn hàng được giao.</p>
              <p style="font-size: 12px; color: #666;">
                Nếu bạn có câu hỏi, liên hệ với chúng tôi qua email: <a href="mailto:support@gearzone.com">support@gearzone.com</a>.
              </p>
            </div>
          </body>
        </html>
      ''');

    return buffer.toString();
  }
}