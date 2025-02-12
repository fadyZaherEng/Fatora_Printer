import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/blocs/fatora/fatora_bloc.dart';
import 'package:fatora/src/presentation/widgets/custom_button_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_date_picker_text_field_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_field_price_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_field_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_filed_fatora_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddFatoraScreen extends BaseStatefulWidget {
  const AddFatoraScreen({super.key});

  @override
  BaseState<AddFatoraScreen> baseCreateState() => _AddFatoraScreenState();
}

class _AddFatoraScreenState extends BaseState<AddFatoraScreen> {
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _fatoraStatusController = TextEditingController();
  final TextEditingController _fatoraSuccessController =
      TextEditingController();
  final TextEditingController _fatoraDateController = TextEditingController();
  String storeDate = "";
  final TextEditingController _fatoraTimeController = TextEditingController();
  final TextEditingController _fatoraSenderController = TextEditingController();
  final TextEditingController _fatoraPriceController = TextEditingController();
  final TextEditingController _fatoraNameController = TextEditingController();
  final TextEditingController _fatoraIdController = TextEditingController();
  final TextEditingController _fatoraNumberArrivedController =
      TextEditingController();
  final TextEditingController _fatoraNumberMoveController =
      TextEditingController();
  final TextEditingController _fatoraMoveArrowController =
      TextEditingController();
  final TextEditingController _fatoraNumberDeviceController =
      TextEditingController();
  final TextEditingController _fatoraNumberTraderController =
      TextEditingController();
  String? fatoraIdErrorMessage;
  String? numberArrivedErrorMessage;
  String? numberMoveErrorMessage;
  String? numberDeviceErrorMessage;
  String? arrowMoveMessage;
  String? fatoraSenderErrorMessage;
  Fatora _fatora = Fatora();

  FatoraBloc get fatoraBloc => BlocProvider.of<FatoraBloc>(context);

  List<String> paymentOptions = [
    "QiCard",
    "MasterCard",
    "Visa",
  ];
  List<String> fatoraStatus = [
    "مقبولة",
    "مرفوضة",
  ];
  List<String> fatoraSuccess = [
    "تم الشحن بنجاح",
    "رفض عملية الشحن",
  ];

