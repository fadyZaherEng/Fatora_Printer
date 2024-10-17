import 'package:fatora/src/config/routes/routes_manager.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/screens/history/skeleton/history_skeleton.dart';
import 'package:fatora/src/presentation/screens/history/widgets/fatora_tables_widget.dart';
import 'package:fatora/src/presentation/screens/main/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends BaseStatefulWidget {
  const HistoryScreen({super.key});

  @override
  BaseState<HistoryScreen> baseCreateState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseState<HistoryScreen> {
  List<Fatora> fatoraList = [];
  Map<String, List<Fatora>>? groupedFatoraList;

  @override
  void initState() {
    super.initState();
    //add dummy data
    fatoraList = [
      Fatora(
        date: DateTime.now().toString(),
        statusSuccess: ' hhhhhhhhhhمؤكد',
        paymentMethod: 'نقداjjjjjjjjjjjjj',
        traderNumber: '123456',
        fatoraId: '1234567891234567',
        name: 'Fady Zahejjjjjjjjjjjjjr',
        numberArrived: '123456',
        numberMove: '123456',
        price: 'IQD 12,12,1555555555',
        status: 'Deliverejjjjjjjd',
        time: '12:00',
        deviceNumber: '123456',
      ),
      Fatora(
        date: DateTime.now().toString(),
        statusSuccess: 'مؤكد',
        paymentMethod: 'نقدا',
        traderNumber: '123456',
        fatoraId: '1234567891234567',
        name: 'Fady Zaher',
        numberArrived: '123456',
        numberMove: '123456',
        price: 'IQD 12,12,15',
        status: 'Delivered',
        time: '12:00',
        deviceNumber: '123456',
      ),
      Fatora(
        date: DateTime.now().toString(),
        statusSuccess: 'مؤكد',
        paymentMethod: 'نقدا',
        traderNumber: '123456',
        fatoraId: '1234567891234567',
        name: 'Fady Zaher',
        numberArrived: '123456',
        numberMove: '123456',
        price: 'IQD 12,12,15',
        status: 'Delivered',
        time: '12:00',
        deviceNumber: '123456',
      ),
      Fatora(
        date: DateTime.now().toString(),
        statusSuccess: 'مؤكد',
        paymentMethod: 'نقدا',
        traderNumber: '123456',
        fatoraId: '1234567891234567',
        name: 'Fady Zaher',
        numberArrived: '123456',
        numberMove: '123456',
        price: 'IQD 12,12,15',
        status: 'Delivered',
        time: '12:00',
        deviceNumber: '123456',
      ),
      Fatora(
        date: DateTime.now().add(const Duration(days: 3)).toString(),
        statusSuccess: 'مؤكد',
        paymentMethod: 'نقدا',
        traderNumber: '123456',
        fatoraId: '1234567891234567',
        name: 'Fady Zaher',
        numberArrived: '123456',
        numberMove: '123456',
        price: 'IQD 12,12,15',
        status: 'Delivered',
        time: '12:00',
        deviceNumber: '123456',
      ),
      Fatora(
        date: DateTime.now().add(const Duration(days: 1)).toString(),
        statusSuccess: 'مؤكد',
        paymentMethod: 'نقدا',
        traderNumber: '123456',
        fatoraId: '1234567891234567',
        name: 'Fady Zaher',
        numberArrived: '123456',
        numberMove: '123456',
        price: 'IQD 12,12,15',
        status: 'Delivered',
        time: '12:00',
        deviceNumber: '123456',
      ),
    ];
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    groupedFatoraList = await groupFatoraByDay(fatoraList);
    setState(() {});
  }

  // Grouping Fatora list by day of the week
  Future<Map<String, List<Fatora>>> groupFatoraByDay(
      List<Fatora> fatoraList) async {
    Map<String, List<Fatora>> groupedByDay = {};

    for (var fatora in fatoraList) {
      String dayName = DateFormat('EEEE')
          .format(DateTime.parse(fatora.date)); // Get day name
      if (groupedByDay[dayName] == null) {
        groupedByDay[dayName] = [];
      }
      groupedByDay[dayName]!.add(fatora);
    }
    return groupedByDay;
  }

  @override
  Widget baseBuild(BuildContext context) {
    if (groupedFatoraList == null) {
      return const HistorySkeleton();
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
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
                  onTap: (fatora) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MainScreen(
                        selectIndex: 1,
                        fatora: fatora,
                      ),
                    ));
                    // Navigator.pushReplacementNamed(
                    //   context,
                    //   Routes.main,
                    //   arguments:{
                    //     "selectIndex": 1,
                    //     "fatora": fatora,
                    //   }
                    // );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
