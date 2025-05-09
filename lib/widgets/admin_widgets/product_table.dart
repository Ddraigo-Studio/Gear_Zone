import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';


class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    if (isMobile) {
      return Column(
        children: List.generate(
          4,
          (index) => _buildMobileProductItem(context, index),
        ),
      );
    }
    
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Sản phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF727272),
                    fontSize: 12,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  'Giá',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF727272),
                    fontSize: 12,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  'Đã bán',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF727272),
                    fontSize: 12,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  'Trạng thái',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF727272),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Table rows
        ...List.generate(
          4,
          (index) => _buildDesktopProductRow(context, index),
        ),
      ],
    );
  }

  Widget _buildDesktopProductRow(BuildContext context, int index) {
    final products = [
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$20.00',
        'sold': '3000',
        'status': 'Success',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$20.00',
        'sold': '2311',
        'status': 'Success',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$20.00',
        'sold': '2111',
        'status': 'Success',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$20.00',
        'sold': '1661',
        'status': 'Success',
      },
    ];
    
    final product = products[index];
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
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
                      image: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-wprQSB8jA875qnME65FsBjG3b2FuGl.png'),
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
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7E3FF2),
                        ),
                      ),
                      Text(
                        product['name']!,
                        style: const TextStyle(
                          fontSize: 12,
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
            child: Text(
              product['price']!,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              product['sold']!,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE7E7E7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Success',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF04910C),
                ),
                textAlign: TextAlign.center,
              ),
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
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$32,032',
        'sold': '3000',
        'status': 'Success',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$32,032',
        'sold': '2311',
        'status': 'Success',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$32,032',
        'sold': '2111',
        'status': 'Success',
      },
      {
        'id': '021231',
        'name': 'Kanky Kitadakate (Green)',
        'price': '\$32,032',
        'sold': '1661',
        'status': 'Success',
      },
    ];
    
    final product = products[index];
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
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-wprQSB8jA875qnME65FsBjG3b2FuGl.png'),
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
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7E3FF2),
                      ),
                    ),
                    Text(
                      product['name']!,
                      style: const TextStyle(
                        fontSize: 12,
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
              padding: const EdgeInsets.only(left: 52, bottom: 16),
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
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Đã bán',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        product['sold']!,
                        style: const TextStyle(fontSize: 12),
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
                          color: const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Success',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF04910C),
                          ),
                        ),
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
