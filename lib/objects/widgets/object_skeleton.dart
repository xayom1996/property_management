import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ObjectSkeleton extends StatelessWidget {
  const ObjectSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xffEFF0F2),
      highlightColor: Color(0xffFAFAFA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: double.infinity,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  
}