import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/objects/pages/change_field_page.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/input_field.dart';

class NewCharacteristicPage extends StatelessWidget {
  const NewCharacteristicPage({Key? key}) : super(key: key);

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
            Text(
              'Новая характеристика',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/check.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 68,
        backgroundColor: kBackgroundColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
              child: Column(
                children: [
                  for (var item in characteristicItems)
                    BoxInputField(
                      controller: TextEditingController(),
                      placeholder: item['placeholder'],
                      title: item['title'],
                      enabled: item['items'] == null,
                      onTap: item['items'] != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChangeFieldPage(
                                  title: item['title'],
                                  items: item['items'],
                                )),
                              );
                            }
                          : null,
                      trailing: item['items'] != null
                          ? Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xff5589F1),
                          )
                          : null,
                      // isError: isError,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}