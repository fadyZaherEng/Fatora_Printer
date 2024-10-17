// ignore_for_file: avoid_print, must_be_immutable
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class PrintScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const PrintScreen({Key? key, required this.imageBytes}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await requestPermissions();
  }

  // Request Bluetooth permissions
  Future<void> requestPermissions() async {
    // Request the necessary Bluetooth permissions
    // var status = await Permission.bluetoothScan.request();
    if (await PermissionServiceHandler()
            .handleServicePermission(setting: Permission.bluetoothConnect) &&
        await PermissionServiceHandler()
            .handleServicePermission(setting: Permission.bluetoothScan)) {
      // If granted, start scanning for devices
      scanForDevices();
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
    }
  }

  void scanForDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("  تم الاتصال بالجهاز من فضلك اضغط طباعة الفاتورة"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> printImage() async {
    if (connectedDevice != null) {
      final profile = await CapabilityProfile.load();
      final printer = NetworkPrinter(PaperSize.mm80, profile);

      // Connect to printer
      final connectResult =
          await printer.connect(connectedDevice!.id.toString(), port: 9100);

      if (connectResult == PosPrintResult.success) {
        // Print the image
        printer.image(
          img.decodeImage(widget.imageBytes)!,
          align: PosAlign.center,
        );
        printer.feed(2); // Feed the paper after printing
        printer.disconnect();
      } else {
        print("لا يمكن الاتصال بالطابعة");
        //SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("لم يتم الاتصال بالجهاز"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("لم يتم الاتصال بالجهاز"),
          backgroundColor: Colors.red,
        ),
      );
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
              if (devicesList.isEmpty) const LinearProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  itemCount: devicesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(devicesList[index].name.toString()),
                      onTap: () => connectToDevice(devicesList[index]),
                    );
                  },
                ),
              ),
              Image.memory(widget.imageBytes, width: 200, height: 200),
              ElevatedButton(
                onPressed: printImage,
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

