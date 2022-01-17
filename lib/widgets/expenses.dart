import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/exploitation/widgets/comment_bottom_sheet.dart';
import 'package:property_management/theme/styles.dart';

///Затраты
class ExpensesContainer extends StatelessWidget {
  final String title;
  final List<String> expenses;
  const ExpensesContainer({Key? key, required this.title, required this.expenses}) : super(key: key);

  double widthContainer(BuildContext context) {
    double horizontalPadding = 24;
    if (ScreenUtil().orientation == Orientation.landscape) {
      horizontalPadding = 44;
    }
    print((MediaQuery.of(context).size.width));
    print((MediaQuery.of(context).size.width - (expenses.length - 1) * 9 - horizontalPadding * 2) / 3);
    return (MediaQuery.of(context).size.width - (expenses.length - 1) * 9 - horizontalPadding * 2) / 3;
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
        Container(
          height: 54,
          child: Row(
            children: [
              for (var index = 0; index < expenses.length; index++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index != expenses.length - 1 ? 9 : 0),
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
                            expenses[index],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: body.copyWith(
                              color: Color(0xff151515),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

}