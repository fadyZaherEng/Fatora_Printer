import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/utils/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final void Function(String) onChanged;
  double height;

  CustomTextFieldWidget({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.textEditingController,
    this.height = 46,
    required this.onChanged,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: Constants.fontWeightRegular,
            color: ColorSchemes.black,
            letterSpacing: -0.13),
        decoration: InputDecoration(
          // border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(122, 124, 135, 0.1),
              width: 1.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorSchemes.primary),
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorSchemes.border),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorSchemes.redError),
              borderRadius: BorderRadius.circular(12)),
          prefixIcon: Container(
            height: widget.height,
            width: 50,
            margin: const EdgeInsetsDirectional.only(end: 8.0),
            alignment: Alignment.center,
            color: ColorSchemes.iconBackGround,
            child: Text(
              widget.hintText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color.fromRGBO(83, 83, 83, 1),
                    letterSpacing: -0.13,
                  ),
            ),
          ),
        ),
        onChanged: (value) {
          widget.onChanged(value);
          print(value);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
