import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/objects/pages/change_field_page.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';

class CreateObjectPage extends StatelessWidget {
  CreateObjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        // automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Новый объект',
              style: body,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BoxIcon(
                iconPath: 'assets/icons/clear.svg',
                iconColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in objectItems)
                    BoxInputField(
                      controller: TextEditingController(),
                      placeholder: item['placeholder'],
                      title: item['title'],
                      enabled: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangeFieldPage(
                            title: item['title'],
                            item: item,
                          )),
                        );
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xff5589F1),
                      ),
                      // isError: isError,
                    ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw), vertical: 16),
              child: SizedBox(
                width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                child: BoxButton(
                  title: 'Создать',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}