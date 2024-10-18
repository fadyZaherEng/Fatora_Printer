import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/data/sources/local/database_helper.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/blocs/fatora/fatora_bloc.dart';
import 'package:fatora/src/presentation/screens/history/skeleton/history_skeleton.dart';
import 'package:fatora/src/presentation/screens/history/widgets/fatora_tables_widget.dart';
import 'package:fatora/src/presentation/screens/main/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends BaseStatefulWidget {
  const HistoryScreen({super.key});

  @override
  BaseState<HistoryScreen> baseCreateState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseState<HistoryScreen> {
  List<Fatora> fatoraList = [];
  Map<String, List<Fatora>>? groupedFatoraList;

  FatoraBloc get _bloc => BlocProvider.of<FatoraBloc>(context);

  @override
  void initState() {
    _bloc.add(GetFatoraEvent());
    super.initState();
  }

  // Grouping Fatora list by day of the week
  Future<Map<String, List<Fatora>>> groupFatoraByDay(
      List<Fatora> fatoraList) async {
    Map<String, List<Fatora>> groupedByDay = {};

    for (var fatora in fatoraList) {
      try {
        String dayName = DateFormat('EEEE').format(fatora.date == ""
            ? DateTime.now()
            : DateTime.parse(fatora.date)); // Get day name
        if (groupedByDay[dayName] == null) {
          groupedByDay[dayName] = [];
        }
        groupedByDay[dayName]!.add(fatora);
      } catch (e) {
        print(e);
      }
    }
    return groupedByDay;
  }

  @override
  Widget baseBuild(BuildContext context) {
    return BlocConsumer<FatoraBloc, FatoraState>(
        listener: (context, state) async {
      if (state is GetFatoraSuccess) {
        fatoraList = state.fatoras;
        print("fatoraList: $fatoraList");
        groupedFatoraList = await groupFatoraByDay(fatoraList);
      } else if (state is GetFatoraError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is GetFatoraLoading) {
        return const HistorySkeleton();
      }
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: groupedFatoraList != null && groupedFatoraList!.isEmpty
                ? const Center(
                    child: Text("لا يوجد فواتير",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "سجل الفواتير",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FatoraTablesWidget(
                            groupedFatora: groupedFatoraList ?? {},
                            onTapView: (fatora) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                      selectIndex: 1,
                                      fatora: fatora,
                                    ),
                                  ));
                            },
                            onTapDelete: (fatora) async {
                              await DatabaseHelper().deleteFatora(fatora.id);
                              _bloc.add(GetFatoraEvent());
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
