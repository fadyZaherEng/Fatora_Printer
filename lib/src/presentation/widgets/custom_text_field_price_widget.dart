import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class CustomTextFieldPriceWidget extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final void Function(String) onChanged;
  double height;

  CustomTextFieldPriceWidget({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.textEditingController,
    this.height = 46,
    required this.onChanged,
  });

  @override
  State<CustomTextFieldPriceWidget> createState() =>
      _CustomTextFieldPriceWidgetState();
}

class _CustomTextFieldPriceWidgetState
    extends State<CustomTextFieldPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          TextFormField(
            keyboardType: widget.keyboardType,
            controller: widget.textEditingController,
            onChanged: (String value) {
              widget.onChanged(value);
            },
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
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
                margin: const EdgeInsetsDirectional.only(end: 20),
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                   SizedBox(width: MediaQuery.sizeOf(context).width*0.45,),
                  Text("IQD",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: Constants.fontWeightRegular,
                            color: ColorSchemes.gray,
                            letterSpacing: -0.13,
                          )),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 60,),
                  Container(
                    height:20,
                    width: 2,
                    color: ColorSchemes.black,
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
