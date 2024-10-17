import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fatora/src/data/sources/local/database_helper.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:meta/meta.dart';

part 'fatora_event.dart';

part 'fatora_state.dart';

class FatoraBloc extends Bloc<FatoraEvent, FatoraState> {
  FatoraBloc() : super(FatoraInitial()) {
    on<GetFatoraEvent>(_onGetFatoraEvent);
    on<AddFatoraEvent>(_onAddFatoraEvent);
  }

  FutureOr<void> _onGetFatoraEvent(
      GetFatoraEvent event, Emitter<FatoraState> emit) async {
    emit(GetFatoraLoading());

    DatabaseHelper dbHelper = DatabaseHelper();
    //open the database
    // Get all users
    List<Fatora> fatoraList = await dbHelper.getFatora();
    print('All Fatora: $fatoraList');
    emit(GetFatoraSuccess(fatoraList));
  }

  FutureOr<void> _onAddFatoraEvent(
      AddFatoraEvent event, Emitter<FatoraState> emit) async {
    emit(AddFatoraLoading());
    //sqflite using
    DatabaseHelper dbHelper = DatabaseHelper();

    // Insert a new fatora
    await dbHelper.insertFatora(event.fatora);
    emit(AddFatoraSuccess(event.fatora));
    add(GetFatoraEvent());
  }
}
