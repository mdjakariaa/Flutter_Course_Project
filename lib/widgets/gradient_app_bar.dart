import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const GradientAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(alignment: Alignment.centerLeft, child: Text(title)),
            )
          : null,
      centerTitle: centerTitle,
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB8F2C1), Color(0xFFB8D8FF)],
          ),
        ),
      ),
    );
  }
}
