import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_text.dart';

class BoxInputField extends StatefulWidget {
  TextEditingController? controller;
  final Function(String)? onChanged;
  final String placeholder;
  final String title;
  final String? additionalInfo;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final bool isError;
  final String? errorText;
  final bool? enabled;
  final Color? backgroundColor;
  final bool? disableSpace;
  final void Function()?trailingTapped;
  final Function()? onTap;
  final Function()? onTapTextField;
  final Function(String value)? onSubmit;
  final bool autoFocus;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;


  BoxInputField({
    Key? key,
    required this.title,
    this.additionalInfo,
    this.controller,
    this.onChanged,
    this.placeholder = '',
    this.enabled = true,
    this.disableSpace = false,
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.password = false,
    this.isError = false,
    this.autoFocus = false,
    this.backgroundColor,
    this.keyboardType,
    this.errorText,
    this.onTap,
    this.onTapTextField,
    this.onSubmit,
    this.focusNode,
  }) : super(key: key);

  @override
  State<BoxInputField> createState() => _BoxInputFieldState();
}

class _BoxInputFieldState extends State<BoxInputField> {
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );
  bool isFocused = false;
  bool showPassword = false;
  FocusNode _focus = new FocusNode();
  TextEditingController? _controller;
  List<TextInputFormatter> inputFormatters = [];

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
    } else {
      _controller = null;
    }
    if (widget.disableSpace == true || widget.keyboardType == TextInputType.number
      || widget.keyboardType == TextInputType.numberWithOptions(decimal: true, signed: true)
      || widget.keyboardType == TextInputType.phone) {
      inputFormatters.add(FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")));
    }
    if (widget.keyboardType == TextInputType.numberWithOptions(decimal: true, signed: true)) {
      inputFormatters.add(DecimalTextInputFormatter());
      inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')));
    }
    if (widget.focusNode != null) {
      _focus = widget.focusNode!;
    }
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(minHeight: 50),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoxText.caption(widget.title),
                        widget.title == 'Отмеченный клиент' && widget.controller!.text.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30) //                 <--- border radius here
                                      ),
                                      // color: color,
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(22) //                 <--- border radius here
                                          ),
                                          color: Color(int.parse(widget.controller!.text)),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : TextField(
                          inputFormatters: inputFormatters,
                          onTap: widget.onTapTextField,
                          onSubmitted: widget.onSubmit,
                          keyboardType: widget.keyboardType != null
                              ? widget.keyboardType
                              : widget.enabled == true ? null : TextInputType.multiline,
                          maxLines: widget.enabled == true ? 1 : null,
                          enabled: widget.enabled,
                          controller: widget.controller,
                          onChanged: widget.onChanged,
                          style: body,
                          focusNode: _focus,
                          autofocus: widget.autoFocus,
                          obscureText: widget.password ? !showPassword : false,
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
                        if (isNotEmpty(widget.additionalInfo))
                          Text(
                            widget.additionalInfo!,
                            style: caption.copyWith(
                              color: Color(0xff151515),
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
                        Container(
                          child: widget.password
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  child: Icon(
                                    !showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Color(0xffA3A7AE),
                                  ),
                                )
                              : widget.trailing,
                        )
                      ],
                    )
                ],
              ),
            ),
            if (widget.isError && widget.errorText != null && widget.errorText != '')
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
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d*');
    final String newString = regEx.stringMatch(newValue.text) ?? '';
    return newString == newValue.text ? newValue : oldValue;
  }
}