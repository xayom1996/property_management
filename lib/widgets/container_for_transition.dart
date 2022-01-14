import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/styles.dart';

class ContainerForTransition extends StatelessWidget {
  final String title;
  final Function() onTap;

  const ContainerForTransition({Key? key, required this.title,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF5F7F9),
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: body,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xff5589F1),
              ),
            ],
          ),
        ),
      ),
    );
  }

}