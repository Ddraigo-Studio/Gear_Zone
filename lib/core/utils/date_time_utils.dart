import 'package:intl/intl.dart';

/// Các tiện ích xử lý ngày tháng

/// Định dạng ngày tháng từ chuỗi ISO8601 sang định dạng thân thiện hơn
/// 
/// [isoDate] Chuỗi ISO8601 cần định dạng
/// Trả về chuỗi đã định dạng theo dạng dd/MM/yyyy HH:mm
String formatDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    // Format: dd/MM/yyyy HH:mm
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    // Nếu có lỗi, trả về định dạng ban đầu
    return isoDate.substring(0, isoDate.length >= 16 ? 16 : isoDate.length);
  }
}

/// Định dạng ngày tháng từ DateTime sang định dạng thân thiện hơn
/// 
/// [date] Đối tượng DateTime cần định dạng
/// Trả về chuỗi đã định dạng theo dạng dd/MM/yyyy HH:mm
String formatDateTime(DateTime date) {
  try {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return date.toString();
  }
}

/// Định dạng chỉ hiển thị ngày tháng năm từ chuỗi ISO8601
/// 
/// [isoDate] Chuỗi ISO8601 cần định dạng
/// Trả về chuỗi đã định dạng theo dạng dd/MM/yyyy
String formatDateOnly(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    // Format: dd/MM/yyyy
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  } catch (e) {
    // Nếu có lỗi, trả về định dạng ban đầu
    return isoDate.substring(0, isoDate.length >= 10 ? 10 : isoDate.length);
  }
}