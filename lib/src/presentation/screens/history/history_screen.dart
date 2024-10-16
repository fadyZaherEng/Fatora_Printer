import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends BaseStatefulWidget {
  const HistoryScreen({super.key});

  @override
  BaseState<HistoryScreen> baseCreateState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseState<HistoryScreen> {
  List<Fatora> fatoraList = [];

  @override
  void initState() {
    super.initState();
    //add dummy data
    fatoraList = [
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
        date: DateTime.now().add(const Duration(days: 3)  ).toString(),
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
  // Grouping Fatora list by day of the week
  Map<String, List<Fatora>> groupFatoraByDay(List<Fatora> fatoraList) {
    Map<String, List<Fatora>> groupedByDay = {};

    for (var fatora in fatoraList) {
      String dayName = DateFormat('EEEE').format(DateTime.parse(fatora.date)); // Get day name
      if (groupedByDay[dayName] == null) {
        groupedByDay[dayName] = [];
      }
      groupedByDay[dayName]!.add(fatora);
    }
    return groupedByDay;
  }
  @override
  Widget baseBuild(BuildContext context) {
    Map<String, List<Fatora>> groupedFatoraList = groupFatoraByDay(fatoraList);

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
                SingleChildScrollView(
                  child: Column(
                    children: groupedFatoraList.entries.map((entry) {
                      String day = entry.key;
                      List<Fatora> fatoraForDay = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              day, // Day of the week as the table title
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Table(
                              border: TableBorder.all(
                                color: const Color.fromRGBO(122, 124, 135, 0.1),
                                width: 1.0,
                              ),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(1),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1),
                                5: FlexColumnWidth(1),
                              },
                              children: [
                                // Table Header
                                TableRow(children: [
                                  Container(
                                    color: const Color.fromRGBO(249, 250, 251, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'حالة الشحن',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: const Color.fromRGBO(249, 250, 251, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'طريقة الدفع',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: const Color.fromRGBO(249, 250, 251, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'اسم المستلم',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: const Color.fromRGBO(249, 250, 251, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'الوقت',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: const Color.fromRGBO(249, 250, 251, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'المبلغ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: const Color.fromRGBO(249, 250, 251, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'التاريخ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ]),
                                // Populate rows based on data for the day
                                ...fatoraForDay.map((fatora) {
                                  return TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(fatora.statusSuccess),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(fatora.paymentMethod),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(fatora.name),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(fatora.time),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(fatora.price),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Text(fatora.date),
                                        ],
                                      ),
                                    ),
                                  ]);
                                }).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20), // Space between each table
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
