/*
 *
 *  Created by Mahendra Vijay, Kanmalai Technologies Pvt. Ltd on 31/3/21 5:42 PM.
 *  Copyright (c) 2021. All rights reserved.
 *  Last modified 31/3/21 5:42 PM by Mahendra Vijay.
 * /
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackBarAlert(String type, String message, Icon icon, Color bgColor,
    Color textColor) async {
  Get.snackbar(
    type,
    message,
    icon: icon,
    margin: const EdgeInsets.all(10.0),
    colorText: textColor,
    shouldIconPulse: true,
    duration: Duration(seconds: 2),
    backgroundColor: bgColor,
    snackPosition: SnackPosition.BOTTOM,
  );
}
