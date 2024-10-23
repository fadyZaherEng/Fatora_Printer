import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/screens/draw_fatora/widgets/build_arrow_widget.dart';
import 'package:fatora/src/presentation/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FatoraDetailsWidget extends StatelessWidget {
  final Fatora fatora;
  final bool isPrint;
  final TextEditingController fatoraNameController;

  const FatoraDetailsWidget({
    super.key,
    required this.fatora,
    this.isPrint = false,
    required this.fatoraNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImagePaths.log,
                    width: 35,
                    height: 30,
                    color: Colors.black,
                    // scale: 0.6,
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    ImagePaths.visa,
                    width: 35,
                    height: 30,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    ImagePaths.master,
                    width: 35,
                    height: 30,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              fatora.paymentMethod,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              fatora.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            // const SizedBox(height: 5),
            Text(
              "شحن بطاقة",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            BuildArrowWidget(isPrint: isPrint),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(fatora.date.split(" ")[0],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorSchemes.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      )),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    fatora.time.split(" ")[0],
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorSchemes.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            BuildArrowWidget(isPrint: isPrint),
            const SizedBox(height: 2),
            Text(
              fatora.status,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            // const SizedBox(height: 5),
            Text(
              "المبلغ",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              fatora.price,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              fatora.statusSuccess,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "بطاقة المستلم",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: 160,
                  child: Row(
                    children: [
                      Text(
                        fatora.fatoraId.substring(
                            fatora.fatoraId.length - 4,
                            fatora.fatoraId.length),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorSchemes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "XXXXXXXX",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorSchemes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        fatora.fatoraId.substring(0, 4),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorSchemes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: 160,
                  child: Row(
                    children: [
                      Text(
                        fatora.fatoraSenderId.substring(
                            fatora.fatoraSenderId.length - 4,
                            fatora.fatoraSenderId.length),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorSchemes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "XXXXXXXX",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorSchemes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        fatora.fatoraSenderId.substring(0, 4),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorSchemes.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            isPrint
                ? Text(
              fatoraNameController.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorSchemes.black,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            )
                : CustomTextFieldWidget(
              hintText: "الاسم",
              isPrefixIcon: false,
              textEditingController: fatoraNameController,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                fatoraNameController.text = value;
              },
            ),
            const SizedBox(height: 2),
            BuildArrowWidget(isPrint: isPrint),
            const SizedBox(height: 2),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildItemNumber(
                        "رقم الايصال", fatora.numberArrived,context),
                    const SizedBox(height: 5),
                    _buildItemNumber("رقم الحركة", fatora.numberMove,context),
                    const SizedBox(height: 5),
                    _buildItemNumber("رقم الجهاز", fatora.deviceNumber,context),
                    const SizedBox(height: 5),
                    _buildItemNumber("رقم التاجر", fatora.traderNumber,context),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            BuildArrowWidget(isPrint: isPrint),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
  Widget _buildItemNumber(label, value,context) {
    return Text(
      '$label: $value',
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: ColorSchemes.black,
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
    );
  }

}
