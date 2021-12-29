import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_icon.dart';

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
            width: 24.w,
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
            width: 24.w,
          ),
          BoxIcon(
            iconPath: 'assets/icons/trash.svg',
            iconColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ],
      ),
      child: Container(
        // padding: EdgeInsets.all(16.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxIcon(
              iconPath: 'assets/icons/home_white.svg',
              gradientIcon: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffACF155),
                    Color(0xff39B354),
                  ]
              ),
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ЖК Акваленд, 3-к',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: body,
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