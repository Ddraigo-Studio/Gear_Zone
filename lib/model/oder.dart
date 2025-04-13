import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double amount;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.items,
    required this.amount,
    required this.dateTime,
  });
}
