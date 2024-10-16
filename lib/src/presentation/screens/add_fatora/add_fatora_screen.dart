import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_button_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_date_picker_text_field_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_field_price_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_field_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_filed_fatora_widget.dart';
import 'package:flutter/material.dart';
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
    _fatoraTimeController.text = DateFormat.jm('en_US')
        .format(DateTime.now())
        .replaceAll("PM", "مساء")
        .replaceAll("AM", "صباحا");
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
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
                        String timeText =
                            time.format(context).replaceFirst("م", "مساء");
                        timeText = timeText.replaceFirst("ص", "صباحا");
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
                        _paymentController.text = selectedValue;
                      });
                    },
                    list: paymentOptions,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldPriceWidget(
                    hintText: "المبلغ",
                    height: 77,
                    textEditingController: _fatoraPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      //separate value with comma for each 3 digits
                      value = value.toString().replaceAllMapped(
                            RegExp(r'(\d{1,2})(?=(\d{2})+(?!\d))'),
                            (Match m) => '${m[2]},',
                          );
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
                        _paymentController.text = selectedValue;
                      });
                    },
                    list: paymentOptions,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    hintText: "يطاقة المستلم",
                    textEditingController: _fatoraIdController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      _fatoraIdController.text = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    SizedBox(
                        width: 105,
                        child: CustomTextFieldWidget(
                          hintText: "رقم الايصال",
                          textEditingController: _fatoraNumberArrivedController,
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            _fatoraNumberArrivedController.text = value;
                          },
                        )),
                    const SizedBox(width: 20),
                    Expanded(
                        child: CustomTextFieldWidget(
                      hintText: "رقم الحركة",
                      textEditingController: _fatoraNumberMoveController,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        _fatoraNumberMoveController.text = value;
                      },
                    )),
                  ]),
                  const SizedBox(height: 20),
                  Row(children: [
                    SizedBox(
                        width: 105,
                        child: CustomTextFieldWidget(
                          hintText: "رمز الحركة",
                          textEditingController: _fatoraMoveArrowController,
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            _fatoraMoveArrowController.text = value;
                          },
                        )),
                    const SizedBox(width: 20),
                    Expanded(
                        child: CustomTextFieldWidget(
                      hintText: "رقم الجهاز",
                      textEditingController: _fatoraNumberDeviceController,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        _fatoraNumberDeviceController.text = value;
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
                      onTap: () {},
                      width: 190,
                      buttonBorderRadius: 34,
                      text: "أضافة فاتورة",
                      backgroundColor: ColorSchemes.primary,
                      textColor: ColorSchemes.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
