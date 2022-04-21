import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/exploitation/widgets/comment_bottom_sheet.dart';
import 'package:property_management/app/theme/styles.dart';

///Затраты
class ExpensesContainer extends StatelessWidget {
  final String title;
  final List<dynamic> expenses;
  final double? width;
  final double? height;
  final bool isLastElementBold;
  final List<bool>? hasTenantName;
  const ExpensesContainer({Key? key, required this.title, required this.expenses, this.width, this.height, this.isLastElementBold = false, this.hasTenantName}) : super(key: key);

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: caption1.copyWith(
            color: Color(0xffA3A7AE)
          ),
        ),
        SizedBox(
          height: 11,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var index = 0; index < expenses.length; index++)
              Expanded(
                flex: width != null ? 0 : 1,
                child: Container(
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: GestureDetector(
                      onTap: () {
                        if (title.contains('Комментарий'))
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return CommentBottomSheet(
                                  comment: expenses[index],
                                );
                              }
                          );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: title.contains('Комментарий') ? 8: 0, vertical: 6),
                        decoration: BoxDecoration(
                            color:  hasTenantName == null || !hasTenantName![index]
                                ? Color(0xffF5F5F5).withOpacity(0.6)
                                : Color(0xff5589F1).withOpacity(0.15),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            expenses[index] == '' || expenses[index] == '0'
                                ? ''
                                : expenses[index],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: body.copyWith(
                              color: Color(0xff151515),
                              fontSize: 15,
                              fontWeight: index == expenses.length - 1 && isLastElementBold
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // if (width == null)
            //   for (var index = 0; index < 3 - expenses.length; index++)
            //     Expanded(
            //       child: Padding(
            //           padding: const EdgeInsets.only(right: 9),
            //           child: Container()
            //       ),
            //     ),
          ],
        ),
      ],
    );
  }

}