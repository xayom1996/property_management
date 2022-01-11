import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_text.dart';

class BoxInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final String title;
  final Widget? leading;
  final Widget? trailing;
  bool password;
  final bool isError;
  final String? errorText;
  final bool? enabled;
  final Color? backgroundColor;
  final void Function()? trailingTapped;


  BoxInputField({
    Key? key,
    required this.controller,
    required this.title,
    this.placeholder = '',
    this.enabled = true,
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.password = false,
    this.isError = false,
    this.backgroundColor,
    this.errorText,
  }) : super(key: key);

  @override
  State<BoxInputField> createState() => _BoxInputFieldState();
}

class _BoxInputFieldState extends State<BoxInputField> {
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );
  bool isFocused = false;
  final FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange(){
    setState(() {
      isFocused = _focus.hasFocus;
    });

    debugPrint("Focus: "+_focus.hasFocus.toString());
  }

  Color getBackgroundColor() {
    return isFocused || widget.isError
        ? Colors.white
        : kcVeryLightGreyColor;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: widget.backgroundColor ?? getBackgroundColor(),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: widget.isError
                    ? Border.all(color: Color.fromRGBO(255, 77, 109, 1))
                    : isFocused
                      ? Border.all(color: Color.fromRGBO(233, 236, 238, 1))
                      : null
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoxText.caption(widget.title),
                      TextField(
                        enabled: widget.enabled,
                        controller: widget.controller,
                        style: body,
                        focusNode: _focus,
                        obscureText: widget.password,
                        decoration: InputDecoration(
                          hintText: widget.placeholder,
                          hintStyle: body.copyWith(
                              color: kcLightGreyColor
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          prefixIcon: widget.leading,
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                // if (isFocused || widget.controller.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        child: widget.trailing,
                      )
                    ],
                  )
              ],
            ),
          ),
          if (widget.errorText != null && widget.errorText != '')
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                  widget.errorText!,
                  style: caption1.copyWith(
                      color: const Color.fromRGBO(255, 77, 109, 1)
                  )
              ),
            )
        ],
      ),
    );
  }
}