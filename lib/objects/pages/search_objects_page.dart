import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/objects/widgets/object_card.dart';
import 'package:property_management/objects/widgets/object_skeleton.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';

class SearchObjectsPage extends StatefulWidget {
  const SearchObjectsPage({Key? key}) : super(key: key);

  @override
  State<SearchObjectsPage> createState() => _SearchObjectsPageState();
}

class _SearchObjectsPageState extends State<SearchObjectsPage> {
  bool isLoading = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          titleSpacing: 0,
          title: Container(
            padding: EdgeInsets.only(
                left: horizontalPadding(44),
                top: 16,
                bottom: 8,
                // right: 32,
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              autofocus: true,
              onTap: () {
              },
              onChanged: (text) {
                setState(() {
                  searchText = text;
                  isLoading = true;
                });
                Timer(const Duration(milliseconds: 300), () {
                  setState(() {
                    isLoading = false;
                  });
                });
              },
              style: TextStyle(
                color: Color(0xff151515),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF5F7F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15) //                 <--- border radius here
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(15) //                 <--- border radius here
                  ),
                ),
                // prefixIconConstraints: BoxConstraints(maxWidth: 32),
                hintText: 'Название, адрес, площадь',
                hintStyle: body.copyWith(
                  color: Color(0xff3C3C43).withOpacity(0.6),
                ),
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 18,
                    color: Color(0xff3C3C43).withOpacity(0.6),
                  ),
                  onPressed: () {  },
                ),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  right: horizontalPadding(44),
                  left: horizontalPadding(24, portraitPadding: 16),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Отмена',
                    style: body.copyWith(
                        color: Color(0xff5589F1)
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: searchText == ''
          ? CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/search.svg',
                  color: Color(0xffE9ECEE),
                  height: 72,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: horizontalPadding(44)),
                  child: Text(
                    'Ничего не найдено, попробуйте изменить запрос',
                    textAlign: TextAlign.center,
                    style: body.copyWith(
                      color: Color(0xffC7C9CC),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )
          : ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44)),
                    child: isLoading
                            ? ObjectSkeleton()
                            : ObjectCard(id: index),
                  );
                }
            ),
    );
  }
}