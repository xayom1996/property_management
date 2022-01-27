import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_button.dart';

class SuccessfullPage extends StatelessWidget {
  final Widget information;
  const SuccessfullPage({Key? key, required this.information}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 44,
                  horizontal: horizontalPadding(context, 0.24.sw),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    SvgPicture.asset(
                      'assets/icons/success_rounded.svg',
                      height: 68,
                    ),
                    SizedBox(
                      height: 64,
                    ),
                    Text(
                      'Успешно!',
                      style: title2,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    information,
                    Spacer(),
                    BoxButton(
                      title: 'Понятно',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}