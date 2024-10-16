import 'dart:io';

import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/core/utils/android_date_picker.dart';
import 'package:fatora/src/core/utils/constants.dart';
import 'package:fatora/src/core/utils/ios_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CustomDatePickerTextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final Function(String) pickDate;
  final Function(TimeOfDay) selectTime;
  final Function() deleteDate;
  final bool isDatePicked;

  const CustomDatePickerTextFieldWidget({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.textEditingController,
    required this.pickDate,
    required this.deleteDate,
    required this.isDatePicked,
    required this.selectTime,
  });

  @override
  State<CustomDatePickerTextFieldWidget> createState() =>
      _CustomDatePickerTextFieldWidgetState();
}

class _CustomDatePickerTextFieldWidgetState
    extends State<CustomDatePickerTextFieldWidget> {
  DateTime? selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        widget.selectTime(_selectedTime);

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        readOnly: true,
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
          suffixIcon: widget.isDatePicked && selectedDate == null
              ? InkWell(
                  onTap: () {
                    selectDate();
                  },
                  child: SvgPicture.asset(
                    ImagePaths.date,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : widget.isDatePicked && selectedDate != null
                  ? InkWell(
                      onTap: () {
                        widget.deleteDate();
                        selectedDate = null;
                        widget.textEditingController.text = "";
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close,
                        color: ColorSchemes.primary,
                      ),
                    )
                  : !widget.isDatePicked && _selectedTime == TimeOfDay.now()
                      ? InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: SvgPicture.asset(
                            ImagePaths.time,
                            fit: BoxFit.scaleDown,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            widget.deleteDate();
                            _selectedTime = TimeOfDay.now();
                            widget.textEditingController.text = "";
                            setState(() {});
                          },
                          child: Icon(
                            Icons.close,
                            color: ColorSchemes.primary,
                          ),
                        ),
          prefixIcon: Container(
            height: 46,
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
          print(value);
        },
      ),
    );
  }

  void selectDate() {
    if (Platform.isAndroid) {
      androidDatePicker(
        context: context,
        firstDate: DateTime(1900),
        onSelectDate: (date) {
          if (date == null) return;
          widget.pickDate(date.toString().split(" ")[0]);
          selectedDate = date;
          setState(() {});
        },
        selectedDate: selectedDate,
      );
    } else {
      DateTime tempDate = selectedDate ?? DateTime.now();
      iosDatePicker(
        context: context,
        selectedDate: selectedDate,
        onChange: (date) {
          tempDate = date;
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
        onDone: () {
          selectedDate = tempDate;
          widget.pickDate(selectedDate.toString().split(" ")[0]);
          Navigator.of(context).pop();
          setState(() {});
        },
      );
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}
