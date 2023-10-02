import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';

Widget AppProgressContainer () {
  return Center(
    child: Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.firstColor,
      ),
      child: const Center(child: CircularProgressIndicator(color: Colors.white,)),
    ),
  );
}