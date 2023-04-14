import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/utils/app_colors.dart';

class Functions {
  static loadingScreen(Future<dynamic> function) async {
    Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.grey,
            ),
          ),
        ),
        name: "",
        barrierDismissible: false);
    var result = await function;
    Get.back();
    return result;
  }
}
