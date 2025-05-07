import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const Text(
            'Khách hàng',
            style: TextStyle(
              fontSize: 24,
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
                    fontSize: 14,
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
                  'Khách hàng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Filter and add customer
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
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Lọc'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm khách hàng'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Customers table
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
                          flex: 2,
                          child: Text(
                            'Tên khách hàng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Liên hệ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Địa chỉ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
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
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Table rows
                ...List.generate(
                  8,
                  (index) => isMobile
                      ? _buildMobileCustomerItem(context, index)
                      : _buildDesktopCustomerRow(context, index),
                ),
                
                // Pagination
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '1 - 10 của 13 trang',
                        style: TextStyle(
                          fontSize: 14,
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

  Widget _buildDesktopCustomerRow(BuildContext context, int index) {
    final customers = [
      {
        'id': 'ID 12451',
        'name': 'Leslie Alexander',
        'email': 'georgia@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      },
      {
        'id': 'ID 12452',
        'name': 'Guy Hawkins',
        'email': 'guys@examp.com',
        'phone': '+62 819 1314 1435',
        'address': '4517 Washington Ave. Manchester, Kentucky 39495',
      },
      {
        'id': 'ID 12453',
        'name': 'Kristin Watson',
        'email': 'kristin@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      },
      {
        'id': 'ID 12453',
        'name': 'Kristin Watson',
        'email': 'kristin@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      },
      {
        'id': 'ID 12452',
        'name': 'Guy Hawkins',
        'email': 'guys@examp.com',
        'phone': '+62 819 1314 1435',
        'address': '4517 Washington Ave. Manchester, Kentucky 39495',
      },
      {
        'id': 'ID 12451',
        'name': 'Leslie Alexander',
        'email': 'georgia@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      },
      {
        'id': 'ID 12453',
        'name': 'Kristin Watson',
        'email': 'kristin@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      },
      {
        'id': 'ID 12451',
        'name': 'Leslie Alexander',
        'email': 'georgia@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      },
    ];
    
    final customer = customers[index % customers.length];
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer['id']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  customer['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer['email']!,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  customer['phone']!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              customer['address']!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildMobileCustomerItem(BuildContext context, int index) {
    final customers = [
      {
        'id': 'ID 12451',
        'name': 'Leslie Alexander',
        'email': 'georgia@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      },
      {
        'id': 'ID 12452',
        'name': 'Guy Hawkins',
        'email': 'guys@examp.com',
        'phone': '+62 819 1314 1435',
        'address': '4517 Washington Ave. Manchester, Kentucky 39495',
      },
      {
        'id': 'ID 12453',
        'name': 'Kristin Watson',
        'email': 'kristin@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      },
      {
        'id': 'ID 12453',
        'name': 'Kristin Watson',
        'email': 'kristin@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      },
      {
        'id': 'ID 12452',
        'name': 'Guy Hawkins',
        'email': 'guys@examp.com',
        'phone': '+62 819 1314 1435',
        'address': '4517 Washington Ave. Manchester, Kentucky 39495',
      },
      {
        'id': 'ID 12451',
        'name': 'Leslie Alexander',
        'email': 'georgia@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      },
      {
        'id': 'ID 12453',
        'name': 'Kristin Watson',
        'email': 'kristin@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      },
      {
        'id': 'ID 12451',
        'name': 'Leslie Alexander',
        'email': 'georgia@example.com',
        'phone': '+62 819 1314 1435',
        'address': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      },
    ];
    
    final customer = customers[index % customers.length];
    final isExpanded = index == 0;
    
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['id']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      customer['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.only(left: 48, bottom: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Liên hệ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer['email']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              customer['phone']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Địa chỉ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          customer['address']!,
                          style: const TextStyle(fontSize: 14),
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
