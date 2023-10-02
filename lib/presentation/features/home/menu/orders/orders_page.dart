import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/bloc/state.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/orders/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/orders/bloc/state.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/ui/widgets/menu_app_bar.dart';
import 'package:trezvii_24_driver/presentation/utils/app_style_util.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_pop_button.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/full_order_card_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  return WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                menuAppBar(
                  padding: EdgeInsets.zero,
                    child: SafeArea(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppPopButton(context,
                              onTap: () => context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState())),
                              text: 'Заказы', color: Colors.white, textStyle: AppStyle.black16.copyWith(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 42,
                          width: size.width - 20,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50)),
                          child: TabBar(
                            indicatorWeight: 0,
                            indicatorSize: TabBarIndicatorSize.tab,
                              tabs: const [

                                Tab(
                                  text: 'Активные',
                                  height: 42,
                                ),
                                Tab(
                                  text: 'Завершённые',
                                  height: 42,
                                ),
                              ],
                              labelStyle: AppStyle.black16,
                              unselectedLabelColor: AppColor.textTabColor,
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: null,
                                color: Colors.white,
                              )),
                        ),
                      )
                  ],
                ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                    height: size.height - 250,
                    width: size.width,
                    child: TabBarView(
                      children: [

                        SizedBox(
                          height: size.height - 250,
                          width: size.width,
                          child:state.otherOrders.isEmpty ? Center(child: Text('Нет заказов', style: AppStyle.black22.copyWith(color: AppColor.firstColor),),) : ListView(
                            children: List.generate(
                                state.otherOrders.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: FullOrderCardWidget(
                                     order: state.otherOrders[index],),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: size.height - 250,
                          width: size.width,
                          child: state.completedOrders.isEmpty ? Center(child: Text('Нет заказов', style: AppStyle.black22.copyWith(color: AppColor.firstColor),),) : ListView(
                            children: List.generate(
                                state.completedOrders.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: FullOrderCardWidget(
                                      order:state.completedOrders[index],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
