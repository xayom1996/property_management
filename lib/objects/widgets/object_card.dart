import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/models/place.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:provider/src/provider.dart';

class ObjectCard extends StatelessWidget {
  final int id;
  final Place? place;
  final bool? isLast;
  const ObjectCard({Key? key, required this.id, this.place, this.isLast = false}) : super(key: key);

  void doNothing(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(place!.objectItems['Название объекта']!.value),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          Spacer(),
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
                    MaterialPageRoute(builder: (context) => EditObjectPage(docId: place!.id,)),
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
                        onApprove: () {
                          context.read<ObjectsBloc>().add(DeleteObjectEvent(docId: place!.id));
                        }
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
      enabled: context.read<AppBloc>().state.user.isAdminOrManager(),
      child: Container(
        // padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (place!.tenantItems != null && place!.tenantItems!['Отмеченный клиент']!.getFullValue().isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(20) //                 <--- border radius here
                        ),
                        color: Color(int.parse(place!.tenantItems!['Отмеченный клиент']!.value!)),
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
                      : place!.objectItems['Площадь объекта']!.getFullValue(),
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
            if (isLast != true)
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