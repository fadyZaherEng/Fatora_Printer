import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_filed_fatora_widget.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends BaseStatefulWidget {
  const HistoryScreen({super.key});

  @override
  BaseState<HistoryScreen> baseCreateState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseState<HistoryScreen> {
  final TextEditingController _paymentController = TextEditingController();
  List<String> paymentOptions = [
    "QiCard",
    "MasterCard",
    "Visa",
  ];
  @override
  void initState() {
    super.initState();
    _paymentController.text = paymentOptions.first;
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
