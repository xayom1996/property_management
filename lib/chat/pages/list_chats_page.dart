import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/chat/pages/search_chats_page.dart';
import 'package:property_management/chat/widgets/chat_object.dart';

class ListChatsPage extends StatelessWidget {
  const ListChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoxIcon(
              iconPath: 'assets/icons/back.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Text('Чат',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/search.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchChatsPage(
                    onTapObject: (String value) {

                    },
                  )),
                );
              },
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 68,
        backgroundColor: kBackgroundColor,
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44)),
              child: GestureDetector(
                  onTap: () {},
                  child: ChatObject()
              )
            );
          }
      ),
    );
  }

}