import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/widgets/route_card_widget.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';
import 'package:trezvii_24_driver/presentation/utils/app_images_util.dart';
import 'package:trezvii_24_driver/presentation/utils/app_style_util.dart';

import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_elevated_button.dart';
import '../../bloc/bloc/bloc.dart';
import '../../bloc/state/state.dart';
import 'emergency_cancellation/emergency_cancellation_message.dart';

class ActiveOrderWidget extends StatelessWidget {
  const ActiveOrderWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Container(
      height: 260,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 40, right:  40),
        child: Column(
          children: [
            const Text('Поездка началась', style: AppStyle.black17,),
            const SizedBox(height: 10,),
            routeCardWidget(bloc.routeStream!, lastRoute: bloc.lastRoute, from: bloc.fromAddress, to: bloc.toAddress),
            Align(
                alignment: Alignment.bottomCenter,
                child: AppElevatedButton(
                    text: 'Экстренная отмена',
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => EmergencyCancellationMessage(
                          onAccept: () {
                            bloc.add(EmergencyCancelMapEvent());
                            context.pop();
                          },
                          onCancel: () {
                            context.pop();
                          },
                        ))))
          ],
        ),
      ),
    );
  }
}
