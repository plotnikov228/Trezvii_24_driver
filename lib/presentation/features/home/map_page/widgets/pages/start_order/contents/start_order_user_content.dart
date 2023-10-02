import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../../../domain/map/models/address_model.dart';
import '../../../../../../../widgets/adresses_buttons.dart';
import '../../../../../../../widgets/app_snack_bar.dart';
import '../../../../../../../widgets/tariff_card.dart';
import '../../../../bloc/event/event.dart';
import '../../../../bloc/state/driver_state.dart';
import '../../../../bloc/state/user_state.dart';
import '../../../map_bottom_bar.dart';

class StartOrderUserContent extends StatelessWidget {
  final StartOrderUserMapState state;
  final Function()? onFromTap;
  final Function()? onToTap;

  const StartOrderUserContent(
      {super.key,
      required this.state,
      this.onFromTap,
      this.onToTap,});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 35),
            child: AddressesButtons(
              from: bloc.fromAddress,
              to: bloc.toAddress,
              onFromTap:onFromTap,
              onToTap: onToTap,
            )),
        Padding(
            padding: const EdgeInsets.only(top: 31, bottom: 11),
            child: SizedBox(
              height: 62,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.tariffList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 35 : 10,
                      ),
                      child: TariffCard(null,
                          tariff: state.tariffList![index],
                          selected: index == state.currentIndexTariff,
                          onTap: () => bloc.add(GoMapEvent(
                              StartOrderUserMapState(currentIndexTariff: index)))),
                    );
                  }),
            )),
        MapBottomBar(
          mainButtonActive: state.canCreateOrder,
          mainButtonText: state.canCreateOrder ? 'Заказать' : 'Неверный маршрут',
            suffixWidget: state.canCreateOrder ? null : IconButton(onPressed: () {
                AppSnackBar.showSnackBar(context, content: 'Выбранный маршрут вне зоны покрытия компании: ${bloc.localities}');
                }, icon: const Icon(Icons.info, color: Colors.white,)),
            bloc: bloc,
            onMainButtonTap: () {
            if(state.canCreateOrder) {
                if (bloc.fromAddress == null || bloc.toAddress == null) {
                  AppSnackBar.showSnackBar(context,
                      content: 'Выберите маршрут поездки');
                } else {
                  bloc.add(CreateOrderMapEvent());
                }
              }
            },
            onPaymentMethodTap: () =>
                bloc.add(GoMapEvent(SelectPaymentMethodMapState())),
            onWishesTap: () => bloc.add(GoMapEvent(AddWishesMapState())))
      ],
    );
  }
}
