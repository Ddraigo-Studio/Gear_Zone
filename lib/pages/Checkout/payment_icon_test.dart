// Đây là file tạm thời để test các sửa đổi
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';

class PaymentIconTest extends StatelessWidget {
  final String paymentIcon;

  const PaymentIconTest({
    super.key,
    required this.paymentIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Testing payment icon'),
            SizedBox(height: 20),
            // Test hiển thị icon với các cách khác nhau
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cách 1: Sử dụng CustomImageView như trong ứng dụng
                Column(
                  children: [
                    CustomImageView(
                      imagePath: paymentIcon,
                      height: 50,
                      width: 50,
                    ),
                    Text('CustomImageView'),
                  ],
                ),
                SizedBox(width: 20),
                // Cách 2: Sử dụng Image.asset trực tiếp
                Column(
                  children: [
                    Image.asset(
                      paymentIcon,
                      height: 50,
                      width: 50,
                    ),
                    Text('Image.asset'),
                  ],
                ),
                SizedBox(width: 20),
                // Cách 3: Sử dụng SvgPicture.asset
                Column(
                  children: [
                    SvgPicture.asset(
                      paymentIcon,
                      height: 50,
                      width: 50,
                    ),
                    Text('SvgPicture.asset'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
