import 'dart:typed_data';

import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
class BluetoothPrinter {
  BluetoothConnection? connection;

  Future<void> printImage(Uint8List imageBytes) async {
    // Decode the image
    img.Image? originalImage = img.decodeImage(imageBytes);

    // Convert to black-and-white and resize to the correct width
    img.Image resizedImage = img.copyResize(originalImage!, width: 384);
    img.Image bwImage = img.grayscale(resizedImage);

    // Convert to ESC/POS compatible bytes
    List<int> imageEscPosBytes = _convertImageToEscPos(bwImage);

    // Send the bytes to the printer
    connection?.output.add(Uint8List.fromList(imageEscPosBytes));
    await connection?.output.allSent;

    // Send a cut command (optional)
    connection?.output.add(Uint8List.fromList([0x1D, 0x56, 0x42, 0x00])); // ESC/POS Cut command
    await connection?.output.allSent;
  }

  List<int> _convertImageToEscPos(img.Image image) {
    // Example: Convert image to ESC/POS commands for printing
    // This part depends on your printer's ESC/POS implementation
    // Typically, you send pixel data in rows as bytes
    List<int> bytes = [];
    bytes.addAll([0x1D, 0x76, 0x30, 0x00]); // ESC/POS command for printing bit images

    int width = image.width;
    int height = image.height;

    // Convert image pixels row by row
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x += 8) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          if (x + bit < width) {
            int pixel = image.getPixel(x + bit, y);
            int luma = img.getLuminance(pixel); // Get brightness
            if (luma < 128) {
              byte |= (1 << (7 - bit));
            }
          }
        }
        bytes.add(byte);
      }
    }

    return bytes;
  }
  // Scan and connect to a Bluetooth device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to ${device.name}');
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  // Disconnect Bluetooth connection
  void disconnect() {
    if (connection != null) {
      connection!.finish();
      print('Disconnected');
    }
  }
}
// class BluetoothPrinter {
//   BluetoothConnection? connection;
//
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
//
//   // Print image
//   Future<void> printImage(Uint8List imageBytes) async {
//     // Simulate sending image data to the printer (this would be ESC/POS formatting in real use)
//     connection?.output.add(imageBytes);
//     await connection?.output.allSent;
//
//     // Send a cut command (optional)
//     connection?.output.add(Uint8List.fromList([0x1D, 0x56, 0x42, 0x00])); // ESC/POS Cut command
//     await connection?.output.allSent;
//   }
// }


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
      // _dialogMessage(
      //     icon: ImagePaths.warning,
      //     message: "Bluetooth Scan permission denied",
      //     primaryAction: () async {
      //       Navigator.pop(context);
      //       openAppSettings().then((value) async {
      //         if (await PermissionServiceHandler().handleServicePermission(
      //             setting: Permission.bluetoothConnect) &&
      //             await PermissionServiceHandler().handleServicePermission(
      //                 setting: Permission.bluetoothScan)) {}
      //       });
      //     });
      // Handle the case when the user denies the permission
      print("Bluetooth Scan permission denied");
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a device")));
      return;
    }

    Uint8List? screenshot = await screenshotController.capture();
    if (screenshot != null) {
      await bluetoothPrinter.connectToDevice(selectedDevice!);
      await bluetoothPrinter.printImage(screenshot);
      bluetoothPrinter.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capture and Print")),
      body: Column(
        children: [
          // Device selection
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
          // Print button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _captureAndPrint,
              child: const Text("Capture and Print"),
            ),
          ),
        ],
      ),
    );
  }
}


