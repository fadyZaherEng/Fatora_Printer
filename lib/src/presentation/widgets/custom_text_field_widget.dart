import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/utils/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final void Function(String) onChanged;
  double? height;
  String? errorMessage;
  int? maxLength;
  bool isPrefixIcon ;

  CustomTextFieldWidget({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.textEditingController,
    this.height = 46,
    required this.onChanged,
    this.errorMessage,
    this.maxLength,
    this.isPrefixIcon =true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
       height: height,
          child: TextFormField(
            controller: textEditingController,
            keyboardType: keyboardType,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: Constants.fontWeightRegular,
                color: ColorSchemes.black,
                letterSpacing: -0.13),
            maxLength: maxLength,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(122, 124, 135, 0.1),
                  width: 1.0,
                ),
              ),
              counterText: "",
              errorText: errorMessage==null?null:"",
              errorStyle: const TextStyle(height: 0),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorSchemes.primary, width: 1),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorSchemes.border, width: 1),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorSchemes.redError),
              ),
              prefixIcon:isPrefixIcon? Container(
                width: 50,
                height: height,
                margin: const EdgeInsetsDirectional.only(end: 8.0),
                alignment: Alignment.center,
                color: ColorSchemes.iconBackGround,
                child: Text(
                  hintText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color.fromRGBO(83, 83, 83, 1),
                        letterSpacing: -0.13,
                      ),
                ),
              ):null,
            ),
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
        if (errorMessage != null)
          const SizedBox(height: 5),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: ColorSchemes.redError),
          ),
      ],
    );
  }
}
