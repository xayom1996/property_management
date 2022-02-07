import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_tenant_state.dart';

class EditTenantCubit extends Cubit<EditTenantState> {
  EditTenantCubit() : super(EditTenantInitial());
}
