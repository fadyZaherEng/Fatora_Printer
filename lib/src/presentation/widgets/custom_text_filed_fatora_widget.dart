import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:flutter/material.dart';

class CustomTextFiledFatoraWidget extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final void Function()? onSuffixTap;

  const CustomTextFiledFatoraWidget({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.textEditingController,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorSchemes.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorSchemes.primary,
            ),
          ),
          suffixIcon: InkWell(
            onTap: onSuffixTap,
            child: Icon(
              Icons.arrow_drop_down,
              color: ColorSchemes.primary,
              size: 35,
            ),
          ),
          prefixIcon: Container(
            height: 46,
            width: 50,
            alignment: Alignment.center,
            color: ColorSchemes.iconBackGround,
            child: Text(
              hintText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: ColorSchemes.white.withOpacity(0.7),
                    letterSpacing: -0.13,
                  ),
            ),
          ),
        ),
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
