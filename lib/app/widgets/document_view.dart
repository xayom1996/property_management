import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentView extends StatelessWidget {
  final String documentUrl;
  final bool minimize;
  const DocumentView({Key? key, required this.documentUrl, this.minimize = false}) : super(key: key);

  Future<String> getUrl() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref(documentUrl)
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: ValueKey(documentUrl),
      future: getUrl(),
      builder: (BuildContext context, AsyncSnapshot<String> url) {
        if (url.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator()
            ),
          );
        }
        return PhotoView(
          imageProvider: NetworkImage(
            url.data ?? '',
          ),
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return url.data != null && url.data!.contains('.pdf')
                ? SfPdfViewer.network(url.data!)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/view_unavailable.svg',
                        height: 85,
                      ),
                      if (!minimize)
                        Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Просмотр недоступен',
                              style: body.copyWith(
                                color: Color(0xffC7C9CC),
                              ),
                            )
                          ],
                        ),
                    ],
                  );
          },
          loadingBuilder: (context, progress) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: progress == null
                    ? null
                    : progress.cumulativeBytesLoaded /
                    progress.expectedTotalBytes!,
              ),
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.white),
          gaplessPlayback: false,
          // customSize: MediaQuery.of(context).size,
          // scaleStateChangedCallback: this.onScaleStateChanged,
          enableRotation: true,
          // controller:  controller,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
          // scaleStateCycle: scaleStateCycle
        );
      },
    );
  }
}