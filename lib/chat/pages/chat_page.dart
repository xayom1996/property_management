import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/characteristics/widgets/document_page.dart';
import 'package:property_management/chat/cubit/chat_cubit.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/models/message_chat.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  List<QueryDocumentSnapshot> listMessage = [];
  String fileUrl = '';
  bool loadingFile = false;

  void onSendMessage() {
    if (loadingFile == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        content: const Text('Дождитесь окончания загрузки файла...'),
        backgroundColor: Color(0xff5589F1),
        action: SnackBarAction(
          label: 'ok',
          textColor: Colors.white,
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ));
      return;
    }
    if (textEditingController.text.trim() != '' || fileUrl.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
          textEditingController.text, 0, widget.chat.chatId,
          context.read<AppBloc>().state.user.getFullName(),
          widget.chat.currentUserId, widget.chat.peerId,
          fileUrl
      );
    }
    textEditingController.clear();
    fileUrl = '';
    loadingFile = false;
    setState(() {});
  }

  void onRemoveFile() {
    fileUrl = '';
    setState(() {});
  }

  void onUploadFile () async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        loadingFile = true;
      });
      File selectedFile = File(result.files.first.path!);
      String fileName = result.files.first.name;
      setState(() {});

      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('messages/$fileName')
            .putFile(selectedFile);
        // String _documentUrl = await firebase_storage.FirebaseStorage.instance
        //     .ref('documents/$fileName')
        //     .getDownloadURL();
        setState(() {
          fileUrl = fileName;
        });
      } on firebase_core.FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Произошла ошибка'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: '',
            textColor: Colors.white,
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ));
        setState(() {
          fileUrl = '';
        });
      } finally {
        setState(() {
          loadingFile = false;
        });
      }

    } else {
      // User canceled the picker
      setState(() {
        loadingFile = false;
      });
    }
  }

  Future<bool> onBackPress() async {
    await context.read<ChatCubit>().changeChatId('');

    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          leading: null,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxIcon(
                iconPath: 'assets/icons/back.svg',
                iconColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: onBackPress
              ),
              // Spacer(),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.chat.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: body,
                  ),
                ),
              ),
              // Spacer(),
              Container(
                height: 44,
                width: 44,
              ),
            ],
          ),
          elevation: 0,
          toolbarHeight: 68,
          backgroundColor: kBackgroundColor,
        ),
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(context),
                  // Input content
                  buildInput(),
                ],
              ),

              // Loading
              // buildLoading()
            ],
          ),
          onWillPop: onBackPress,
        ),
      ),
    );
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              // width: 300,
              child: TextField(
                // textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                // autofocus: true,
                onTap: () {},
                controller: textEditingController,
                onChanged: (text) {
                  // changedSearchText(text);
                },
                maxLines: 5,
                minLines: 1,
                style: const TextStyle(
                  color: Color(0xff151515),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffF5F7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(60) //                 <--- border radius here
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                    borderRadius: BorderRadius.all(
                        Radius.circular(60) //                 <--- border radius here
                    ),
                  ),
                  // prefixIconConstraints: BoxConstraints(maxWidth: 32),
                  hintText: 'Напишите сообщение',
                  hintStyle: body.copyWith(
                    color: Color(0xffC7C9CC),
                  ),
                  // prefixIcon: SvgPicture.asset(
                  //   'assets/icons/message_file.svg',
                  //   // color: iconColor,
                  //   // height: 10,
                  //   // width: 10,
                  //   // fit: BoxFit.cover,
                  // ),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      size: 20,
                      color: Colors.black,
                    ),
                    onPressed: onUploadFile,
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          if (fileUrl.isNotEmpty || loadingFile)
            Stack(
              children: [
                SizedBox(
                  width: 46,
                  height: 56,
                ),
                Positioned(
                    top: 10,
                    left: 0,
                    child: !loadingFile
                        ? SvgPicture.asset(
                      'assets/icons/message_file.svg',
                      height: 40,
                    )
                        : CircularProgressIndicator()
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child:  GestureDetector(
                    onTap: onRemoveFile,
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
            ),
          // Button send message
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: BoxIcon(
              iconPath: 'assets/icons/forward.svg',
              iconColor: Colors.white,
              size: 56,
              backgroundColor: Color(0xff5589F1),
              onTap: onSendMessage,
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                textInputAction: TextInputAction.done,
                // keyboardType: TextInputType.multiline,
                // autofocus: true,
                onTap: () {},
                controller: textEditingController,
                onChanged: (text) {
                  // changedSearchText(text);
                },
                maxLines: 5,
                minLines: 1,
                style: const TextStyle(
                  color: Color(0xff151515),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffF5F7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(60) //                 <--- border radius here
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                    borderRadius: BorderRadius.all(
                        Radius.circular(60) //                 <--- border radius here
                    ),
                  ),
                  // prefixIconConstraints: BoxConstraints(maxWidth: 32),
                  hintText: 'Напишите сообщение',
                  hintStyle: body.copyWith(
                    color: Color(0xffC7C9CC),
                  ),
                  // prefixIcon: SvgPicture.asset(
                  //   'assets/icons/message_file.svg',
                  //   // color: iconColor,
                  //   // height: 10,
                  //   // width: 10,
                  //   // fit: BoxFit.cover,
                  // ),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      size: 20,
                      color: Colors.black,
                    ),
                    onPressed: onUploadFile,
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),

          if (fileUrl.isNotEmpty || loadingFile)
            Stack(
              children: [
                SizedBox(
                  width: 46,
                  height: 56,
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  child: !loadingFile
                      ? SvgPicture.asset(
                          'assets/icons/message_file.svg',
                          height: 40,
                        )
                      : CircularProgressIndicator()
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child:  GestureDetector(
                    onTap: onRemoveFile,
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
            ),
          // Button send message
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: BoxIcon(
              iconPath: 'assets/icons/forward.svg',
              iconColor: Colors.white,
              size: 56,
              backgroundColor: Color(0xff5589F1),
              onTap: onSendMessage,
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 70,
      // decoration: BoxDecoration(
      //     border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage(BuildContext context) {
    return Flexible(
      child: 1 == 1
          ? StreamBuilder<QuerySnapshot>(
              stream: context.read<ChatCubit>().getChatStream(widget.chat.chatId, 10),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    MessageChat lastMessage = MessageChat.fromDocument(listMessage.first);
                    context.read<ChatCubit>().updateLastMessage(widget.chat.chatId, lastMessage);
                    if (lastMessage.idFrom != context.read<AppBloc>().state.user.id) {
                      context.read<ChatCubit>().readMessages(widget.chat.chatId);
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        bool hasDate = true;
                        MessageChat message = MessageChat.fromDocument(listMessage[index]);
                        if (index < listMessage.length - 1) {
                          MessageChat nextMessage = MessageChat.fromDocument(listMessage[index + 1]);
                          hasDate = message.getDate() != nextMessage.getDate();
                        }
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.5),
                            child: buildItem(index, message, hasDate)
                        );
                      },
                      itemCount: listMessage.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(child: Text("Нет сообщений..."));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildItem(int index, MessageChat messageChat, bool hasDate) {
    // if (document == null) {
    //   return SizedBox.shrink();
    // }

    // MessageChat messageChat = MessageChat.fromDocument(document);
    Alignment alignment;
    if (messageChat.idFrom == widget.chat.currentUserId) {
      alignment = Alignment.centerRight;
    } else {
      alignment = Alignment.centerLeft;
    }

    return GestureDetector(
      onTap: () {
        if (messageChat.type == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                DocumentPage(
                  documentUrl: 'messages/${messageChat.content}',
                )),
          );
        }
      },
      child: Column(
        children: [
          if (hasDate)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.5),
                child: Text(
                  messageChat.getDate(),
                  style: caption1,
                ),
              ),
            ),
          Align(
            alignment: alignment,
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
                minWidth: 60,
              ),
              decoration: BoxDecoration(
                color: alignment == Alignment.centerLeft
                    ? Color(0xff5589F1)
                    : Color(0xffF5F7F9),
                borderRadius: BorderRadius.all(
                    Radius.circular(16) //                 <--- border radius here
                ),
              ),
              child: Stack(
                children: [
                  if (messageChat.type == 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (messageChat.type == 1)
                          SvgPicture.asset(
                            'assets/icons/message_file.svg',
                            height: 30,
                            color: alignment == Alignment.centerLeft
                                ? Color(0xffFCFCFC)
                                : Colors.black,
                          ),
                        if (messageChat.type == 1)
                          SizedBox(
                            width: 10,
                          ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65 - 80,
                            minWidth: 60,
                          ),
                          child: Text(
                            '${messageChat.content}\n',
                            style: body.copyWith(
                              color: alignment == Alignment.centerLeft
                                  ? Color(0xffFCFCFC)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (messageChat.type == 0)
                    Text(
                      '${messageChat.content}\n',
                      style: body.copyWith(
                        color: alignment == Alignment.centerLeft
                            ? Color(0xffFCFCFC)
                            : Colors.black,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      messageChat.getTime(),
                      style: caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildItem(Alignment alignment) {
  //   return Stack(
  //     children: [
  //       Align(
  //         alignment: alignment,
  //         child: Container(
  //           padding: EdgeInsets.all(16),
  //           constraints: BoxConstraints(
  //             maxWidth: MediaQuery.of(context).size.width * 0.65
  //           ),
  //           decoration: BoxDecoration(
  //             color: alignment == Alignment.centerLeft
  //                 ? Color(0xff5589F1)
  //                 : Color(0xffF5F7F9),
  //             borderRadius: BorderRadius.all(
  //                 Radius.circular(16) //                 <--- border radius here
  //             ),
  //           ),
  //           child: Stack(
  //             children: [
  //               Text(
  //                 'Здравствуйте! У меня возникли вопросы.\n',
  //                 style: body.copyWith(
  //                   color: alignment == Alignment.centerLeft
  //                       ? Color(0xffFCFCFC)
  //                       : Colors.black,
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 0,
  //                 right: 0,
  //                 child: Text(
  //                   '11:45',
  //                   style: caption,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
