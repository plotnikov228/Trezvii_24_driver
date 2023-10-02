import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/models/chat_messages.dart';
import 'package:trezvii_24_driver/extensions/date_time_extension.dart';
import 'package:trezvii_24_driver/presentation/app.dart';
import 'package:trezvii_24_driver/presentation/features/chat/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/chat/ui/widgets/tringular_clipper.dart';
import 'package:trezvii_24_driver/presentation/utils/app_color_util.dart';

import '../../../../utils/app_style_util.dart';

class MessageItem extends StatelessWidget {
  final List<ChatMessages> messages;
  final int index;
  final ChatBloc bloc;

  MessageItem({
    super.key,
    required this.messages,
    required this.index,
    required this.bloc,
  });


  final leftClipper = TringularClipper(false);
  final rightClipper = TringularClipper(true);

  @override
  Widget build(BuildContext context) {
    bool showTriangle = index == 0 && messages.asMap().containsKey(index + 1) && messages[index].idFrom == messages[index + 1].idFrom;
    bool isCurrentUser = messages[index].idFrom == bloc.yourId;
    return Column(
      children: [
        if (messages.asMap().containsKey(index - 1) &&
            DateTime.parse(messages[index - 1].timestamp)
                    .difference(DateTime.parse(messages[index].timestamp))
                    .inHours >
                4)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                DateTime.parse(messages[index].timestamp)
                    .formatDateTimeForMessageItem(),
                style: AppStyle.hintText16.copyWith(fontSize: 13),
              ),
            ),
          ),
        Padding(
          // add some padding
          padding: EdgeInsets.fromLTRB(
            isCurrentUser ? 64.0 : 16.0,
            4,
            isCurrentUser ? 16.0 : 64.0,
            4,
          ),
          child: Align(
            // align the child within the container
            alignment:
                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              children: [
                Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: DecoratedBox(
                    // chat bubble decoration
                    decoration: BoxDecoration(
                        color: isCurrentUser
                            ? AppColor.firstColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isCurrentUser || !showTriangle? 16 : 0),
                          bottomRight: Radius.circular(isCurrentUser && showTriangle ? 0 : 16),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        messages[index].content,
                        style: AppStyle.black17.copyWith(
                            color:
                                isCurrentUser ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                ),
                if(showTriangle)
                Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Positioned(
                    right: 0,
                    bottom: -10,
                    child: ClipPath(
                      clipper: !isCurrentUser ? leftClipper : rightClipper,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: isCurrentUser
                            ? AppColor.firstColor
                            : Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
