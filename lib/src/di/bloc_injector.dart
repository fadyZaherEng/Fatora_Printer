
import 'package:fatora/src/di/data_layer_injector.dart';
import 'package:fatora/src/presentation/blocs/fatora/fatora_bloc.dart';

Future<void> initializeBlocDependencies() async {
   injector.registerFactory<FatoraBloc>(() => FatoraBloc());
 }
