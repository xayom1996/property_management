import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/objects/pages/change_field_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';

class UploadDocumentPage extends StatelessWidget {
  UploadDocumentPage({Key? key}) : super(key: key);

  final TextEditingController textController = TextEditingController();

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
              'Загрузка документа',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/clear.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoxInputField(
                      controller: textController,
                      placeholder: 'site.com/doc.pdf',
                      title: 'Ссылка на документ',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw), vertical: 16),
              child: SizedBox(
                width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                child: BoxButton(
                  title: 'Загрузить',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}