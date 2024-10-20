import 'dart:typed_data';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class BluetoothPrinter {
  BluetoothConnection? connection;

  Future<void> connectToDevice(
      BluetoothDevice device, BuildContext context) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الاتصال بنجاح'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في الاتصال'),
        ),
      );
    }
  }

  // Disconnect Bluetooth connection
  void disconnect(context) {
    if (connection != null) {
      connection!.finish();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الغاء الاتصال بنجاح'),
        ),
      );
    }
  }

  Future<void> printImage(Uint8List imageData, BuildContext context) async {
    // Load a profile for the printer (ESC/POS printers often use a default profile)
    final profile = await CapabilityProfile.load();

    // Create an ESC/POS generator with the appropriate paper size (adjust size as needed)
    final generator = Generator(PaperSize.mm80, profile);

    // Decode the image using the 'image' package (convert Uint8List to a usable format)
    final image = img.decodeImage(
        imageData); // Assuming you are using the 'image' package for decoding

    if (image == null) {
      print('Failed to decode image');
      return;
    }

    // Convert the image to ESC/POS commands using the generator
    final List<int> ticket = generator.image(image);

    try {
      // Send the image data (ESC/POS formatted commands) to the printer
      connection?.output.add(Uint8List.fromList(ticket));
      await connection?.output.allSent;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الطباعة بنجاح'),
        ),
      );
      // Close the connection
      connection?.finish();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في الطباعة'),
        ),
      );
    }
  }
}

class PrintScreenApp extends StatefulWidget {
  final Uint8List imageBytes;

  const PrintScreenApp({super.key, required this.imageBytes});

  @override
  _PrintScreenAppState createState() => _PrintScreenAppState();
}

class _PrintScreenAppState extends State<PrintScreenApp> {
  ScreenshotController screenshotController = ScreenshotController();
  BluetoothPrinter bluetoothPrinter = BluetoothPrinter();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await requestPermissions();
  }

  // Request Bluetooth permissions
  Future<void> requestPermissions() async {
    if (await PermissionServiceHandler()
            .handleServicePermission(setting: Permission.bluetoothConnect) &&
        await PermissionServiceHandler()
            .handleServicePermission(setting: Permission.bluetoothScan)) {
      _getBluetoothDevices();
    } else {
      _dialogMessage(
          icon: ImagePaths.warning,
          message: "ليس لديك صلاحيات للاتصال بالبلوتوث",
          primaryAction: () async {
            Navigator.pop(context);
            openAppSettings().then((value) async {
              if (await PermissionServiceHandler().handleServicePermission(
                      setting: Permission.bluetoothConnect) &&
                  await PermissionServiceHandler().handleServicePermission(
                    setting: Permission.bluetoothScan,
                  )) {}
            });
          });
    }
  }

  void _getBluetoothDevices() async {
    if (mounted) {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getBluetoothDevices();
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
                        onPressed: () => _getBluetoothDevices(),
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
                                  selectedDevice = device;
                                  await bluetoothPrinter.connectToDevice(selectedDevice!, context);
                                  setState(() {});
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
