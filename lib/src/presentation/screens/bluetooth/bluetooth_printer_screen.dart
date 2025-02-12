import 'dart:typed_data';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:fatora/src/presentation/screens/bluetooth/utils/bluetooth_printer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintScreen extends BaseStatefulWidget {
  final Uint8List imageBytes;

  const PrintScreen({super.key, required this.imageBytes});

  @override
  _PrintScreenAppState baseCreateState() => _PrintScreenAppState();
}

class _PrintScreenAppState extends BaseState<PrintScreen> {
  BluetoothPrinter bluetoothPrinter = BluetoothPrinter();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      requestPermissions();
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          requestPermissions();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text("اختر الجهاز الذي تريد الطباعة"),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.bluetooth,
                          size: 25,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => requestPermissions(),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  devices.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              "لا يوجد أجهزة بلوتوث",
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              BluetoothDevice device = devices[index];
                              return ListTile(
                                title: Text(device.name ?? "Unknown Device"),
                                subtitle: Text(device.address),
                                trailing: selectedDevice == device
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : null,
                                onTap: () async {
                                  showLoading();
                                  selectedDevice = device;
                                  await bluetoothPrinter.connectToDevice(
                                      selectedDevice!, context);
                                  hideLoading();
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 10),
                  Image.memory(widget.imageBytes, width: 500, height: 200),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _sendToPrinter(context),
                      child: const Text("طباعة الفاتورة"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // send to printer
  void _sendToPrinter(context) async {
    if (selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "من فضلك قم بتحديد الجهاز الذي تريد طباعة الفاتورة",
          ),
        ),
      );
      return;
    }
    await bluetoothPrinter.printImage(widget.imageBytes, context);
    bluetoothPrinter.disconnect(context);
  }

  // Request Bluetooth permissions
  Future<void> requestPermissions() async {
    try {
      if (await PermissionServiceHandler()
              .handleServicePermission(setting: Permission.bluetoothConnect) &&
          await PermissionServiceHandler()
              .handleServicePermission(setting: Permission.bluetoothScan) &&
          await PermissionServiceHandler()
              .handleServicePermission(setting: Permission.locationWhenInUse)) {
        if (mounted) {
          devices = await FlutterBluetoothSerial.instance.getBondedDevices();
          setState(() {});
        }
      } else {
        _dialogMessage(
          icon: ImagePaths.warning,
          message: "يجب عليك السماح للاتصال بالبلوتوث",
          primaryAction: () async {
            Navigator.pop(context);
            openAppSettings().then(
              (value) async {
                if (await PermissionServiceHandler().handleServicePermission(
                        setting: Permission.bluetoothConnect) &&
                    await PermissionServiceHandler().handleServicePermission(
                      setting: Permission.bluetoothScan,
                    )) {}
              },
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
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
}
