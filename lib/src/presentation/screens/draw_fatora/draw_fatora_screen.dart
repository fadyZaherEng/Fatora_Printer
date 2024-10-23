// ignore_for_file: avoid_print
import 'dart:typed_data';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/screens/bluetooth/bluetooth_printer_screen.dart';
import 'package:fatora/src/presentation/screens/draw_fatora/utils/capture_and_save_image.dart';
import 'package:fatora/src/presentation/screens/draw_fatora/utils/create_image_from_widget.dart';
import 'package:fatora/src/presentation/screens/draw_fatora/widgets/fatora_details_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class DrawFatoraScreen extends BaseStatefulWidget {
  final Fatora? fatora;

  const DrawFatoraScreen({
    super.key,
    required this.fatora,
  });

  @override
  BaseState<DrawFatoraScreen> baseCreateState() => _PrintFatoraScreenState();
}

class _PrintFatoraScreenState extends BaseState<DrawFatoraScreen> {
  final GlobalKey _globalKeyForPrint = GlobalKey();
  Uint8List? _imageBytes;
  final _fatoraNameController = TextEditingController();

  @override
  Widget baseBuild(BuildContext context) {
    if (widget.fatora == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              "لا يوجد فاتورة من فضلك اختار فاتورة من سجل الفواتير \n او قم باضافة فاتورة جديدة",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: ColorSchemes.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RepaintBoundary(
                  key: _globalKeyForPrint,
                  child: Container(
                    color: ColorSchemes.white,
                    child: FatoraDetailsWidget(
                      isPrint: false,
                      fatora: widget.fatora ?? const Fatora(),
                      fatoraNameController: _fatoraNameController,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        onTap: () {
                          _connectWithBluetoothPrinter();
                        },
                        buttonBorderRadius: 34,
                        text: "طباعة الفاتورة",
                        backgroundColor: ColorSchemes.primary,
                        textColor: ColorSchemes.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButtonWidget(
                        onTap: () {
                          captureAndSaveImage(
                            globalKeyForPrint: _globalKeyForPrint,
                            context: context,
                            captureAndSaveImageCallback: (imageBytes) {
                              setState(
                                () {
                                  _imageBytes = imageBytes;
                                },
                              );
                            },
                          );
                        },
                        buttonBorderRadius: 34,
                        text: "تحميل الفاتورة",
                        backgroundColor: const Color.fromRGBO(48, 166, 41, 1),
                        textColor: ColorSchemes.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _connectWithBluetoothPrinter() async {
    try {
      _imageBytes = await createImageFromWidget(
        FatoraDetailsWidget(
          isPrint: true,
          fatora: widget.fatora ?? const Fatora(),
          fatoraNameController: _fatoraNameController,
        ),
        logicalSize: const Size(300, 590),
        imageSize: const Size(300, 590),
      );
      if (_imageBytes != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrintScreen(
              imageBytes: _imageBytes ?? Uint8List(0),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
