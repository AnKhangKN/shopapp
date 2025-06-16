import 'package:flutter/material.dart';
import 'package:shopapp/constants/app_colors.dart';

class CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryHeaderDelegate({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories = ["Tất cả", "Giày"];

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) => _buildCategory(cat)).toList(),
        ),
      ),
    );
  }

  Widget _buildCategory(String title) {
    final isSelected = selectedCategory == title;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () => onCategorySelected(title),
        child: Chip(
          label: Text(title),
          visualDensity: const VisualDensity(vertical: -2),
          backgroundColor: isSelected
              ? AppColors.textPrimary
              : AppColors.colorWhite,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant CategoryHeaderDelegate oldDelegate) =>
      oldDelegate.selectedCategory != selectedCategory;
}
