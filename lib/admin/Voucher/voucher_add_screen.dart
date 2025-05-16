import 'package:flutter/material.dart';
import 'package:gear_zone/admin/Voucher/voucher_detail_screen.dart';

class VoucherAddScreen extends StatelessWidget {
  const VoucherAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse the VoucherDetailScreen with isViewOnly set to false
    return const VoucherDetailScreen(
      isViewOnly: false,
    );
  }
}
