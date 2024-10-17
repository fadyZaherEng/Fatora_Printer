part of 'fatora_bloc.dart';

@immutable
sealed class FatoraState {}

final class FatoraInitial extends FatoraState {}

final class GetFatoraLoading extends FatoraState {}

final class GetFatoraSuccess extends FatoraState {
  final List<Fatora> fatoras;
  GetFatoraSuccess(this.fatoras);
}

final class GetFatoraError extends FatoraState {
  final String message;
  GetFatoraError(this.message);
}

final class AddFatoraLoading extends FatoraState {}

final class AddFatoraSuccess extends FatoraState {
  final Fatora fatora;
  AddFatoraSuccess(this.fatora);
}

final class AddFatoraError extends FatoraState {
  final String message;
  AddFatoraError(this.message);
}
