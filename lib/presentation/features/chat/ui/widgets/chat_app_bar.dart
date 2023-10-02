import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/models/user_model.dart';
import 'package:trezvii_24_driver/presentation/features/chat/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_pop_button.dart';
import 'package:trezvii_24_driver/presentation/widgets/user_photo_widget.dart';

import '../../../../utils/size_util.dart';

class ChatAppBar extends StatelessWidget {
  final UserModel? userModel;
  final ChatBloc bloc;

  const ChatAppBar({super.key, required this.userModel, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            AppColor.firstColor,
            AppColor.firstColor,
            AppColor.firstColor,
            Colors.white12
          ])),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppPopButton(context, text: userModel?.name ?? 'Неизвестный пользователь', color: Colors.white),
            if (bloc.talkerPhotoUrl != null)
              SizedBox(
                  width: 85,height: 85,
                  child: Center(child: UserPhotoWidget(bloc.talkerPhotoUrl!)))
          ],
        ),
      ),
    );
  }
}
