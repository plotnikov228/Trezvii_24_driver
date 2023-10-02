import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/domain/tutorial/models/tariff_model.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';
import 'package:trezvii_24_driver/presentation/utils/app_images_util.dart';
import 'package:trezvii_24_driver/presentation/utils/app_style_util.dart';

import '../../domain/payment/models/tariff.dart';

Widget TariffCard(TariffModel? tariffModel, {Tariff? tariff, bool selected = false, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 144,
      height: 62,
      decoration: BoxDecoration(
          color: selected ? AppColor.firstColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? AppColor.secondColor : AppColor.gray,
              width: selected ? 2 : 1)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tariff?.name ?? tariffModel!.name,
                style: AppStyle.darkBlue14,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tariff?.displayCost??  'от ${tariffModel!.cost.round()} р.',
                      style:
                          AppStyle.black14.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      AppImages.awesome,
                      height: 24,
                      width: 24,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
