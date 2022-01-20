import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/objects/pages/search_objects_page.dart';
import 'package:property_management/theme/styles.dart';

class SearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      enabled: false,
      onTap: () {
      },
      onChanged: (text) {
      },
      style: TextStyle(
        color: Color(0xff151515),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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
        disabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Color(0xffe9ecf1)),
          borderRadius: BorderRadius.all(
              Radius.circular(15) //                 <--- border radius here
          ),
        ),
        // prefixIconConstraints: BoxConstraints(maxWidth: 32),
        hintText: 'Поиск',
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
    );
  }

}