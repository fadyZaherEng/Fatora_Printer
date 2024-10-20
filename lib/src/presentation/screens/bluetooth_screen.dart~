// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class PrintScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const PrintScreen({
    super.key,
    required this.imageBytes,
  });

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  List<BluetoothDevice> discoveredDevices = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await requestPermissions();
  }

  // Request Bluetooth permissions
  Future<void> requestPermissions() async {
    // Request the necessary Bluetooth permissions

    if (mounted) {
      if (await PermissionServiceHandler()
              .handleServicePermission(setting: Permission.bluetoothConnect) &&
          await PermissionServiceHandler()
              .handleServicePermission(setting: Permission.bluetoothScan)) {
        // If granted, start scanning for devices
        await scanForDevices();
      } else {
        _dialogMessage(
            icon: ImagePaths.warning,
            message: "Bluetooth Scan permission denied",
            primaryAction: () async {
              Navigator.pop(context);
              openAppSettings().then((value) async {
                if (await PermissionServiceHandler().handleServicePermission(
                        setting: Permission.bluetoothConnect) &&
                    await PermissionServiceHandler().handleServicePermission(
                        setting: Permission.bluetoothScan)) {}
              });
            });
        // Handle the case when the user denies the permission
        print("Bluetooth Scan permission denied");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorSchemes.white,
            content: Text(
              'تم رفض الاذن',
              style: TextStyle(color: ColorSchemes.primary),
            ),
          ),
        );
      }
    }
  }

  // Scan for Bluetooth devices
  Future<void> scanForDevices() async {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((scanResults) {
      for (ScanResult result in scanResults) {
        discoveredDevices.add(result.device);
        setState(() {});
        print('Found device: ${result.device.name}');
        print('Found device: ${result.device.id}');
        print("length: ${discoveredDevices.length}");
      }
    });

    // Stop scanning after finding a device
    flutterBlue.stopScan();
  }

  // Connect to a Bluetooth device
  Future<void> connectToDevice(BluetoothDevice device) async {
    connectedDevice = device;
    await device.connect();
    print('Connected to ${device.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorSchemes.white,
        content: Text(
          'تم الاتصال بنجاح',
          style: TextStyle(color: ColorSchemes.primary),
        ),
      ),
    );
    setState(() {});
  }

  // Print a Uint8List image
  void printImage(Uint8List imageData) async {
    if (connectedDevice == null) {
      print('No device connected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorSchemes.white,
          content: Text(
            'لا يوجد جهاز متصلة',
            style: TextStyle(color: ColorSchemes.primary),
          ),
        ),
      );
      return;
    }

    // Decode the Uint8List to an image
    img.Image? image = img.decodeImage(imageData);
    if (image != null) {
      // Resize the image to fit printer width (384 pixels for most thermal printers)
      img.Image resizedImage = img.copyResize(image, width: 384);

      // Convert image to bytes (PNG format)
      Uint8List imageBytes = Uint8List.fromList(img.encodePng(resizedImage));

      // Send the image bytes to the printer
      BluetoothCharacteristic? characteristic =
          await findWritableCharacteristic();
      if (characteristic != null) {
        await characteristic.write(imageBytes, withoutResponse: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorSchemes.white,
            content: Text(
              'تم الطباعة بنجاح',
              style: TextStyle(color: ColorSchemes.primary),
            ),
          ),
        );
        print('Image sent to printer');
      } else {
        print('Failed to find writable characteristic');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorSchemes.white,
            content: Text(
              'فشل الطباعة',
              style: TextStyle(color: ColorSchemes.primary),
            ),
          ),
        );
      }
    } else {
      print('Failed to decode image');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorSchemes.white,
          content: Text(
            'فشل الطباعة',
            style: TextStyle(color: ColorSchemes.primary),
          ),
        ),
      );
    }
  }

  // Find a writable characteristic for sending data
  Future<BluetoothCharacteristic?> findWritableCharacteristic() async {
    if (connectedDevice == null) return null;

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          return characteristic;
        }
      }
    }
    return null;
  }

  // Disconnect from the Bluetooth device
  Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      print('Device disconnected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("اختر الجهاز الذي تريد الطباعة"),
              const SizedBox(height: 10),
              Icon(
                Icons.bluetooth,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              if (discoveredDevices.isEmpty) const LinearProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  itemCount: discoveredDevices.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(discoveredDevices[index].name.toString()),
                      onTap: () => connectToDevice(discoveredDevices[index]),
                    );
                  },
                ),
              ),
              Image.memory(widget.imageBytes, width: 200, height: 200),
              ElevatedButton(
                onPressed: () => printImage(widget.imageBytes),
                child: const Text("طباعة الفاتورة"),
              ),
              Text(connectedDevice != null
                  ? 'متصل ب ${connectedDevice!.name}'
                  : 'لا يوجد جهاز متصل بالبلوتوث'),
            ],
          ),
        ),
      ),
    );
  }

  void _dialogMessage({
    required String message,
    required String icon,
    required Function() primaryAction,
    Function()? secondaryAction,
  }) {
    showActionDialogWidget(
        context: context,
        text: message,
        icon: icon,
        primaryText: "Yes",
        secondaryText: "No",
        primaryAction: () async {
          primaryAction();
        },
        secondaryAction: () {
          secondaryAction ?? Navigator.pop(context);
        });
  }
}
