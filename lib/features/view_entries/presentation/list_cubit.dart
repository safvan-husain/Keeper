import 'package:bloc/bloc.dart';
import 'package:keeper/features/write/domain/repository.dart';
import 'package:meta/meta.dart';

import '../../write/domain/entity/journal.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  final WriteRepository repository;

  ListCubit(this.repository) : super(ListState([])) {
    repository.subscribe().listen((data) {
      print("new data on list");
      emit(ListState(data));
    });
  }
}
