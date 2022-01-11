import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/theme/styles.dart';
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
          SizedBox(
            width: 24,
          ),
          BoxIcon(
            iconPath: 'assets/icons/edit.svg',
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff6395F9),
                  Color(0xff0940CD),
                ]
            ),
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: 24,
          ),
          BoxIcon(
            iconPath: 'assets/icons/trash.svg',
            iconColor: Colors.black,
            backgroundColor: Colors.white,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog()
              );
            },
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
                          if (id % 2 == 0)
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20) //                 <--- border radius here
                                  ),
                                  color: Random().nextInt(100) % 2 == 0
                                      ? Color(0xffFF0000)
                                      : Color(0xff40CD0F),
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
                            'ЖК Акваленд, 3-к',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: body,
                          ),
                        ],
                      ),
                      Text('96 кв.м.', style: body,),
                    ],
                  ),
                  Text(
                    'г. Новосибирск, Ленинградский пр-т, 124',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: body.copyWith(color: Color(0xffC7C9CC)),
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}