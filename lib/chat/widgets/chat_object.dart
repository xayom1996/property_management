import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/styles.dart';

class ChatObject extends StatelessWidget {
  const ChatObject({Key? key}) : super(key: key);

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
                      'Иванов Алексей Викторович',
                      style: body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '(менеджер)',
                      style: body.copyWith(
                        color: Color(0xff5589F1)
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '11:04',
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
            'Здравствуйте! У меня возникли вопросы. asfh kjahsfkjh akjshfkj afhskj',
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