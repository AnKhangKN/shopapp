import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Color? iconColor;
  final Color? backgroundColor;

  const CustomAppBar({
    Key? key,
    this.actions,
    this.iconColor,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: backgroundColor,

      actionsIconTheme: IconThemeData(
        color: iconColor,
      ),

      actions: actions,

      elevation: 0, // Đổ bóng
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
