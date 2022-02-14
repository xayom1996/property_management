part of 'objects_bloc.dart';

abstract class ObjectsEvent extends Equatable {
  const ObjectsEvent();
}

class ObjectsGetEvent extends ObjectsEvent {
  final User user;
  final List<String> owners;

  ObjectsGetEvent({required this.user, required this.owners});

  @override
  // TODO: implement props
  List<Object?> get props => [user, owners];
}

class ChangeFilterObjectsEvent extends ObjectsEvent {
  final String filterBy;

  const ChangeFilterObjectsEvent({required this.filterBy});
  @override
  List<Object?> get props => [filterBy];
}

class GetFilteredObjectsEvent extends ObjectsEvent {
  final String filterBy;

  const GetFilteredObjectsEvent({required this.filterBy});
  @override
  List<Object?> get props => [filterBy];
}

class DeleteObjectEvent extends ObjectsEvent {
  final int? index;
  final String? docId;

  const DeleteObjectEvent({this.docId, this.index});

  @override
  List<Object?> get props => [docId];
}
