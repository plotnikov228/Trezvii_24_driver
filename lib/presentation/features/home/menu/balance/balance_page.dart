import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/state.dart';
import 'package:trezvii_24_driver/presentation/utils/app_images_util.dart';
import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_progress_container.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_snack_bar.dart';

import '../../../../text_field_formatters/card_text_formatter.dart';
import '../../../../utils/app_color_util.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/app_pop_button.dart';
import '../../../../widgets/app_text_form_field.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final bloc = context.read<BalanceBloc>();
    return Scaffold(
      body: BlocConsumer<BalanceBloc, BalanceState>(
        listener: (context, state) => AppSnackBar.showSnackBar(context,
            content: state.message ??
                'Произошла непредвиденная ошибка, попробуйте позже'),
        listenWhen: (prev, cur) =>
            cur.status == Status.Failed || cur.message != null,
        builder: (context, state) => Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                context
                    .read<MenuBloc>()
                    .add(GoMenuEvent(newState: InitialMenuState()));
                return false;
              },
              child: SafeArea(
                child:Column(
                children: [
                   Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: AppPopButton(context,
                          text: 'Баланс',
                          onTap: () => context
                              .read<MenuBloc>()
                              .add(GoMenuEvent(newState: InitialMenuState())),
                          color: Colors.black,
                          textStyle: AppStyle.black16),
                    ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 48, bottom: 15, left: 15, right: 15),
                      child: IgnorePointer(
                          child: Center(
                              child: AppTextFormField(
                        TextEditingController(text: '${state.balance} р.'),
                      )))),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Для перевода, введите номер карты, сохраните его и нажмите на кнопку: “Вывести средства”',
                        style: AppStyle.black14,
                        overflow: TextOverflow.visible,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                            bottom: -10,
                            child: Container(
                              height: 176,
                          width: size.width - 70 > 305 ? 305 : size.width - 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                              color: AppColor.fleshColor,),)),

                        Container(
                          height: 176,
                          width: size.width - 40 > 335 ? 335 : size.width - 40,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AppImages.cardFormBg),
                                  fit: BoxFit.fill)),
                          child: Form(
                            key: key,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 57, bottom: 27),
                                    child: AppTextFormField(bloc.cardController,
                                        hintText: state.card?.number ??
                                            'Введите номер вашей карты',
                                        height: 38,
                                        showBorder: false, maxLength: 19, formatters: [CardTextInputFormatter()], keyboardType: TextInputType.number),
                                  ),
                                  Text(
                                    context.read<MenuBloc>().user?.name ?? '',
                                    style: AppStyle.black23.copyWith(color: Colors.white),
                                    overflow: TextOverflow.visible,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: AppElevatedButton(
                      width: 210,
                      height: 50,
                        text: 'Сохранить',
                        onTap: () {
                          final validate =
                              bloc.validateCreditCard(bloc.cardController.text);
                          if(validate) {
                            bloc.add(SaveCardBalanceEvent(bloc.cardController.text, context));
                          } else {
                            AppSnackBar.showSnackBar(context, content: 'Вы ввели неверный формат банковской карты');
                          }
                        }),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: size.width,
                          height: 103,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, -5),
                                    color: Colors.black12,
                                    spreadRadius: 5,
                                    blurRadius: 5)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: AppElevatedButton(
                                  width: size.width - 60,
                                  height: state.balance > 0 ? 38 : 48,
                                  bgColor: state.balance > 0
                                      ? AppColor.firstColor
                                      : AppColor.firstColor.withOpacity(0.8),
                                  text: state.balance > 0
                                      ? 'Вывести средства'
                                      : 'Недостаточно средств для вывода',
                                  onTap: () {
                                    if (state.balance > 0) {
                                      bloc.add(WithdrawalOfFundsBalanceEvent());
                                    }
                                  }),
                            ),
                          ),
                        )),
                  ),
                ],
              ),)
            ),
            if (state.status == Status.Loading)
              Container(
                width: size.width,
                height: size.height,
                color: Colors.grey.withOpacity(0.3),
                child: Center(
                  child: AppProgressContainer(),
                ),
              )

          ],
        ),
      ),

    );
  }
}
