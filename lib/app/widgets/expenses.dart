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
  const ExpensesContainer({Key? key, required this.title, required this.expenses, this.width, this.height, this.isLastElementBold = false}) : super(key: key);

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
        Container(
          height: height ?? 54,
          child: Row(
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
                          padding: EdgeInsets.symmetric(horizontal: title.contains('Комментарий') ? 8: 0),
                          decoration: BoxDecoration(
                              color: Color(0xffF5F5F5).withOpacity(0.6),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Center(
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
        ),
      ],
    );
  }

}