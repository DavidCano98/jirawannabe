import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static TextStyle appBar = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  static TextStyle button({Color color = AppColors.white}) =>
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color);

  static TextStyle title =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.black);

  static TextStyle titleRegular =
  TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.white);

  static TextStyle description({Color color = AppColors.white}) =>
  TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color,);
}
