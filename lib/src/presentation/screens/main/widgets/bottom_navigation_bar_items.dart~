import 'package:city_eye/generated/l10n.dart';
import 'package:city_eye/src/core/resources/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

BottomNavigationBarItem bottomNavigationBarHomeItem(BuildContext context) {
  return _item(
    label: S.of(context).home,
    iconSelected: ImagePaths.selectedHome,
    iconUnSelected: ImagePaths.unselectedHome,
    context: context,
  );
}

BottomNavigationBarItem bottomNavigationBarMaintenanceItem(
    BuildContext context) {
  return _item(
    label: S.of(context).support,
    iconSelected: ImagePaths.selectedMaintenance,
    iconUnSelected: ImagePaths.unSelectedMaintenance,
    context: context,
  );
}

BottomNavigationBarItem bottomNavigationBarWallItem(BuildContext context) {
  return _item(
    label: S.of(context).wall,
    iconSelected: ImagePaths.selectedWall,
    iconUnSelected: ImagePaths.unselectedWall,
    context: context,
  );
}

BottomNavigationBarItem bottomNavigationBarServicesItem(BuildContext context) {
  return _item(
    label: S.of(context).services,
    iconSelected: ImagePaths.selectedServices,
    iconUnSelected: ImagePaths.unSelectedServices,
    context: context,
  );
}

BottomNavigationBarItem bottomNavigationBarMoreItem(BuildContext context) {
  return _item(
    label: S.of(context).more,
    iconSelected: ImagePaths.selectedMore,
    iconUnSelected: ImagePaths.unSelectedMore,
    context: context,
  );
}

BottomNavigationBarItem _item({
  required String label,
  required String iconSelected,
  required String iconUnSelected,
  required BuildContext context,
}) {
  return BottomNavigationBarItem(
    icon: Padding(
      padding: const EdgeInsets.all(2),
      child: SvgPicture.asset(iconUnSelected),
    ),
    label: label,
    activeIcon: Padding(
      padding: const EdgeInsets.all(2),
      child: SvgPicture.asset(iconSelected),
    ),
  );
}
