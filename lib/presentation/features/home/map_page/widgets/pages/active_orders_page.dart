import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/domain/firebase/order/model/order_status.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_elevated_button.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_pop_button.dart';

import '../../../../../utils/size_util.dart';
import '../../../../../widgets/full_order_card_widget.dart';

class ActiveOrdersPage extends StatelessWidget {
  final MapBloc bloc;
  final ActiveOrdersMapState state;

  const ActiveOrdersPage({
    super.key,
    required this.bloc,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.add(GoMapEvent(bloc.previousState!));
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 48,
                      ),
                      child: AppPopButton(context,
                          onTap: () => bloc.add(GoMapEvent(bloc.previousState!)),
                          text: 'Текущие заказы', color: Colors.black),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          width: size.width - 24,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.white,
                                    Colors.white,
                                Colors.white12
                              ])),
                        ),
                        SizedBox(
                          height: size.height - 150,
                            child: ListView.builder(
                                itemCount: state.orders!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: index == 0 ? 50 : 10),
                                    child: FullOrderCardWidget(
                                      order:state.orders![index],
                                      onCancel: state.orders![index].order.isActive() && state.orders![index].order.status is! ActiveOrderStatus ? () {
                                        final status = state.orders![index].order.status;
                                        print(status);
                                        if(status is WaitingForOrderAcceptanceOrderStatus) {
                                          bloc.add(CancelSearchMapEvent(id: state.orders![index].id));
                                        } else if(status is OrderAcceptedOrderStatus) {
                                          bloc.add(GoMapEvent(CancelledOrderMapState(orderId: state.orders![index].id)));
                                        }
                                      } : null,
                                    ),
                                  );
                                }))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
