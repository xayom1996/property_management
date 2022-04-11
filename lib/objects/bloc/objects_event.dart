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

class ObjectsUpdateEvent extends ObjectsEvent {

  const ObjectsUpdateEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeFilterObjectsEvent extends ObjectsEvent {
  final String filterBy;

  const ChangeFilterObjectsEvent({required this.filterBy});
  @override
  List<Object?> get props => [filterBy];
}

class ChangeColorObjectEvent extends ObjectsEvent {
  final int id;
  final String value;

  const ChangeColorObjectEvent({required this.id, required this.value});
  @override
  List<Object?> get props => [id, value];
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
