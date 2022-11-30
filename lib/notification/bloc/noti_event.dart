part of 'noti_bloc.dart';

@immutable
abstract class NotiEvent {}

class UpdateNotiStatusEvent extends NotiEvent {
  UpdateNotiStatusEvent({required this.notiID});

  final String notiID;
}

class ClearAllNotiEvent extends NotiEvent {
  ClearAllNotiEvent({required this.userID});

  final String userID;
}

class GetNotiEvent extends NotiEvent {
  GetNotiEvent({required this.userID});

  final String userID;
}
