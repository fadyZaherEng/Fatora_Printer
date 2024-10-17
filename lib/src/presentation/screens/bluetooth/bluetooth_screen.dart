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

  PrintScreen({Key? key, required this.imageBytes}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // Request Bluetooth permissions
  void requestPermissions() async {
    // Request the necessary Bluetooth permissions
    var status = await Permission.bluetoothScan.request();
    if (status.isGranted) {
      // If granted, start scanning for devices
      scanForDevices();
    } else {
      _dialogMessage(
          icon: ImagePaths.warning,
          message: "Bluetooth Scan permission denied",
          primaryAction: () async {
            Navigator.pop(context);
            openAppSettings().then((value) async {
              if (await PermissionServiceHandler()
                  .handleServicePermission(setting: Permission.bluetoothScan)) {}
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
        print("Could not connect to printer");
        //SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("لم يتم الاتصال بالجهاز"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }else{
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
              Expanded(
                child: ListView.builder(
                  itemCount: devicesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(devicesList[index].name),
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// class PrintOrderScreen extends StatefulWidget {
//   Uint8List image;
//   PrintOrderScreen(this.image, {super.key});
//   @override
//   State<PrintOrderScreen> createState() => _PrintOrderScreenState();
// }
//
// class _PrintOrderScreenState extends State<PrintOrderScreen> {
//   final pdf = pw.Document();
//
//   @override
//   void initState() {
//     super.initState();
//     pdf.addPage(
//       pw.Page(build: (ctx) {
//         return pw.Center(
//           child: pw.Image(pw.MemoryImage(widget.image)),
//         );
//       },
//       ),
//     );
//     print(pdf.document);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: showOrders(),
//       ),
//     );
//   }
//
//   Widget showOrders() {
//     return PdfPreview(
//       build: (format) => pdf.save(),
//     );
//   }
// }

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:image/image.dart' as img;
// import 'package:permission_handler/permission_handler.dart';  // Import the image package
//
// class BluetoothPrintScreen extends StatefulWidget {
//   final Uint8List imageBytes;
//   const BluetoothPrintScreen({super.key, required this.imageBytes});
//
//   @override
//   _BluetoothPrintScreenState createState() => _BluetoothPrintScreenState();
// }
//
// class _BluetoothPrintScreenState extends State<BluetoothPrintScreen> {
//   final GlobalKey _specificWidgetKey = GlobalKey();
//   Uint8List? _imageBytes;
//   final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//
// // Request permissions for Android 12+ Bluetooth access
//   Future<void> _requestBluetoothPermissions() async {
//     if (await Permission.bluetoothScan.request().isGranted &&
//         await Permission.bluetoothConnect.request().isGranted &&
//         await Permission.bluetoothAdvertise.request().isGranted &&
//         await Permission.location.request().isGranted) {
//       // Permissions granted, you can proceed with scanning
//       _scanForPrinters();
//     } else {
//       // Handle the case where permissions are not granted
//       print("Bluetooth permissions are not granted.");
//     }
//   }
//
// // Call this function when you want to scan for printers
//   void _startBluetoothProcess() {
//     _requestBluetoothPermissions();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _printerManager.scanResults.listen((devices) {
//       setState(() {
//         _devices = devices;
//       });
//     });
//   }
//
//   // Function to start scanning for printers
//   void _scanForPrinters() {
//     _printerManager.startScan(const Duration(seconds: 2));
//   }
//
//   // Capture widget as an image
//   Future<void> _captureWidgetAndPrint(PrinterBluetooth printer) async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 300));
//       // Print the image using a Bluetooth printer
//       await _printImage(printer, widget.imageBytes);
//     } catch (e) {
//       print("Error capturing widget: $e");
//     }
//   }
//
//   // Function to print the captured image via Bluetooth
//   Future<void> _printImage(PrinterBluetooth printer, Uint8List imageBytes) async {
//     final profile = await CapabilityProfile.load();
//     _printerManager.selectPrinter(printer);
//
//     // Create the generator for an 80mm paper size
//     final generator = Generator(PaperSize.mm80, profile);
//
//     // Decode the image using the 'image' package
//     final img.Image? image = img.decodeImage(imageBytes);
//     if (image != null) {
//       // Add the image to the print commands
//       final List<int> bytes = [];
//       bytes.addAll(generator.image(image));
//
//       // Add feed and cut after the image
//       bytes.addAll(generator.feed(2));
//       bytes.addAll(generator.cut());
//
//       // Send the print job
//       final result = await _printerManager.printTicket(bytes);
//       print("Print result: $result");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Bluetooth Printer Example")),
//       body: Column(
//         children: [
//           RepaintBoundary(
//             key: _specificWidgetKey,
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(20),
//               child: const Text(
//                 'This is the widget to capture',
//                 style: TextStyle(color: Colors.black, fontSize: 24),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _startBluetoothProcess,
//             child: const Text('Scan for Printers'),
//           ),
//           const SizedBox(height: 20),
//           _imageBytes != null
//               ? Image.memory(_imageBytes!)
//               : const Text('Captured image will appear here'),
//           _devices.isNotEmpty
//               ? Column(
//             children: _devices
//                 .map((printer) => ListTile(
//               title: Text(printer.name ?? ''),
//               onTap: () {
//                 _captureWidgetAndPrint(printer);
//               },
//             ))
//                 .toList(),
//           )
//               : const Text('No printers found'),
//         ],
//       ),
//     );
//   }
// }
