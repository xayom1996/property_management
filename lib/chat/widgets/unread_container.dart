import 'package:flutter/material.dart';
import 'package:property_management/app/theme/styles.dart';

class UnreadContainer extends StatelessWidget {
  final int? count;
  final double? size;
  const UnreadContainer({Key? key, this.count, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 21,
      width: size ?? 21,
      decoration: BoxDecoration(
        color: Color(0xff5589F1),
        borderRadius: BorderRadius.all(Radius.circular(21)),
      ),
      child: Center(
        child: Text(
          count != null
              ? count.toString()
              : '',
          style: caption.copyWith(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
