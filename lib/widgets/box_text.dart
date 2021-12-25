import 'package:flutter/material.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';

class BoxText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const BoxText.headingOne(this.text) : style = heading1Style;
  BoxText.headingTwo(this.text) : style = title2;
  const BoxText.headingThree(this.text) : style = heading3Style;
  const BoxText.headline(this.text) : style = headlineStyle;
  const BoxText.subheading(this.text) : style = subheadingStyle;
  BoxText.caption(this.text, {Key? key}) : style = caption1, super(key: key);

  BoxText.body(this.text, {Color color = kcMediumGreyColor})
      : style = bodyStyle.copyWith(color: color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}