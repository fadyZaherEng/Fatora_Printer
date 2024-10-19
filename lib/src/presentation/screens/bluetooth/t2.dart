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

// class BluetoothPrinter {
//   BluetoothConnection? connection;
//
//   Future<void> printImage(Uint8List imageBytes) async {
//     // Decode the image
//     img.Image? originalImage = img.decodeImage(imageBytes);
//
//     // Convert to black-and-white and resize to the correct width
//     img.Image resizedImage = img.copyResize(originalImage!, width: 384);
//     img.Image bwImage = img.grayscale(resizedImage);
//
//     // Convert to ESC/POS compatible bytes
//     List<int> imageEscPosBytes = _convertImageToEscPos(bwImage);
//
//     // Send the bytes to the printer
//     connection?.output.add(Uint8List.fromList(imageEscPosBytes));
//     await connection?.output.allSent;
//
//     // Send a cut command (optional)
//     connection?.output.add(Uint8List.fromList([0x1D, 0x56, 0x42, 0x00])); // ESC/POS Cut command
//     await connection?.output.allSent;
//   }
//
//   List<int> _convertImageToEscPos(img.Image image) {
//     // Example: Convert image to ESC/POS commands for printing
//     // This part depends on your printer's ESC/POS implementation
//     // Typically, you send pixel data in rows as bytes
//     List<int> bytes = [];
//     bytes.addAll([0x1D, 0x76, 0x30, 0x00]); // ESC/POS command for printing bit images
//
//     int width = image.width;
//     int height = image.height;
//
//     // Convert image pixels row by row
//     for (int y = 0; y < height; y++) {
//       for (int x = 0; x < width; x += 8) {
//         int byte = 0;
//         for (int bit = 0; bit < 8; bit++) {
//           if (x + bit < width) {
//             int pixel = image.getPixel(x + bit, y);
//             int luma = img.getLuminance(pixel); // Get brightness
//             if (luma < 128) {
//               byte |= (1 << (7 - bit));
//             }
//           }
//         }
//         bytes.add(byte);
//       }
//     }
//
//     return bytes;
//   }
//   // Scan and connect to a Bluetooth device
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     try {
//       connection = await BluetoothConnection.toAddress(device.address);
//       print('Connected to ${device.name}');
//     } catch (e) {
//       print('Failed to connect: $e');
//     }
//   }
//
//   // Disconnect Bluetooth connection
//   void disconnect() {
//     if (connection != null) {
//       connection!.finish();
//       print('Disconnected');
//     }
//   }
// }
class BluetoothPrinter {
  BluetoothConnection? connection;

  // Scan and connect to a Bluetooth device
  Future<void> connectToDevice(
      BluetoothDevice device, BuildContext context) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to ${device.name}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الاتصال بنجاح'),
        ),
      );
    } catch (e) {
      print('Failed to connect: $e');
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
      print('Disconnected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الغاء الاتصال بنجاح'),
        ),
      );
    }
  }

  // Print image
  // Future<void> printImage(Uint8List imageBytes) async {
  //   // Simulate sending image data to the printer (this would be ESC/POS formatting in real use)
  //   connection?.output.add(imageBytes);
  //   await connection?.output.allSent;
  //
  //   // Send a cut command (optional)
  //   connection?.output.add(
  //       Uint8List.fromList([0x1D, 0x56, 0x42, 0x00])); // ESC/POS Cut command
  //   await connection?.output.allSent;
  // }
  Future<void> printImage(Uint8List imageData) async {
    // Load a profile for the printer (ESC/POS printers often use a default profile)
    final profile = await CapabilityProfile.load();

    // Create an ESC/POS generator with the appropriate paper size (adjust size as needed)
    final generator = Generator(PaperSize.mm80, profile);

    // Decode the image using the 'image' package (convert Uint8List to a usable format)
    final image = img.decodeImage(imageData); // Assuming you are using the 'image' package for decoding

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
      print('Image data sent to the printer');

      // Close the connection
      connection?.finish();
    } catch (e) {
      print('Error occurred while connecting/sending: $e');
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
  void initState() {
    super.initState();
    _getBluetoothDevices();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await requestPermissions();
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
        });
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
                      setting: Permission.bluetoothScan)) {}
            });
          });
      print("ليس لديك صلاحيات للاتصال بالبلوتوث");
    }
  }

  // Get bonded Bluetooth devices
  void _getBluetoothDevices() async {
    devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {});
  }

  // Capture the screenshot and send to printer
  void _captureAndPrint() async {
    if (selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("من فضلك قم بتحديد الجهاز الذي تريد طباعة الفاتورة")));
      return;
    }
      await bluetoothPrinter.connectToDevice(selectedDevice!, context);
      await bluetoothPrinter.printImage(widget.imageBytes);
      bluetoothPrinter.disconnect(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Device selection
              const SizedBox(height: 10),
              const Text("اختر الجهاز الذي تريد الطباعة"),
              const SizedBox(height: 10),
              Icon(
                Icons.bluetooth,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: devices.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          BluetoothDevice device = devices[index];
                          return ListTile(
                            title: Text(device.name ?? "Unknown Device"),
                            subtitle: Text(device.address),
                            trailing: selectedDevice == device
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              setState(() {
                                selectedDevice = device;
                              });
                            },
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              // Image
              // Image.memory(widget.imageBytes, width: 200, height: 200),
              const SizedBox(height: 10),
              // Print button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _captureAndPrint,
                  child: const Text("طباعة الفاتورة"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
