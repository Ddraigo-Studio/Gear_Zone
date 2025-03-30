import 'package:flutter/material.dart';
import '../Items/ordered_item.dart';
import '../../core/app_export.dart';
class OrderTabPage extends StatefulWidget {
  const OrderTabPage({super.key});

  @override
  OrderTabPageState createState() => OrderTabPageState();
}
class OrderTabPageState extends State<OrderTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [_buildOrderList(context)],
      ),
    );
  }

  /// Section Widget
  Widget _buildOrderList(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 16.h,
          );
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return OrderedItem();
        },
      ),
    );
  }
}

