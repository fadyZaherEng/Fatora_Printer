import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FatoraTablesWidget extends StatelessWidget {
  final Map<String, List<Fatora>> groupedFatora;
  final Function(Fatora) onTap;

  const FatoraTablesWidget({
    super.key,
    required this.groupedFatora,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: groupedFatora.entries.map((entry) {
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
                    4: FlexColumnWidth(1.3),
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
                        InkWell(
                          onTap:()=> onTap(fatora),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 43,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color:
                                        const Color.fromRGBO(232, 239, 251, 1),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        "view",
                                        style: TextStyle(
                                            color: ColorSchemes.primary),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat.yMd('en_US')
                                      .format(DateTime.parse(fatora.date)),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Space between each table
            ],
          );
        }).toList(),
      ),
    );
  }
}
