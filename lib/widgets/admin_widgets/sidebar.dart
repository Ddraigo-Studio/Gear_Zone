import 'package:flutter/material.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/utils/responsive.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: isMobile ? double.infinity : 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  child: Image.asset(
                    'assets/images/img_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'GearZone Store',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Make the menu items scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      'TỔNG QUAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Bảng điều khiển',
                    index: 0,
                    currentIndex: appProvider.currentScreen,
                  ),

                  _buildNestedMenuItem(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'Sản phẩm',
                    detail: '119',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.receipt_outlined,
                    title: 'Giao dịch',
                    detail: '441',
                    index: 1,
                    currentIndex: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.people_outline,
                    title: 'Khách hàng',
                    index: 3,
                    currentIndex: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.insert_chart_outlined,
                    title: 'Báo cáo bán hàng',
                    index: 4,
                    currentIndex: appProvider.currentScreen,
                  ),

                  const Divider(height: 32),

                  // Tools section
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      'CÔNG CỤ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Tài khoản & Cài đặt',
                    index: 5,
                    currentIndex: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline_outlined,
                    title: 'Giúp đỡ',
                    index: 6,
                    currentIndex: appProvider.currentScreen,
                  ),

                  const SizedBox(height: 20),

                  // Dark mode toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                        const Icon(Icons.dark_mode_outlined,
                          size: 18, color: Colors.grey),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                          'Chế độ tối',
                          style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8, // Makes the switch smaller overall
                          child: Switch(
                          value: false,
                          onChanged: (value) {},
                          activeColor: Colors.deepPurple,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User profile section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFEEEEEE), width: 1
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/img_user_3.png',
                    fit: BoxFit.cover,
                  ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Guy Hawkins',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required int currentIndex,
    String? detail,
  }) {
    final isSelected = index == currentIndex;
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        appProvider.setCurrentScreen(index);
        if (Responsive.isMobile(context)) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F6FF) : Colors.transparent,
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (detail != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNestedMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? detail,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        leading: Icon(icon, size: 18, color: Colors.grey[600]),
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (detail != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
        iconColor: Colors.grey,
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.only(left: 48),
        children: [
          _buildNestedSubMenuItem(context, 'LapTop'),
          _buildNestedSubMenuItem(context, 'Máy tính bàn'),
          _buildNestedSubMenuItem(context, 'Chuột'),
          _buildNestedSubMenuItem(context, 'Linh kiện'),
        ],
      ),
    );
  }

  Widget _buildNestedSubMenuItem(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {},
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
