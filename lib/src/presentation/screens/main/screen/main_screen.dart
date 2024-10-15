// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:fatora/generated/l10n.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/core/utils/show_massage_dialog_widget.dart';

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
  List<Widget> _pages = [];
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
      body: _pages.isEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 48,
                              width: 48,
                              borderRadius: BorderRadius.circular(16),
                              shape: BoxShape.rectangle),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 5,
                                width: 50,
                              ),
                            ),
                            SizedBox(height: 10),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 5,
                                width: 100,
                              ),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 40,
                              width: 40,
                              borderRadius: BorderRadius.circular(16),
                              shape: BoxShape.circle),
                        )
                      ],
                    ),
                    const SizedBox(height: 28),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          height: 160,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(32),
                          shape: BoxShape.rectangle),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 8,
                              width: 8,
                              borderRadius: BorderRadius.circular(32),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 8,
                              width: 8,
                              borderRadius: BorderRadius.circular(32),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 8,
                              width: 8,
                              borderRadius: BorderRadius.circular(32),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 8,
                              width: 8,
                              borderRadius: BorderRadius.circular(32),
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: ColorSchemes.borderGray,
                          width: 1,
                        ),
                      ),
                      height: 111,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 8,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 8,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ],
                            ),
                            SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                  height: 100,
                                  width: 90,
                                  borderRadius: BorderRadius.circular(22),
                                  shape: BoxShape.rectangle),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 33),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 10,
                        width: 100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 50,
                                        width: 50,
                                        borderRadius: BorderRadius.circular(32),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(height: 16),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: 8,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                            ],
                          ),
                        )),
                    const SizedBox(height: 33),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 10,
                        width: 100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 32,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, 0.12))
                              ],
                              color: ColorSchemes.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 70,
                                      width: 70,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 10,
                                      width: 100,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 10,
                                      width: 150,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 32,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, 0.12))
                              ],
                              color: ColorSchemes.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 70,
                                      width: 70,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 10,
                                      width: 100,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 10,
                                      width: 150,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 32,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, 0.12))
                              ],
                              color: ColorSchemes.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 70,
                                      width: 70,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 10,
                                      width: 100,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: 10,
                                      width: 150,
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _pages[_selectedIndex],
      bottomNavigationBar: _pages.isEmpty
          ? Container(
              height: 20,
            )
          : Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: BottomNavigationBar(
                  items: _navigationItems,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: ColorSchemes.primary,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  unselectedItemColor: ColorSchemes.gray,
                  backgroundColor: ColorSchemes.white,
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: ColorSchemes.primary),
                  selectedLabelStyle: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: ColorSchemes.primary),
                  onTap: (index) => setState(() => _onItemTapped(index)),
                ),
              ),
            ),
    );
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _item({
    required String label,
    required String iconSelected,
    required String iconUnSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.all(2),
        child: SvgPicture.asset(iconUnSelected),
      ),
      label: label,
      activeIcon: Padding(
        padding: const EdgeInsets.all(2),
        child: SvgPicture.asset(
          iconSelected,
          color: ColorSchemes.primary,
        ),
      ),
    );
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
