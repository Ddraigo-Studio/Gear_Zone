// Tiện ích xử lý màu sắc cho Gear Zone
import 'package:flutter/material.dart';

class ColorUtils {
  // Chuyển đổi tên màu thành đối tượng Color
  static Color getColorFromName(String colorName) {
    // Chuẩn hóa tên màu bằng cách loại bỏ dấu và chuyển thành chữ thường
    String normalizedName = normalizeColorName(colorName.toLowerCase());

    switch (normalizedName) {
      case "do":
      case "red":
        return Colors.red;
      case "xanh duong":
      case "xanh":
      case "blue":
        return Colors.blue;
      case "xanh la":
      case "green":
        return Colors.green;
      case "den":
      case "black":
        return Colors.black;
      case "trang":
      case "white":
        return Colors.white;
      case "vang":
      case "yellow":
        return Colors.yellow;
      case "gold":
      case "vang kim":
        return const Color(0xFFFFD700); // Gold color
      case "tim":
      case "purple":
        return Colors.purple;
      case "hong":
      case "pink":
        return Colors.pink;
      case "cam":
      case "orange":
        return Colors.orange;
      case "xam":
      case "gray":
      case "grey":
        return Colors.grey;
      case "nau":
      case "brown":
        return Colors.brown;
      case "xanh den":
      case "navy":
      case "navy blue":
        return const Color.fromARGB(255, 29, 46, 107);
      case "bac":
      case "silver":
        return const Color(0xFFC0C0C0); // Silver color
      case "aqua":
      case "cyan":
        return Colors.cyan;
      case "mint":
      case "mint green":
        return const Color(0xFF98FB98); // Mint green
      case "rose gold":
      case "hong vang":
        return const Color(0xFFB76E79); // Rose gold color
      case "space gray":
      case "space grey":
      case "xam vu tru":
        return const Color(0xFF343d46); // Space gray
      default:
        // Đối với màu không xác định, sử dụng màu trung tính
        return Colors.blueGrey;
    }
  }

  // Phương thức tiện ích để chuẩn hóa tên màu tiếng Việt
  static String normalizeColorName(String colorName) {
    // Loại bỏ dấu từ các ký tự tiếng Việt
    final Map<String, String> diacriticsMap = {
      'á': 'a',
      'à': 'a',
      'ả': 'a',
      'ã': 'a',
      'ạ': 'a',
      'ă': 'a',
      'ắ': 'a',
      'ằ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'ặ': 'a',
      'â': 'a',
      'ấ': 'a',
      'ầ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ậ': 'a',
      'đ': 'd',
      'é': 'e',
      'è': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ẹ': 'e',
      'ê': 'e',
      'ế': 'e',
      'ề': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ệ': 'e',
      'í': 'i',
      'ì': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ị': 'i',
      'ó': 'o',
      'ò': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ọ': 'o',
      'ô': 'o',
      'ố': 'o',
      'ồ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ộ': 'o',
      'ơ': 'o',
      'ớ': 'o',
      'ờ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ợ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ụ': 'u',
      'ư': 'u',
      'ứ': 'u',
      'ừ': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ự': 'u',
      'ý': 'y',
      'ỳ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'ỵ': 'y',
    };

    String normalized = colorName;
    diacriticsMap.forEach((from, to) {
      normalized = normalized.replaceAll(from, to);
    });

    return normalized;
  }
  
  // Kiểm tra xem màu có tối hay không để quyết định sử dụng văn bản trắng hay đen
  static bool shouldUseWhiteText(Color color) {
    // Tính độ sáng sử dụng công thức: (0.299*R + 0.587*G + 0.114*B)
    // Nếu dưới 128, đó là màu tối và nên sử dụng văn bản màu trắng
    final double brightness = color.red * 0.299 + color.green * 0.587 + color.blue * 0.114;
    return brightness < 128;
  }
}
