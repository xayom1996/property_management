import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/document_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DocumentPage extends StatelessWidget {
  final String documentUrl;
  const DocumentPage({Key? key, required this.documentUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoxIcon(
              iconPath: 'assets/icons/back.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Text('Документ',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/download.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () async {
                String url = await firebase_storage.FirebaseStorage.instance
                    .ref(documentUrl)
                    .getDownloadURL();
                await launch(url);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DocumentView(
            documentUrl: documentUrl,
          ),
        ),
      ),
    );
  }
}