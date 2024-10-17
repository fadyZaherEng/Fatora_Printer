part of 'fatora_bloc.dart';

@immutable
sealed class FatoraEvent {}

class GetFatoraEvent extends FatoraEvent {}

class AddFatoraEvent extends FatoraEvent {
  final Fatora fatora;
  AddFatoraEvent({required this.fatora});
}
