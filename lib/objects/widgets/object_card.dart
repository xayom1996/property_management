import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/objects/models/place.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';

class ObjectCard extends StatelessWidget {
  final int id;
  final Place? place;
  const ObjectCard({Key? key, required this.id, this.place}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: Text(
                    place == null
                        ? objects[id]['name']
                        : place!.objectItems['Название объекта']!.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: body,
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  place == null
                      ? objects[id]['area']
                      : '${place!.objectItems['Площадь объекта']!.value} ${place!.objectItems['Площадь объекта']!.unit}',
                  style: body,
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              place == null
                  ? objects[id]['address']
                  : '${place!.objectItems['Адрес объекта']!.value}',
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
      ),
    );
  }

}