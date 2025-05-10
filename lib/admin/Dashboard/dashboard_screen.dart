import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return Scaffold(
      appBar: isMobile ? AppBar(
        title: const Text('Bảng điều khiển'),
        backgroundColor: Colors.white,
        elevation: 0,
      ) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bảng điều khiển',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bảng điều khiển',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            
            // Sales target card
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mục tiêu bán hàng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đang tiến hành',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Text(
                            '\$231,032,444',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Mục tiêu bán hàng',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Text(
                            '\$500,000,00',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                        elevation: 1,
                        pressedElevation: 3,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                      valueIndicatorShape: SliderComponentShape.noOverlay,
                      trackShape: const RoundedRectSliderTrackShape(),
                      activeTrackColor: const Color.fromARGB(255, 148, 105, 222), // Đổi thành màu tím
                      inactiveTrackColor: Colors.grey.shade200,
                    ),
                    child: Slider(
                      value: 0.4,
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Sales chart
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Doanh số bán hàng của bạn trong năm nay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Text(
                              'Hiển thị tất cả',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Legend
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFBCFF5C),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Giá trị bán trung bình',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.purple[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Giá bán trung bình của một mặt hàng',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Chart area
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // Left value box
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue.shade100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Giá bán trung bình của một mặt hàng',
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                  const Text(
                                    '\$ 211,411,223',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Right value box positioned at the right
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBCFF5C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Giá trị bán trung bình',
                                  style: TextStyle(fontSize: 10, color: Colors.black87),
                                ),
                                const Text(
                                  '\$ 339,091,888',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Actual chart
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                // Green line
                                LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 2),
                                    const FlSpot(1, 1.8),
                                    const FlSpot(2, 1.5),
                                    const FlSpot(3, 2),
                                    const FlSpot(4, 1.8),
                                    const FlSpot(5, 3),
                                    const FlSpot(6, 2.6),
                                    const FlSpot(7, 2.9),
                                    const FlSpot(8, 3.2),
                                    const FlSpot(9, 3.1),
                                    const FlSpot(10, 3.3),
                                    const FlSpot(11, 3.5),
                                  ],
                                  isCurved: true,
                                  color: const Color(0xFFBCFF5C),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                ),
                                // Purple line
                                LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 1),
                                    const FlSpot(1, 1.2),
                                    const FlSpot(2, 1),
                                    const FlSpot(3, 1.5),
                                    const FlSpot(4, 1.3),
                                    const FlSpot(5, 1.8),
                                    const FlSpot(6, 1.7),
                                    const FlSpot(7, 2),
                                    const FlSpot(8, 2.2),
                                    const FlSpot(9, 2.1),
                                    const FlSpot(10, 2.3),
                                    const FlSpot(11, 2.4),
                                  ],
                                  isCurved: true,
                                  color: Colors.purple[300],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                              lineTouchData: LineTouchData(enabled: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Month labels
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: months.map((month) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          month,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Stats cards grid
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
              ),
              children: [
                _buildStatCard(
                  context: context,
                  title: 'Tổng doanh thu',
                  value: '\$81.000',
                  percentChange: 10.6,
                  isPositive: true,
                  color: Colors.deepPurple,
                ),
                _buildStatCard(
                  context: context,
                  title: 'Tổng khách hàng',
                  value: '5.000',
                  percentChange: 1.5,
                  isPositive: true,
                  color: Colors.green,
                ),
                _buildStatCard(
                  context: context,
                  title: 'Tổng số giao dịch',
                  value: '12.000',
                  percentChange: 3.6,
                  isPositive: true,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context: context,
                  title: 'Tổng sản phẩm',
                  value: '5.000',
                  percentChange: 1.5,
                  isPositive: false,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Promotion card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage('images/learn_more.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tăng doanh số bán hàng của bạn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Khám phá các phương pháp đã được chứng minh để tăng vọt doanh số của bạn! Giải phóng tiềm năng của doanh nghiệp và đạt được sự tăng trưởng đáng kể. Cho dù bạn là một doanh nhân đầy đam mê hay chỉ mới bắt đầu.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Tìm hiểu thêm'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Popular products
            Container(
              width: double.infinity,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sản phẩm phổ biến',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('Hiển thị tất cả'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Products table
                  Column(
                    children: [
                      // Table header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Sản phẩm',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Giá',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Đã bán',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Trạng thái',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Table rows
                      ...List.generate(
                        4,
                        (index) => _buildProductRow(
                          context,
                          productId: '021231',
                          productName: 'Kanky Kitadakate (Green)',
                          price: '\$20.00',
                          sold: index == 0 ? '3000' : (3000 - index * 300).toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required double percentChange,
    required bool isPositive,
    required Color color,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${percentChange.toString()}%',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Từ tuần trước',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductRow(
    BuildContext context, {
    required String productId,
    required String productName,
    required String price,
    required String sold,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                    color: Colors.grey[200],
                  ),
                  child: Image.network(
                    'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/GearZone-W2WjXRd99YcTLHtj2JK4mRgqq9KzVJ.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productId,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(price),
          ),
          Expanded(
            child: Text(sold),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Success',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
