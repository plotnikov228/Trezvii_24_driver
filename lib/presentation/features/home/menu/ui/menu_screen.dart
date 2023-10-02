import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trezvii_24_driver/presentation/features/home/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/ui/widgets/menu_chapter.dart';
import 'package:trezvii_24_driver/presentation/widgets/user_photo_with_border.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';
import 'package:trezvii_24_driver/presentation/utils/app_style_util.dart';
import 'package:trezvii_24_driver/presentation/utils/size_util.dart';

import '../../../../utils/app_images_util.dart';
import '../bloc/state.dart';
import 'widgets/menu_app_bar.dart';

class MenuScreen extends StatelessWidget {
  final MenuBloc bloc;
  final InitialMenuState state;

  const MenuScreen({Key? key, required this.bloc, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              menuAppBar(
                child: SafeArea(
                  child: SizedBox(
                    height: 110,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          userPhotoWithBorder(url: state.userUrl, size: 85),
                          SizedBox(
                            height: 100,
                            width: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.userModel?.name ?? '',
                                  style: AppStyle.black20
                                      .copyWith(color: Colors.white),
                                  overflow: TextOverflow.visible,
                                ),
                                Container(
                                  height: 36,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: 36,
                                    width: 90,
                                    child: Wrap(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.giftCard,
                                          color: AppColor.firstColor,
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${state.bonuses}',
                                          style: AppStyle.black17,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              AppImages.pencil,
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              bloc.add(GoToProfileMenuEvent(context));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: size.width - 60,
                  child: Wrap(
                    spacing: 30,
                    direction: Axis.vertical,
                    children: [
                      menuChapter(
                          width: size.width - 60,
                          title: 'Заказы',
                          prefixWidget: SvgPicture.asset(
                            AppImages.time,
                            width: 25,
                            height: 25,
                          ),
                          onTap: () => bloc
                              .add(GoMenuEvent(newState: OrdersMenuState()))),
                      menuChapter(
                          title: 'Баланс',
                          onTap: () => bloc
                              .add(GoMenuEvent(newState: BalanceMenuState())),
                          prefixWidget: SvgPicture.asset(
                            AppImages.wallet,
                            width: 30,
                            height: 30,
                            color: AppColor.firstColor,
                          )),
                      menuChapter(
                          width: size.width - 60,
                          title: 'Обратная связь',
                          onTap: () => bloc
                              .add(GoMenuEvent(newState: FeedbackMenuState())),
                          prefixWidget: SvgPicture.asset(AppImages.feedback,
                              width: 25,
                              height: 25,
                              color: AppColor.firstColor)),
                      menuChapter(
                          width: size.width - 60,
                          title: 'Настройки',
                          onTap: () => bloc
                              .add(GoMenuEvent(newState: SettingsMenuState())),
                          prefixWidget: Icon(
                            Icons.settings,
                            size: 25,
                            color: AppColor.firstColor,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                AppImages.logo,
                height: 60,
                width: 60,
              ),
            ))
      ],
    );
  }
}
