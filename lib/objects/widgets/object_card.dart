import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/custom_alert_dialog.dart';

class ObjectCard extends StatelessWidget {
  final int id;
  const ObjectCard({Key? key, required this.id}) : super(key: key);

  void doNothing(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(id),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          Spacer(),
          // SizedBox(
          //   width: 50,
          // ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: BoxIcon(
                iconPath: 'assets/icons/edit.svg',
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff6395F9),
                      Color(0xff0940CD),
                    ]
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditObjectPage()),
                  );
                },
                backgroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 24,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: BoxIcon(
                iconPath: 'assets/icons/trash.svg',
                iconColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        title: 'Вы действительно хотите удалить карточку объекта?',
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
      child: Container(
        // padding: EdgeInsets.all(16.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (objects[id]['color'] != null)
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20) //                 <--- border radius here
                                  ),
                                  color: Color(objects[id]['color']),
                                ),
                                child: Center(
                                  child: Text(
                                    '!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            objects[id]['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: body,
                          ),
                        ],
                      ),
                      Text(objects[id]['area'], style: body,),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    objects[id]['address'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: body.copyWith(color: Color(0xffC7C9CC)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}