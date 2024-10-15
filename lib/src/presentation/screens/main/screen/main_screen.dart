// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:fatora/generated/l10n.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/core/utils/show_massage_dialog_widget.dart';
import 'package:fatora/src/presentation/screens/add_fatora/add_fatora_screen.dart';
import 'package:fatora/src/presentation/screens/history/history_screen.dart';

// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletons/skeletons.dart';

class MainScreen extends BaseStatefulWidget {
  final int selectIndex;
  final bool? isFromDeepLink;
  final String inviterName;
  final String unitName;

  const MainScreen({
    this.selectIndex = 0,
    this.isFromDeepLink = false,
    this.inviterName = "",
    this.unitName = "",
    Key? key,
  }) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _MainScreenState();
}

class _MainScreenState extends BaseState<MainScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    const HistoryScreen(),
    const AddFatoraScreen(),
  ];
  List<BottomNavigationBarItem> _navigationItems = [];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = widget.selectIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  bool isShake(List<double> values) {
    const double shakeThreshold = 30;

    double acceleration = values.reduce((sum, value) => sum + value.abs());

    return acceleration > shakeThreshold;
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal:  10),
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
                          Icons.add,
                          color: ColorSchemes.white,
                          size: 14,
                        ),
                      )),
                  label: "اضافة فاتورة",
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
        onPressed: () {},
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

  void _showMassageDialogWidget(
    String text,
    String icon,
  ) {
    showMassageDialogWidget(
      context: context,
      text: text,
      icon: icon,
      buttonText: S.of(context).ok,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
