import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/widgets/unread_container.dart';

class ChatObject extends StatelessWidget {
  final Chat chat;
  const ChatObject({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    Text(
                      '(${chat.role})',
                      style: body.copyWith(
                        color: Color(0xff5589F1)
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      chat.lastMessage == null
                          ? 'Нет собщений'
                          : chat.lastMessage!.type == 0
                          ? chat.lastMessage!.content
                          : 'Файл',
                      style: body.copyWith(
                          color: Color(0xffC7C9CC)
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat.getDate(),
                    style: body.copyWith(
                      color: Color(0xffC7C9CC)
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (chat.unreadMessages != 0)
                    UnreadContainer(count: chat.unreadMessages),
                ],
              ),
            ],
          ),
          // SizedBox(
          //   height: 8,
          // ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       chat.lastMessage == null
          //           ? 'Нет собщений'
          //           : chat.lastMessage!.type == 0
          //             ? chat.lastMessage!.content
          //             : 'Файл',
          //       style: body.copyWith(
          //           color: Color(0xffC7C9CC)
          //       ),
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //     if (chat.unreadMessages != 0)
          //       UnreadContainer(count: chat.unreadMessages),
          //   ],
          // ),
          // SizedBox(
          //   height: 12,
          // ),
          Divider(),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

}