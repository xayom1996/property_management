import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/models/message_chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required AppBloc appBloc})
      : _appBloc = appBloc,
        super(ChatState()) {
          getListChats();
          _appBlocSubscription = _appBloc.stream.listen(
                (state){
              if (state.status != AppStatus.loading) {
                getListChats();
              }
            });
        }

  late final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;

  void getListChats() async {
    emit(state.copyWith(
      status: ChatStateStatus.loading
    ));

    emit(state.copyWith(
      chats: await _appBloc.fireStoreService.getListChats(_appBloc.state.user),
      status: ChatStateStatus.success,
    ));
  }

  // UploadTask uploadFile(File image, String fileName) {
  //   Reference reference = firebaseStorage.ref().child(fileName);
  //   UploadTask uploadTask = reference.putFile(image);
  //   return uploadTask;
  // }
  //
  // Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
  //   return firebaseFirestore.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  // }

  void updateLastMessage(String chatId, MessageChat messageChat) {
    emit(state.copyWith(
        status: ChatStateStatus.loading
    ));

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == chatId);
    chats[index].lastMessage = messageChat;

    emit(state.copyWith(
      status: ChatStateStatus.success,
      chats: chats,
    ));
  }

  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    return _appBloc.fireStoreService.getChatStream(chatId, limit);
  }

  void sendMessage(String content, int type, String chatId, String currentUserId, String peerId) {
    _appBloc.fireStoreService.sendMessage(content, type, chatId, currentUserId, peerId);
  }
}
