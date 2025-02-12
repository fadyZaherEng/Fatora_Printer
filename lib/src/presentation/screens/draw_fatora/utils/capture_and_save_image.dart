// Function to capture the widget as an image
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

Future<void> captureAndSaveImage({
  required GlobalKey globalKeyForPrint,
  required BuildContext context,
  required void Function(Uint8List?) captureAndSaveImageCallback,
}) async {
  Uint8List? imageBytes;
  // Delay capture until the widget has fully rendered
  await Future.delayed(const Duration(milliseconds: 300));
  try {
    // Request permissions (for mobile platforms)
    if (await PermissionServiceHandler().handleServicePermission(
      setting: PermissionServiceHandler.getStorageFilesPermission(
        androidDeviceInfo:
            Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null,
      ),
    )) {
      print("Permission granted");
      RenderRepaintBoundary boundary = globalKeyForPrint.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      // Convert the widget to an image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      // Update the state with the captured image

      imageBytes = pngBytes; // Set the image bytes to display later

      // Save the image to the gallery using ImageGallerySaver
      final result = await ImageGallerySaver.saveImage(imageBytes, quality: 100);
      print(result);
      // Prints the saved path in the gallery
      captureAndSaveImageCallback(imageBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorSchemes.white,
          content: Text(
            'تم تحميل الفاتورة بنجاح الى المعرض',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorSchemes.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      );
    } else {
      _dialogMessage(
        icon: ImagePaths.warning,
        context: context,
        message: "يرجى السماح بالتصريح للتحميل",
        primaryAction: () async {
          Navigator.pop(context);
          openAppSettings().then(
            (value) async {
              if (await PermissionServiceHandler().handleServicePermission(
                  setting: PermissionServiceHandler.getStorageFilesPermission(
                androidDeviceInfo: Platform.isAndroid
                    ? await DeviceInfoPlugin().androidInfo
                    : null,
              ))) {}
            },
          );
        },
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error capturing image $e')));
  }
}

void _dialogMessage({
  required String message,
  required String icon,
  required Function() primaryAction,
  Function()? secondaryAction,
  required BuildContext context,
}) {
  showActionDialogWidget(
    context: context,
    text: message,
    icon: icon,
    primaryText: "نعم",
    secondaryText: "لا",
    primaryAction: () async {
      primaryAction();
    },
    secondaryAction: () {
      secondaryAction ?? Navigator.pop(context);
    },
  );
}
