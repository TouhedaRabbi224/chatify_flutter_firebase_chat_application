import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String uid;
  final String currentUserId;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recepients;

  Chat({
    required this.uid,
    required this.currentUserId,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }) {
    _recepients = members.where((_i) => _i.uid != currentUserId).toList();
  }

  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients.map((_user) => _user.name).join(", ");
  }

  String imageUrl() {
    return !group
        ? _recepients.first.image
        : "https://pngimage.net/wp-content/uploads/2018/05/balao-em-png-2.png";
  }
}
