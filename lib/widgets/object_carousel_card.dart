import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_icon.dart';

class ObjectCarouselCard extends StatelessWidget {
  final int id;
  const ObjectCarouselCard({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 1.sw / 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            // spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ЖК Акваленд, 3-к $id',
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
    );
  }

}