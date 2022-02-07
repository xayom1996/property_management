import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_tenant_state.dart';

class AddTenantCubit extends Cubit<AddTenantState> {
  AddTenantCubit() : super(AddTenantInitial());
}
