import 'dart:developer';
import 'dart:typed_data';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as anotherImage;
import 'package:permission_handler/permission_handler.dart';

class PrintScreenApp extends StatefulWidget {
  final Uint8List imageBytes;

  const PrintScreenApp({super.key, required this.imageBytes});

  @override
  _PrintScreenAppState createState() => _PrintScreenAppState();
}

class _PrintScreenAppState extends State<PrintScreenApp> {
  BluetoothPrinter bluetoothPrinter = BluetoothPrinter();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _getBluetoothDevices(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                selectedDevice = device;
                                if (mounted) {
                                  setState(() async {
                                    await bluetoothPrinter.connectToDevice(
                                        selectedDevice!, context);
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 10),
                Image.memory(widget.imageBytes, width: 400, height: 200),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      _sendFatoraToPrinter();
                    },
                    child: const Text("طباعة الفاتورة"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Request Bluetooth permissions
  Future<void> requestPermissions() async {
    if (await PermissionServiceHandler()
        .handleServicePermission(setting: Permission.bluetoothConnect) &&
        await PermissionServiceHandler().handleServicePermission(
          setting: Permission.bluetoothScan,
        )) {
      if (mounted) {
        _getBluetoothDevices();
      }
    } else {
      _dialogMessage(
        icon: ImagePaths.warning,
        message: "ليس لديك صلاحيات للاتصال بالبلوتوث",
        primaryAction: () async {
          Navigator.pop(context);
          openAppSettings().then(
                (value) async {
              if (await PermissionServiceHandler().handleServicePermission(
                  setting: Permission.bluetoothConnect) &&
                  await PermissionServiceHandler().handleServicePermission(
                      setting: Permission.bluetoothScan)) {}
            },
          );
        },
      );
    }
  }

  // Get bonded Bluetooth devices
  void _getBluetoothDevices() async {
    if (mounted) {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {});
    }
  }
  void _sendFatoraToPrinter() async {
    log('printTest');
    try {
      String ip = selectedDevice!.address;
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final printerService = NetworkPrinter(paper, profile);
      log('connecting');
      final PosPrintResult res = await printerService.connect(ip, port: 9100);
      if (res == PosPrintResult.success) {
        log('connected');
        final anotherImage.Image fatoraImage =
            anotherImage.decodeImage(widget.imageBytes)!;
        printerService.image(fatoraImage);
        // // table header
        // Uint8List? tableHeaderAs8List = await createImageFromWidget(tableHeader(), logicalSize: const Size(500, 500), imageSize: const Size(680, 680));
        // final anotherImage.Image tableHeaderImage = anotherImage.decodeImage(tableHeaderAs8List!)!;
        // // divider
        // Uint8List? dividerAs8List = await createImageFromWidget(divider(), logicalSize: const Size(500, 500), imageSize: const Size(680, 680));
        // final anotherImage.Image dividerImage = anotherImage.decodeImage(dividerAs8List!)!;
        // // table item row
        // Uint8List? tableItemRowAs8List = await createImageFromWidget(tableItemRow(), logicalSize: const Size(500, 500), imageSize: const Size(680, 680));
        // final anotherImage.Image tableItemRowImage = anotherImage.decodeImage(tableItemRowAs8List!)!;
        // // table footer
        // Uint8List? tableFooterRowAs8List = await createImageFromWidget(tableFotter(), logicalSize: const Size(500, 500), imageSize: const Size(680, 680));
        // final anotherImage.Image tableFooterImage = anotherImage.decodeImage(tableFooterRowAs8List!)!;
        // // invoice ref & print time
        // Uint8List? invoiceRefAndPrintTimeAs8List =
        // await createImageFromWidget(referenceNoAndPrintTime(), logicalSize: const Size(500, 500), imageSize: const Size(680, 680));
        // final anotherImage.Image invoiceRefAndPrintTimerImage = anotherImage.decodeImage(invoiceRefAndPrintTimeAs8List!)!;
        // printerService.image(tableHeaderImage);
        // printerService.image(dividerImage);
        // printerService.image(tableItemRowImage);
        // printerService.image(tableItemRowImage);
        // printerService.image(tableItemRowImage);
        // printerService.image(dividerImage);
        // printerService.image(tableFooterImage);
        printerService.emptyLines(2);
        // printerService.image(invoiceRefAndPrintTimerImage);
        printerService.feed(1);
        printerService.cut();
        printerService.disconnect();
      }
      log('res value: ${res.value}');
      log('res msg: ${res.msg}');
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
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

//Connection to a Bluetooth device
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
        SnackBar(
          content: Text('${e.toString()} فشل في الاتصال'),
        ),
      );
    }
  }

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
}
