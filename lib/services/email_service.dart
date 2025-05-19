import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../model/cart_item.dart';
import '../../model/product.dart';

class EmailService {
  // Cấu hình thông tin SMTP
  final String _email = 'thhg1010@gmail.com'; // Thay bằng email của bạn
  final String _appPassword = 'bltj blxk qwpa yftu'; // Thay bằng mật khẩu ứng dụng

  Future<void> sendOrderConfirmation(
    String orderId,
    String userEmail,
    List<CartItem> items,
    double totalPrice,
    Map<String, dynamic> shippingAddress,
  ) async {
    // Tạo SMTP server cho Gmail
    final smtpServer = gmail(_email, _appPassword);

    // Tạo nội dung email
    final message = Message()
      ..from = Address(_email, 'Gear Zone') // Tên ứng dụng của bạn
      ..recipients.add(userEmail)
      ..subject = 'Xác nhận đơn hàng - Mã đơn #$orderId'
      ..html = _buildOrderEmailContent(orderId, items, totalPrice, shippingAddress);

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
    List<CartItem> items,
    double totalPrice,
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

    // Thêm danh sách sản phẩm
    for (var item in items) {
      buffer.writeln('''
        <li style="margin-bottom: 10px;">
          ${item.productName} (Màu: ${item.color}, Số lượng: ${item.quantity}) - ${ProductModel.formatPrice(item.discountedPrice)}
        </li>
      ''');
    }

    buffer.writeln('''
              </ul>
              <p><strong>Địa chỉ giao hàng:</strong> ${shippingAddress['fullAddress'] ?? 'Không có thông tin'}</p>
              <p><strong>Tổng cộng:</strong> ${ProductModel.formatPrice(totalPrice)}</p>
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