  @override
  void initState() {
    super.initState();
    _paymentController.text = paymentOptions.first;
    _fatoraStatusController.text = fatoraStatus.first;
    _fatoraSuccessController.text = fatoraSuccess.first;
    _fatoraDateController.text = DateFormat.yMd('en_US').format(DateTime.now());
    _fatoraTimeController.text = DateFormat.jm('en_US').format(DateTime.now());
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFiledFatoraWithListWidget(
              hintText: "طرق الدفع",
              textEditingController: _paymentController,
              keyboardType: TextInputType.text,
              onSuffixTap: (selectedValue) {
                setState(() {
                  _paymentController.text = selectedValue;
                });
              },
              list: paymentOptions,
            ),
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              hintText: "الاسم",
              textEditingController: _fatoraNameController,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                _fatoraNameController.text = value;
              },
            ),
            const SizedBox(height: 20),
            CustomDatePickerTextFieldWidget(
                hintText: "التاريخ",
                isDatePicked: true,
                selectTime: (_) {},
                textEditingController: _fatoraDateController,
                pickDate: (String date, DateTime dateTime) {
                  _fatoraDateController.text = date;
                  storeDate = dateTime.toString();
                },
                deleteDate: () {
                  _fatoraDateController.clear();
                }),
            const SizedBox(height: 20),
            CustomDatePickerTextFieldWidget(
                hintText: "الوقت",
                isDatePicked: false,
                textEditingController: _fatoraTimeController,
                pickDate: (_, DateTime dateTime) {},
                selectTime: (TimeOfDay time) {
                  String timeText = time.format(context);
                  timeText = timeText.replaceFirst("م","PM");
                  timeText = timeText.replaceFirst("ص","AM");
                  _fatoraTimeController.text = timeText;
                },
                deleteDate: () {
                  _fatoraTimeController.clear();
                }),
            const SizedBox(height: 20),
            CustomTextFiledFatoraWithListWidget(
              hintText: "الحالة",
              textEditingController: _fatoraStatusController,
              keyboardType: TextInputType.text,
              onSuffixTap: (selectedValue) {
                setState(() {
                  _fatoraStatusController.text = selectedValue;
                });
              },
              list: fatoraStatus,
            ),
            const SizedBox(height: 20),
            CustomTextFieldPriceWidget(
              hintText: "المبلغ",
              height: 77,
              textEditingController: _fatoraPriceController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                //separate value with comma for each 3 digits
                value = value.toString();
                _fatoraPriceController.text = value; // "IQD $value";
              },
            ),
            const SizedBox(height: 20),
            CustomTextFiledFatoraWithListWidget(
              hintText: "حالة الشحن",
              textEditingController: _fatoraSuccessController,
              keyboardType: TextInputType.text,
              onSuffixTap: (selectedValue) {
                setState(() {
                  _fatoraSuccessController.text = selectedValue;
                });
              },
              list: fatoraSuccess,
            ),
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              hintText: "بطاقة المستلم",
              textEditingController: _fatoraIdController,
              keyboardType: TextInputType.number,
              errorMessage: fatoraIdErrorMessage,
              maxLength: 16,
              onChanged: (String value) {
                _fatoraIdController.text = value;
                if (_fatoraIdController.text.length == 16) {
                  fatoraIdErrorMessage = null;
                } else {
                  fatoraIdErrorMessage = "يجب ان يكون 16 رقم";
                }
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              hintText: "بطاقة المرسل",
              textEditingController: _fatoraSenderController,
              keyboardType: TextInputType.number,
              errorMessage: fatoraSenderErrorMessage,
              maxLength: 16,
              onChanged: (String value) {
                _fatoraSenderController.text = value;
                if (_fatoraSenderController.text.length == 16) {
                  fatoraSenderErrorMessage = null;
                } else {
                  fatoraSenderErrorMessage = "يجب ان يكون 16 رقم";
                }
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Row(children: [
              SizedBox(
                  width: 120,
                  child: CustomTextFieldWidget(
                    hintText: "رقم الايصال",
                    errorMessage: numberArrivedErrorMessage,
                    textEditingController: _fatoraNumberArrivedController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (String value) {
                      _fatoraNumberArrivedController.text = value;
                      if (_fatoraNumberArrivedController.text.length == 4) {
                        numberArrivedErrorMessage = null;
                      } else {
                        numberArrivedErrorMessage = "يجب ان يكون 4 رقم";
                      }
                      setState(() {});
                    },
                  )),
              const SizedBox(width: 10),
              Expanded(
                  child: CustomTextFieldWidget(
                hintText: "رقم الحركة",
                errorMessage: null,
                textEditingController: _fatoraNumberMoveController,
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  _fatoraNumberMoveController.text = value;
                  setState(() {});
                },
              )),
            ]),
            const SizedBox(height: 20),
            Row(children: [
              SizedBox(
                  width: 120,
                  child: CustomTextFieldWidget(
                    hintText: "رمز الحركة",
                    maxLength: 4,
                    errorMessage: arrowMoveMessage,
                    textEditingController: _fatoraMoveArrowController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      _fatoraMoveArrowController.text = value;
                      if (_fatoraMoveArrowController.text.length == 4) {
                        arrowMoveMessage = null;
                      } else {
                        arrowMoveMessage = "يجب ان يكون 4 رقم";
                      }
                      setState(() {});
                    },
                  )),
              const SizedBox(width: 10),
              Expanded(
                  child: CustomTextFieldWidget(
                hintText: "رقم الجهاز",
                errorMessage: numberDeviceErrorMessage,
                textEditingController: _fatoraNumberDeviceController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (String value) {
                  _fatoraNumberDeviceController.text = value;
                  if (_fatoraNumberDeviceController.text.length == 6) {
                    numberDeviceErrorMessage = null;
                  } else if (_fatoraNumberDeviceController.text.length != 6) {
                    numberDeviceErrorMessage = "يجب ان يكون 6 رقم";
                  }
                  setState(() {});
                },
              )),
            ]),
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              hintText: "رقم التاجر",
              textEditingController: _fatoraNumberTraderController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                _fatoraNumberTraderController.text = value;
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: CustomButtonWidget(
                onTap: () {
                  _updateValidation();
                  if (fatoraIdErrorMessage == null &&
                      numberArrivedErrorMessage == null &&
                      numberMoveErrorMessage == null &&
                      arrowMoveMessage == null &&
                      numberDeviceErrorMessage == null &&
                      fatoraSenderErrorMessage == null) {
                    //TODO: Add  data to fatora model
                    _fatora = Fatora(
                      date: storeDate == ""
                          ? DateTime.now().toString()
                          : storeDate,
                      status: _fatoraStatusController.text,
                      price: "${_fatoraPriceController.text} IQD",
                      statusSuccess: _fatoraSuccessController.text,
                      fatoraId: _fatoraIdController.text,
                      numberArrived: _fatoraNumberArrivedController.text,
                      numberMove: _fatoraNumberMoveController.text,
                      deviceNumber: _fatoraNumberDeviceController.text,
                      traderNumber: _fatoraNumberTraderController.text,
                      name: _fatoraNameController.text,
                      paymentMethod: _paymentController.text,
                      time: _fatoraTimeController.text,
                      fatoraSenderId: _fatoraSenderController.text,
                    );
                    //Todo: Add Fatora in database
                    fatoraBloc.add(AddFatoraEvent(fatora: _fatora));
                    Navigator.pop(context, _fatora);
                  }
                },
                width: 190,
                buttonBorderRadius: 34,
                text: "أضافة فاتورة",
                backgroundColor: ColorSchemes.primary,
                textColor: ColorSchemes.white,
              ),
            ),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
  }

  void _updateValidation() {
    if (_fatoraIdController.text.length != 16) {
      fatoraIdErrorMessage = "يجب ان يكون 16 رقم";
    }
    if (_fatoraSenderController.text.isEmpty) {
      fatoraSenderErrorMessage = "يجب ان يكون 16 رقم";
    }
    if (_fatoraNumberArrivedController.text.length != 4) {
      numberArrivedErrorMessage = "يجب ان يكون 4 رقم";
    }
    if (_fatoraMoveArrowController.text.length != 4) {
      arrowMoveMessage = "يجب ان يكون 4 رقم";
    }
    if (_fatoraNumberDeviceController.text.length != 6) {
      numberDeviceErrorMessage = "يجب ان يكون 6 رقم";
    }

    setState(() {});
  }
}
