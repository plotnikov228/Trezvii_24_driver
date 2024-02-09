import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/presentation/utils/app_style_util.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_elevated_button.dart';

import '../../../../../../utils/size_util.dart';

class EmergencyCancellationMessage extends StatelessWidget {
  final Function()? onAccept;
  final Function()? onCancel;

  const EmergencyCancellationMessage({Key? key, this.onAccept, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 260,
        width: size.width > 500 ? 500 : size.width - 40,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Вы уверены, что хотите экстренно отменить заказ? отменяя экстренный заказ более 3 раз, вам могут заблокировать доступ к приложению!', style: AppStyle.black14,),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(children: [
                    AppElevatedButton(onTap: onAccept, text: 'Отменить заказ',height: 40),
                    const SizedBox(width: 10,),
                    AppElevatedButton(onTap: onCancel, text: 'Не отменять заказ',height: 40),
                  ],),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}