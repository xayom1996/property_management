import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/document_view.dart';

class DocumentCard extends StatelessWidget {
  final String url;
  final Function() onDelete;
  final bool isLoading;
  const DocumentCard({Key? key, required this.url, required this.onDelete, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 138,
          height: 138,
        ),
        Positioned(
          top: 10,
          left: 0,
          child: Container(
            height: 128,
            width: 128,
            decoration: BoxDecoration(
              color: Color(0xffF5F7F9),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: isLoading == true
                  ? CircularProgressIndicator()
                  : url.isEmpty
                    ? SvgPicture.asset(
                        'assets/icons/document.svg',
                        color: Color(0xffE9ECEE),
                        height: 40,
                      )
                    : DocumentView(
                        key: UniqueKey(),
                        documentUrl: url,
                        minimize: true,
                      ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child:  GestureDetector(
            onTap: onDelete,
            child: BoxIcon(
              size: 24,
              iconSize: 12,
              iconPath: 'assets/icons/clear.svg',
              backgroundColor: Color(0xffE9ECEE),
              iconColor: Color(0xffC7C9CC),
            ),
          ),
        ),
      ],
    );
  }

}