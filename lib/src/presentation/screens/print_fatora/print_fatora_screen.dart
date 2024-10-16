import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrintFatoraScreen extends BaseStatefulWidget {
  final Fatora fatora;

  const PrintFatoraScreen({
    super.key,
    required this.fatora,
  });

  @override
  BaseState<PrintFatoraScreen> baseCreateState() => _PrintFatoraScreenState();
}

class _PrintFatoraScreenState extends BaseState<PrintFatoraScreen> {
  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImagePaths.log,
                          width: 40,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          ImagePaths.visa,
                          width: 40,
                          height: 35,
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          ImagePaths.master,
                          width: 40,
                          height: 35,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.fatora.paymentMethod,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.fatora.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "شحن بطاقة",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    // SvgPicture.asset(
                    //   ImagePaths.group,
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 5,
                    //   fit: BoxFit.fitWidth,
                    // ),
                    _buildArrowWidget(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Text(widget.fatora.date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColorSchemes.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  )),
                          const Spacer(),
                          Text(widget.fatora.time,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColorSchemes.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // SvgPicture.asset(
                    //   ImagePaths.group,
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 5,
                    //   fit: BoxFit.fitWidth,
                    // ),
                    _buildArrowWidget(),
                    const SizedBox(height: 15),
                    Text(
                      widget.fatora.status,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "المبلغ",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.fatora.price,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.fatora.statusSuccess,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "بطاقة المستلم",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.fatora.fatoraId.substring(0, 4),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorSchemes.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            "XXXXXXXX",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorSchemes.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            //get last 4 digits sorted from right to left
                            widget.fatora.fatoraId.substring(
                                widget.fatora.fatoraId.length - 4,
                                widget.fatora.fatoraId.length),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorSchemes.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.fatora.fatoraId.substring(0, 4),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorSchemes.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            "XXXXXXXX",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorSchemes.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            //get last 4 digits sorted from right to left
                            widget.fatora.fatoraId.substring(
                                widget.fatora.fatoraId.length - 4,
                                widget.fatora.fatoraId.length),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorSchemes.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.fatora.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorSchemes.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 10),
                    // SvgPicture.asset(
                    //   ImagePaths.group,
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 5,
                    //   fit: BoxFit.fitWidth,
                    // ),
                    _buildArrowWidget(),
                    const SizedBox(height: 10),
                    //add some space
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemNumber(
                                "رقم الايصال", widget.fatora.numberArrived),
                            const SizedBox(height: 10),
                            _buildItemNumber(
                                "رقم الحركة", widget.fatora.numberMove),
                            const SizedBox(height: 10),
                            _buildItemNumber(
                                "رقم الجهاز", widget.fatora.deviceNumber),
                            const SizedBox(height: 10),
                            _buildItemNumber(
                                "رقم التاجر", widget.fatora.traderNumber),
                            const SizedBox(height: 10),
                          ]),
                    ),
                    // SvgPicture.asset(
                    //   ImagePaths.group,
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 5,
                    //   fit: BoxFit.fitWidth,
                    // ),
                    _buildArrowWidget(),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        onTap: () {},
                        buttonBorderRadius: 34,
                        text: "طباعة الفاتورة",
                        backgroundColor: ColorSchemes.primary,
                        textColor: ColorSchemes.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButtonWidget(
                        onTap: () {},
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

  Widget _buildItemNumber(label, value) {
    return Text('$label: $value',
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorSchemes.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ));
  }

  Widget _buildArrowWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            Container(
              width: 10,
              height: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 3),
            Container(
              width: 10,
              height: 3,
              color: Colors.grey[300],
            )
          ]),
          const SizedBox(width: 10),
          for (int i = 0; i < 8; i++)
            Row(
              children: [
                Column(children: [
                  Container(
                    width: 20,
                    height: 3,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 20,
                    height: 3,
                    color: Colors.grey[300],
                  )
                ]),
                const SizedBox(width: 10),
              ],
            ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(
                width: 10,
                height: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 3),
              Container(
                width: 10,
                height: 3,
                color: Colors.grey[300],
              )
            ],
          ),
        ],
      );
}
