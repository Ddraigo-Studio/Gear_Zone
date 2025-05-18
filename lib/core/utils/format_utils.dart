import 'package:intl/intl.dart';

/// Format utilities for consistent formatting across the app
class FormatUtils {  /// Formats a price value to Vietnamese currency format
  /// 
  /// Example: `formatPrice(25000)` returns `"25.000đ"`
  /// 
  /// Parameters:
  /// - `price`: The price value to format
  /// - `symbol`: The currency symbol (defaults to 'đ')
  /// - `decimalDigits`: Number of decimal digits (defaults to 0)
  /// - `compactFormat`: Whether to use compact format for large numbers (defaults to false)
  static String formatPrice(
    dynamic price, {
    String symbol = 'đ',
    int decimalDigits = 0,
    bool compactFormat = false,
    String symbolPosition = 'right',
  }) {    if (price == null) return symbolPosition == 'right' ? "0$symbol" : "$symbol 0";
    
    double priceValue;
    
    if (price is String) {
      try {
        priceValue = double.parse(price);
      } catch (e) {
        return symbolPosition == 'right' ? "0$symbol" : "$symbol 0";
      }
    } else if (price is int) {
      priceValue = price.toDouble();
    } else if (price is double) {
      priceValue = price;
    } else {
      return symbolPosition == 'right' ? "0$symbol" : "$symbol 0";
    }
    
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: decimalDigits,
    );    if (compactFormat && priceValue >= 1000000) {
      // Format in millions for large numbers
      final compactFormatter = NumberFormat.compact(locale: 'vi_VN');
      return symbolPosition == 'right' 
        ? "${compactFormatter.format(priceValue)}$symbol"
        : "$symbol ${compactFormatter.format(priceValue)}";
    }

    return symbolPosition == 'right' 
      ? "${formatter.format(priceValue)}$symbol" 
      : "$symbol ${formatter.format(priceValue)}";
  }
  
  /// Formats a date to Vietnamese standard format
  /// 
  /// Example: `formatDate(DateTime.now())` returns `"01/05/2023"`
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }
  
  /// Formats a date and time to Vietnamese standard format
  /// 
  /// Example: `formatDateTime(DateTime.now())` returns `"01/05/2023 14:30"`
  static String formatDateTime(DateTime dateTime, {String format = 'dd/MM/yyyy HH:mm'}) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}
