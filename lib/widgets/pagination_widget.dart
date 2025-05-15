import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final Function(int) onPageChanged;

  const PaginationWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    // Tạo danh sách các trang để hiển thị
    List<int> pageNumbers = [];
    
    // Trong trường hợp số trang ít, hiển thị tất cả
    if (totalPages <= 5) {
      pageNumbers = List.generate(totalPages, (index) => index + 1);
    } else {
      // Trong trường hợp nhiều trang, hiển thị trang hiện tại và một số trang xung quanh
      pageNumbers.add(1); // Luôn hiển thị trang đầu tiên
      
      if (currentPage > 3) {
        pageNumbers.add(-1); // Dấu ... cho trang bị bỏ qua
      }
      
      // Thêm các trang xung quanh trang hiện tại
      for (int i = Math.max(2, currentPage - 1); i <= Math.min(totalPages - 1, currentPage + 1); i++) {
        pageNumbers.add(i);
      }
      
      if (currentPage < totalPages - 2) {
        pageNumbers.add(-1); // Dấu ... cho trang bị bỏ qua
      }
      
      pageNumbers.add(totalPages); // Luôn hiển thị trang cuối cùng
    }

    // UI cho phân trang trên thiết bị di động
    if (isMobile) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: hasPreviousPage 
                ? () => onPageChanged(currentPage - 1)
                : null,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              backgroundColor: hasPreviousPage ? Colors.white : Colors.grey.shade100,
              foregroundColor: hasPreviousPage ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$currentPage / $totalPages',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            onPressed: hasNextPage 
                ? () => onPageChanged(currentPage + 1)
                : null,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              backgroundColor: hasNextPage ? Colors.white : Colors.grey.shade100,
              foregroundColor: hasNextPage ? Colors.black : Colors.grey,
            ),
          ),
        ],
      );
    }

    // UI cho phân trang trên desktop
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Số trang
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Trang',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        
        // Hiển thị danh sách trang
        Row(
          children: pageNumbers.map((pageNumber) {
            // Trường hợp đặc biệt cho dấu "..."
            if (pageNumber == -1) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  '...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            }
            
            // Trang thông thường
            return InkWell(
              onTap: pageNumber != currentPage ? () => onPageChanged(pageNumber) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: pageNumber == currentPage ? Theme.of(context).primaryColor : Colors.transparent,
                  border: Border.all(
                    color: pageNumber == currentPage ? Theme.of(context).primaryColor : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$pageNumber',
                  style: TextStyle(
                    fontSize: 14,
                    color: pageNumber == currentPage ? Colors.white : Colors.black,
                    fontWeight: pageNumber == currentPage ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        // Nút chuyển trang trước/sau
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: hasPreviousPage ? () => onPageChanged(currentPage - 1) : null,
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            backgroundColor: hasPreviousPage ? Colors.white : Colors.grey.shade100,
            foregroundColor: hasPreviousPage ? Colors.black : Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right),
          onPressed: hasNextPage ? () => onPageChanged(currentPage + 1) : null,
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            backgroundColor: hasNextPage ? Colors.white : Colors.grey.shade100,
            foregroundColor: hasNextPage ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Tiện ích Math để tránh lỗi
class Math {
  static int max(int a, int b) => a > b ? a : b;
  static int min(int a, int b) => a < b ? a : b;
}
