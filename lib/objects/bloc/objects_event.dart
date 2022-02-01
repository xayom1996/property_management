part of 'objects_bloc.dart';

abstract class ObjectsEvent extends Equatable {
  const ObjectsEvent();
}

class ObjectsGetEvent extends ObjectsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
