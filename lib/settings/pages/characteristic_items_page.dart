import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/settings/pages/edit_characteristic_page.dart';
import 'package:property_management/settings/pages/new_characteristic_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/input_field.dart';

class CharacteristicItemsPage extends StatefulWidget {
  final String title;
  final List<Map> items;
  const CharacteristicItemsPage({Key? key, required this.title, required this.items}) : super(key: key);

  @override
  State<CharacteristicItemsPage> createState() => _CharacteristicItemsPageState();
}

class _CharacteristicItemsPageState extends State<CharacteristicItemsPage> {
  List<Map> items = [];

  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

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
                  widget.title,
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
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: BoxIcon(
                                iconPath: items[i]['visible'] == false
                                    ? 'assets/icons/eye_invisible.svg'
                                    : 'assets/icons/eye_visible.svg',
                                iconColor: Colors.black,
                                backgroundColor: Colors.white,
                                // iconSize: items[i]['visible'] == false
                                //   ? 17
                                //   : 17.5,
                                onTap: () {
                                  setState(() {
                                    if (items[i]['visible'] == null) {
                                      items[i]['visible'] = false;
                                    } else {
                                      items[i]['visible'] = !items[i]['visible'];
                                    }
                                  });
                                  print(items[i]['visible']);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: BoxIcon(
                                iconPath: 'assets/icons/trash.svg',
                                iconColor: Colors.black,
                                backgroundColor: Colors.white,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomAlertDialog(
                                        title: 'Вы действительно хотите удалить характеристику?',
                                      )
                                  );
                                },

                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      child: ContainerForTransition(
                        title: widget.items[i]['title'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditCharacteristicPage(
                              title: widget.items[i]['title'],
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