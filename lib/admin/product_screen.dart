import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const Text(
            'Danh sách sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Breadcrumb
          Row(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Bảng điều khiển',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Sản phẩm',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Laptop',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Search and filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm ID, tên sản phẩm',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Lọc'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Xuất'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Sản phẩm mới'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryTab(context, 'LapTop (50)', isSelected: true),
                      _buildCategoryTab(context, 'Máy tính bàn (26)'),
                      _buildCategoryTab(context, 'Chuột (121)'),
                      _buildCategoryTab(context, 'Linh kiện (21)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Products table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (!isMobile)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Sản phẩm',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Giá',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Số lượng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Ngày nhập',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Trạng thái',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Hành động',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Table rows
                ...List.generate(
                  8,
                  (index) => isMobile
                      ? _buildMobileProductItem(context, index)
                      : _buildDesktopProductRow(context, index),
                ),
                
                // Pagination
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '1 - 10 của 13 trang',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Trang trên',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Text('1'),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_left),
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context, String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopProductRow(BuildContext context, int index) {
    final products = [
      {
        'id': '021231',
        'name': 'Beigi Coffe (Navy)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '021231',
        'name': 'Beigi Coffe (Navy)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '021231',
        'name': 'Story Honzo (Cream)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '021231',
        'name': 'Story Honzo (Black)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '021231',
        'name': 'Story Honzo (Cream)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '021231',
        'name': 'Beigi Coffe (Navy)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$20.00',
        'quantity': '234',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
    ];
    
    final product = products[index % products.length];
    final isAvailable = product['status'] == 'Có sẵn';
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-W2WjXRd99YcTLHtj2JK4mRgqq9KzVJ.png'),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['id']!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        product['name']!,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(product['price']!),
          ),
          Expanded(
            flex: 1,
            child: Text(product['quantity']!),
          ),
          Expanded(
            flex: 1,
            child: Text(product['date']!),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product['status']!,
                style: TextStyle(
                  fontSize: 11,
                  color: isAvailable ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  onPressed: () {},
                  color: Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () {},
                  color: Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outlined, size: 20),
                  onPressed: () {},
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileProductItem(BuildContext context, int index) {
    final products = [
      {
        'id': '021231',
        'name': 'Story Honzo (Black)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '021231',
        'name': 'Story Honzo (Cream)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '133113',
        'name': 'Beigi Coffe (Navy)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '133113',
        'name': 'Beigi Coffe (Navy)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '512311',
        'name': 'Story Honzo (Cream)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '021231',
        'name': 'Story Honzo (Cream)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Hết hàng',
      },
      {
        'id': '133113',
        'name': 'Beigi Coffe (Navy)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
      {
        'id': '133113',
        'name': 'Story Kitadake (Green)',
        'price': '\$32,032',
        'quantity': '3000',
        'date': '04/17/23 at 8:25 PM',
        'status': 'Có sẵn',
      },
    ];
    
    final product = products[index % products.length];
    final isExpanded = index == 0;
    final isAvailable = product['status'] == 'Có sẵn';
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-W2WjXRd99YcTLHtj2JK4mRgqq9KzVJ.png'),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['id']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      product['name']!,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 76, bottom: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Giá',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        product['price']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Số lượng',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        product['quantity']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Ngày nhập',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        product['date']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Trạng thái',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product['status']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Hành động',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 20),
                            onPressed: () {},
                            color: Colors.grey,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () {},
                            color: Colors.grey,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.delete_outlined, size: 20),
                            onPressed: () {},
                            color: Colors.grey,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
