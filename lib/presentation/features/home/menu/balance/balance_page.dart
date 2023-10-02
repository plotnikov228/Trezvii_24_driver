
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/state.dart';

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

  const BalancePage(
      {super.key,});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BalanceBloc>();
    return Scaffold(
      body: BlocBuilder<BalanceBloc, BalanceState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
            return false;
          },
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppPopButton(context,
                      text: 'Баланс',
                      onTap: () => context
                          .read<MenuBloc>()
                          .add(GoMenuEvent(newState: InitialMenuState())),
                      color: Colors.black,
                      textStyle: AppStyle.black16),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 15, left: 15, right: 15),
                  child: IgnorePointer(child: Center(child: AppTextFormField(TextEditingController(text: '${state.balance} р.'),

                  )))
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Для перевода, нажмите на кнопку: “Вывести средства”', style: AppStyle.black14, overflow: TextOverflow.visible,)),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: size.width,
                      height: 103,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
                              bgColor: state.balance > 0 ? AppColor.firstColor : AppColor.firstColor.withOpacity(0.8),
                              text: state.balance > 0 ? 'Вывести средства': 'Недостаточно средств для вывода',
                              onTap: () {
                                if(state.balance > 0) {
                                  bloc.add(WithdrawalOfFundsBalanceEvent());
                                }
                              }),
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
