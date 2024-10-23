// ignore_for_file: avoid_print
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fatora/main.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/permission_service_handler.dart';
import 'package:fatora/src/core/utils/show_action_dialog_widget.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/screens/bluetooth/bluetooth_printer_screen.dart';
import 'package:fatora/src/presentation/screens/print_fatora/widgets/fatora_details_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'dart:io';

class PrintFatoraScreen extends BaseStatefulWidget {
  final Fatora? fatora;

  const PrintFatoraScreen({
    super.key,
    required this.fatora,
  });

  @override
  BaseState<PrintFatoraScreen> baseCreateState() => _PrintFatoraScreenState();
}

class _PrintFatoraScreenState extends BaseState<PrintFatoraScreen> {
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
                  child: FatoraDetailsWidget(
                    isPrint: false,
                    fatora: widget.fatora ?? const Fatora(),
                    fatoraNameController: _fatoraNameController,
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
                          _captureAndSaveImage();
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

  // Function to capture the widget as an image
  Future<void> _captureAndSaveImage() async {
    // Delay capture until the widget has fully rendered
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      // Request permissions (for mobile platforms)
      if (await PermissionServiceHandler().handleServicePermission(
          setting: PermissionServiceHandler.getStorageFilesPermission(
        androidDeviceInfo:
            Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null,
      ))) {
        RenderRepaintBoundary boundary = _globalKeyForPrint.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        // Convert the widget to an image
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        // Update the state with the captured image
        setState(() {
          _imageBytes = pngBytes; // Set the image bytes to display later
        });
        // Save the image to the gallery using ImageGallerySaver
        final result = await ImageGallerySaver.saveImage(
            _imageBytes ?? Uint8List.fromList([]),
            quality: 100);
        print(result); // Prints the saved path in the gallery
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorSchemes.white,
            content: Text(
              'تم تحميل الفاتورة بنجاح الى المعرض',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorSchemes.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        );
      } else {
        _dialogMessage(
            icon: ImagePaths.warning,
            message: "لا يوجد لديك صلاحيات للتحميل",
            primaryAction: () async {
              Navigator.pop(context);
              openAppSettings().then((value) async {
                if (await PermissionServiceHandler()
                    .handleServicePermission(setting: Permission.storage)) {}
              });
            });
      }
    } catch (e) {
      print("Error capturing widget: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error capturing image')));
    }
  }

  Future<Uint8List?> _createImageFromWidget(
    Widget widget, {
    Duration? wait,
    Size? logicalSize,
    Size? imageSize,
  }) async {
    var cxt = appNavigatorKey.currentState!.context;
    // Create a repaint boundary to capture the image
    final repaintBoundary = RenderRepaintBoundary();

    // Calculate logicalSize and imageSize if not provided
    logicalSize ??= View.of(cxt).physicalSize / View.of(cxt).devicePixelRatio;
    imageSize ??= View.of(cxt).physicalSize;

    // Ensure logicalSize and imageSize have the same aspect ratio
    assert(logicalSize.aspectRatio == imageSize.aspectRatio,
        'logicalSize and imageSize must not be the same');

    // Create the render tree for capturing the widget as an image
    final renderView = RenderView(
      view: View.of(cxt),
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    // Attach the widget's render object to the render tree
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: widget,
        )).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    // Delay if specified
    if (wait != null) {
      await Future.delayed(wait);
    }
    // Build and finalize the render tree
    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();
    // Flush layout, compositing, and painting operations
    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
    // Capture the image and convert it to byte data
    final image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Return the image data as Uint8List
    return byteData?.buffer.asUint8List();
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

  void _connectWithBluetoothPrinter() async {
    try {
      _imageBytes = await _createImageFromWidget(
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
            builder: (context) => PrintScreenApp(
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
