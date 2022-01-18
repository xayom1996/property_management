import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/account/pages/account_page.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/settings/pages/characteristic_items_page.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/container_for_transition.dart';
import 'package:property_management/widgets/custom_alert_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // appBar: AppBar(
      //   centerTitle: false,
      //   leading: null,
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     // mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       BoxIcon(
      //         iconPath: 'assets/icons/back.svg',
      //         iconColor: Colors.black,
      //         backgroundColor: Colors.white,
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       Expanded(
      //         child: Align(
      //           alignment: Alignment.center,
      //           child: Text('Настройки',
      //             style: body,
      //           ),
      //         ),
      //       ),
      //       // Spacer(),
      //     ],
      //   ),
      //   elevation: 0,
      //   toolbarHeight: 68,
      //   backgroundColor: kBackgroundColor,
      // ),
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
                  title: Text('Настройки',
                    style: body,
                  ),
                );
              })
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44), vertical: 16),
              child: Column(
                children: [
                  ContainerForTransition(
                    title: 'Характеристики Объекта',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                          title: 'Характеристики Объекта',
                          items: objectItems,
                        )),
                      );
                    },
                  ),
                  ContainerForTransition(
                    title: 'Характеристики Арендатора',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                          title: 'Характеристики Арендатора',
                          items: tenantItems,
                        )),
                      );
                    },
                  ),
                  ContainerForTransition(
                    title: 'Эксплуатация Объекта',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                          title: 'Эксплуатация Объекта',
                          items: expensesItems,
                        )),
                      );
                    },
                  ),
                  ContainerForTransition(
                    title: 'Эксплуатационные статьи',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                          title: 'Эксплуатационные статьи',
                          items: expensesArticleItems,
                        )),
                      );
                    },
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