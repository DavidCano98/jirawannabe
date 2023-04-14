import 'package:flutter/material.dart';
import 'package:jirawannabe/utils/app_colors.dart';
import 'package:jirawannabe/utils/app_styles.dart';

class CustomSwitcher extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final bool isFocused;
  final Color backgroundColor;
  final Color textColor;
  final Color focusedBackgroundColor;
  final Color focusedTextColor;

  const CustomSwitcher(this.title, this.isFocused, this.onTap,
      {Key? key,
      this.backgroundColor = AppColors.blue,
      this.textColor = AppColors.white,
      this.focusedBackgroundColor = AppColors.white,
      this.focusedTextColor = AppColors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        color: isFocused ? AppColors.white : AppColors.blue,
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppStyles.button(color: isFocused ? AppColors.blue : AppColors.white),
        ),
      ),
    );
  }
}
