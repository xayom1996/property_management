import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoxIcon extends StatelessWidget {
  const BoxIcon({Key? key, required this.backgroundColor, this.iconColor,
    required this.iconPath, this.gradient, this.gradientIcon, this.onTap, this.size, this.iconSize}) : super(key: key);

  final Color backgroundColor;
  final Color? iconColor;
  final String iconPath;
  final Gradient? gradient;
  final Gradient? gradientIcon;
  final Function()? onTap;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? 44,
        width: size ?? 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          color: backgroundColor,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              // spreadRadius: 5,
              blurRadius: 20,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: gradientIcon == null
              ? SvgPicture.asset(
                  iconPath,
                  color: iconColor,
                  height: iconSize ?? 17,
                )
              : ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradientIcon!.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    color: iconColor,
                    height: iconSize ?? 17,
                  )
                )
        ),
      ),
    );
  }

}