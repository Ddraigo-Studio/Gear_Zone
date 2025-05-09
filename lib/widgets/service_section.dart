import 'package:flutter/material.dart';
import '../core/app_export.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildServiceItem(
            context,
            icon: Icons.local_shipping_outlined,
            title: 'Giao hàng nhanh chóng',
            subtitle: 'Giao hàng nhanh chóng và tận nơi',
            color: appTheme.deepPurple400,
          ),
          _buildServiceItem(
            context,
            icon: Icons.headset_mic_outlined,
            title: 'Hỗ trợ khách hàng 24/7',
            subtitle: 'Hỗ trợ trực tuyến khách hàng',
            color: appTheme.deepPurple400,
          ),
          _buildServiceItem(
            context,
            icon: Icons.security_outlined,
            title: 'Hoàn tiền dễ dàng',
            subtitle: 'Cam kết hoàn tiền trong 30 ngày',
            color: appTheme.deepPurple400,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.h,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.fSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.fSize,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
