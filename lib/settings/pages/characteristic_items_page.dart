import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/settings/pages/edit_characteristic_page.dart';
import 'package:property_management/settings/pages/new_characteristic_page.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/container_for_transition.dart';
import 'package:property_management/widgets/custom_alert_dialog.dart';
import 'package:property_management/widgets/input_field.dart';

class CharacteristicItemsPage extends StatelessWidget {
  final String title;
  final List<Map> items;
  const CharacteristicItemsPage({Key? key, required this.title, required this.items}) : super(key: key);

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
            Column(
              children: [
                Text(
                  'Настройки',
                  style: body,
                ),
                Text(
                  title,
                  style: caption,
                ),
              ],
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/plus.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewCharacteristicPage()),
                );
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
                  for (var i = 0; i < items.length; i++)
                    Slidable(
                      key: ValueKey(i),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          Spacer(),
                          BoxIcon(
                            iconPath: 'assets/icons/eye.svg',
                            iconColor: Colors.black,
                            backgroundColor: Colors.white,
                            onTap: () {
                            },
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          BoxIcon(
                            iconPath: 'assets/icons/trash.svg',
                            iconColor: Colors.black,
                            backgroundColor: Colors.white,
                            onTap: () {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) => CustomAlertDialog()
                              // );
                            },
                          ),
                        ],
                      ),
                      child: ContainerForTransition(
                        title: items[i]['title'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditCharacteristicPage(
                              title: items[i]['title'],
                            )),
                          );
                        },
                      ),
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