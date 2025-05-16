import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_provider.dart';

/// A breadcrumb navigation item
class BreadcrumbItem {
  final String title;
  final AppScreen? screen; // Sử dụng AppScreen enum thay vì int
  final String id;
  final bool isActive;
  final Function? onTap;

  BreadcrumbItem({
    required this.title,
    this.screen, // null means no screen change
    this.id = '',
    this.isActive = false,
    this.onTap,
  });
}

/// A reusable breadcrumb navigation component
class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildBreadcrumbItems(context),
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(BuildContext context) {
    List<Widget> breadcrumbWidgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      // Add the breadcrumb item
      if (isLast) {
        // Last item is current page (active, not clickable)
        breadcrumbWidgets.add(
          Text(
            item.title,
            style: TextStyle(
              fontSize: 12,
              color: item.isActive ? Theme.of(context).primaryColor : Colors.grey,
              fontWeight: item.isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        );
      } else {
        // Clickable breadcrumb item
        breadcrumbWidgets.add(
          TextButton(
            onPressed: () {              if (item.onTap != null) {
                item.onTap!();
              } else if (item.screen != null) {
                // Default behavior - change screen using AppProvider
                final appProvider = Provider.of<AppProvider>(context, listen: false);
                
                if (item.id.isNotEmpty) {
                  // If there's an ID, set it based on the screen
                  if (item.screen == AppScreen.productDetail) { // Product detail screen
                    appProvider.setCurrentProductId(item.id);
                  } else if (item.screen == AppScreen.categoryDetail) { // Category detail screen
                    appProvider.setCurrentCategoryId(item.id);
                  }
                } else {
                  // If it's a category screen and ID is empty, reset category ID
                  if (item.screen == AppScreen.categoryList) {
                    appProvider.setCurrentCategoryId('');
                  }
                  // If it's a product screen and ID is empty, reset product ID
                  else if (item.screen == AppScreen.productList) {
                    appProvider.setCurrentProductId('');
                  }
                }
                
                appProvider.setCurrentScreen(item.screen!);
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }

      // Add separator for all except the last item
      if (!isLast) {
        breadcrumbWidgets.add(
          const Icon(
            Icons.chevron_right,
            size: 16,
            color: Colors.grey,
          ),
        );
      }
    }

    return breadcrumbWidgets;
  }
}

/// Helper to create common breadcrumb paths based on current application state
class BreadcrumbBuilder {  /// Create dashboard breadcrumb
  static BreadcrumbItem dashboard(BuildContext context) {
    return BreadcrumbItem(
      title: 'Bảng điều khiển',
      screen: AppScreen.dashboard,
    );
  }

  /// Create product list breadcrumb
  static BreadcrumbItem products(BuildContext context) {
    return BreadcrumbItem(
      title: 'Sản phẩm',
      screen: AppScreen.productList,
    );
  }

  /// Create category list breadcrumb
  static BreadcrumbItem categories(BuildContext context) {
    return BreadcrumbItem(
      title: 'Danh mục',
      screen: AppScreen.categoryList,
    );
  }

  /// Create a product detail breadcrumb
  static BreadcrumbItem productDetail(BuildContext context, String name) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return BreadcrumbItem(
      title: name,
      screen: AppScreen.productDetail,
      id: appProvider.currentProductId,
      isActive: true,
    );
  }

  /// Create a category detail breadcrumb
  static BreadcrumbItem categoryDetail(BuildContext context, String name) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return BreadcrumbItem(
      title: name,
      screen: AppScreen.categoryDetail,
      id: appProvider.currentCategoryId,
      isActive: true,
    );
  }

  /// Create a product category breadcrumb
  static BreadcrumbItem productCategory(BuildContext context, String categoryName) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return BreadcrumbItem(
      title: categoryName,
      isActive: true,
      onTap: () {
        appProvider.setSelectedCategory(categoryName);
      }
    );
  }
}
