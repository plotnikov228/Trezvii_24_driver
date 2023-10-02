import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';
import 'package:trezvii_24_driver/presentation/utils/app_style_util.dart';

import '../../domain/map/models/address_model.dart';
import '../utils/size_util.dart';

Widget AddressCard(AddressModel addressModel, Function(AddressModel) onTap, {double? width}) {
  if (addressModel.name != null) {
    return GestureDetector(
      onTap: () => onTap(addressModel),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Align(alignment: Alignment.centerLeft,
              child: Icon(
                Icons.favorite_border,
                color: AppColor.firstColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addressModel.name!,
                style: AppStyle.black14.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                addressModel.addressName,
                style: AppStyle.black10,
              )
            ],
          ),
        ],
      ),
    );
  }

  return GestureDetector(
    onTap: () => onTap(addressModel),
    child: Text(
      addressModel.addressName,
      style: AppStyle.black17,
      overflow: TextOverflow.visible,
    ),
  );
}
