// ignore_for_file: use_build_context_synchronously

import 'package:fatora/src/config/routes/routes_manager.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/screens/history/history_screen.dart';
import 'package:fatora/src/presentation/screens/print_fatora/print_fatora_screen.dart';

// ignore: unnecessary_import
import 'package:flutter/material.dart';

class MainScreen extends BaseStatefulWidget {
  final int selectIndex;
  final Fatora? fatora;

  const MainScreen({
    this.selectIndex = 0,
    this.fatora ,
    super.key,
  });

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _MainScreenState();
}

class _MainScreenState extends BaseState<MainScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  Fatora? _fatora ;
  List<Widget> _pages = [
    const HistoryScreen(),
    const PrintFatoraScreen(fatora: Fatora()),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = widget.selectIndex;
    super.initState();
    _fatora = widget.fatora;
    _pages = [
      const HistoryScreen(),
      PrintFatoraScreen(fatora: _fatora),
    ];
  }


  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: SizedBox(
            height: 70,
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                      decoration: BoxDecoration(
                        color: ColorSchemes.gray.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.receipt,
                          color: ColorSchemes.white,
                          size: 14,
                        ),
                      )),
                  label: "سجل الفواتر",
                ),
                BottomNavigationBarItem(
                  icon: Container(
                      decoration: BoxDecoration(
                        color: ColorSchemes.gray.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.print,
                          color: ColorSchemes.white,
                          size: 14,
                        ),
                      )),
                  label: "طباعة فاتورة",
                ),
              ],
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: ColorSchemes.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              unselectedItemColor: ColorSchemes.white,
              backgroundColor: ColorSchemes.primary,
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: ColorSchemes.white),
              selectedLabelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: ColorSchemes.white),
              onTap: (index) => setState(() => _onItemTapped(index)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addFatora).then((value) {
            if (value != null) {
              _fatora = value as Fatora;
              _pages = [
                const HistoryScreen(),
                 PrintFatoraScreen(fatora: _fatora),
              ];
              setState(() {
                _selectedIndex = 1;
              });
            }
          });
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: ColorSchemes.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorSchemes.primary,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: ColorSchemes.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: ColorSchemes.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
