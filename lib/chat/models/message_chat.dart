import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;
  bool read;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.read,
  });

  Map<String, dynamic> toJson() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
      'type': type,
      'read': read,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');
    String timestamp = doc.get('timestamp');
    String content = doc.get('content');
    int type = doc.get('type');
    bool read = doc.get('read');

    return MessageChat(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type,
        read: read,
    );
  }

  String getTime() {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return DateFormat('HH:mm').format(time);
  }

  String getDate() {
    List<String> months = [
      'января', 'февраля', 'марта',
      'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября',
      'октября', 'ноября', 'декабря'
    ];
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateTime now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return 'Сегодня';
    } else if (date.year != now.year) {
      return '${date.day} ${months[date.month - 1]} ${date.year} года';
    }
    return '${date.day} ${months[date.month - 1]}';
  }
}