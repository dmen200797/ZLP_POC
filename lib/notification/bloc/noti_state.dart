part of 'noti_bloc.dart';

@immutable
abstract class NotiState {}

class NotiInitial extends NotiState {}

class LoadingState extends NotiState {}

class UpdateNotiStatusState extends NotiState {
  final bool isRead;

  UpdateNotiStatusState({required this.isRead});
}

class GotNotiState extends NotiState {
  final List<NotiObject> notiList;

  GotNotiState({required this.notiList});
}

class DeletedAllNotiState extends NotiState {}
