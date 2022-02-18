import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_icon.dart';

class ObjectCarouselCard extends StatelessWidget {
  final int id;
  final bool bordered;
  const ObjectCarouselCard({Key? key, required this.id, this.bordered = false}) : super(key: key);

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
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ЖК Акваленд, 3-к • 96 кв.м.',
              style: body,
              textAlign: TextAlign.center,
            ),
            Text(
              'г. Новосибирск, Ленинградский пр-т, 124',
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