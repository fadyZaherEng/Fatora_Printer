import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
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
