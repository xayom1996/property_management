import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/chat/models/chat.dart';

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
                    Text(
                      '(${chat.role})',
                      style: body.copyWith(
                        color: Color(0xff5589F1)
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                chat.lastMessage != null
                  ? chat.lastMessage!.getTime()
                  : '',
                style: body.copyWith(
                  color: Color(0xffC7C9CC)
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            chat.lastMessage == null
                ? 'Нет собщений'
                : chat.lastMessage!.content,
            style: body.copyWith(
                color: Color(0xffC7C9CC)
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 16,
          ),
          Divider(),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

}