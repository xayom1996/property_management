import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/objects/models/place.dart';

class ObjectCarouselCard extends StatelessWidget {
  final Place place;
  final bool bordered;
  const ObjectCarouselCard({Key? key, this.bordered = false, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        height: 75,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(22)),
          border: bordered
              ? Border.all(color: Color(0xff5589F1), width: 0.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    '${place.objectItems[0].value}',
                    style: body,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '•',
                  style: body,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Text(
                    '${place.objectItems[2].getFullValue()}',
                    overflow: TextOverflow.ellipsis,
                    style: body,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Text(
              '${place.objectItems[1].value}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: caption1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}