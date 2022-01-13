import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';

class CustomTabContainer extends StatelessWidget {
  final String firstTab;
  final String secondTab;
  final int currentIndex;
  final Function(int) onChange;
  const CustomTabContainer({Key? key, required this.firstTab, required this.secondTab,
    this.currentIndex = 0, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 325,
          // height: 32.h,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Color(0xffF5F7F9),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  onChange(0);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: 160,
                  decoration: BoxDecoration(
                    color: currentIndex == 0 ? Color(0xffFFFFFF) : null,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 20,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    firstTab,
                    textAlign: TextAlign.center,
                    style: body,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  onChange(1);
                },
                child: Container(
                  width: 160,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentIndex == 1 ? Color(0xffFFFFFF) : null,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 20,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    secondTab,
                    textAlign: TextAlign.center,
                    style: body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}