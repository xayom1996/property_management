import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/account/pages/account_page.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/settings/pages/characteristic_items_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  BoxIcon(
                    iconPath: 'assets/icons/download.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              expandedHeight: 68,
              toolbarHeight: 68,
              collapsedHeight: 68,
              pinned: true,
              backgroundColor: kBackgroundColor,
              flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.all(24),
                  title: Text('Документ',
                    style: body,
                  ),
                );
              })
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Image.asset(
                'assets/document.png',
                // fit: BoxFit.cover,
                width: ScreenUtil().orientation == Orientation.portrait
                    ? 1.sw
                    : 0.5.sw,
              ),
            ),
          ),
        ],
      ),
    );
  }

}