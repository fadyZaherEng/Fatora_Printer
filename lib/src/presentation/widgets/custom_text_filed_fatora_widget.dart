import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFiledFatoraWithListWidget extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final List<String> list;
  final void Function(String) onSuffixTap;

  const CustomTextFiledFatoraWithListWidget({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.textEditingController,
    required this.list,
    required this.onSuffixTap,
  });

  @override
  State<CustomTextFiledFatoraWithListWidget> createState() =>
      _CustomTextFiledFatoraWithListWidgetState();
}

class _CustomTextFiledFatoraWithListWidgetState
    extends State<CustomTextFiledFatoraWithListWidget> {
  int selectedIndex = 0;
  bool isShowList = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: isShowList
              ? Border.all(
                  color: ColorSchemes.primary,
                  width: 1.0,
                )
              : Border.all(
                  color: const Color.fromRGBO(122, 124, 135, 0.1),
                  width: 1.0,
                )),
      child: Column(
        children: [
          SizedBox(
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
                enabledBorder: InputBorder.none,
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

                suffixIcon: InkWell(
                  onTap: () {
                    isShowList = !isShowList;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: ColorSchemes.primary,
                    size: 35,
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
          ),
          if (isShowList)
            Container(
              height: 1,
              color: ColorSchemes.primary,
            ),
          if (isShowList)
            const SizedBox(
              height: 10,
            ),
          if (isShowList)
            SizedBox(
              height: (50 * widget.list.length).toDouble(),
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      selectedIndex = index;
                      widget.textEditingController.text = widget.list[index];
                      widget.onSuffixTap(widget.list[index]);
                      isShowList = false;
                      setState(() {});
                      print(selectedIndex);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: (index == selectedIndex)
                              ? const Color.fromRGBO(245, 249, 255, 1)
                              : Colors.transparent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.list[index],
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: selectedIndex == index
                                          ? ColorSchemes.black
                                          : Colors.grey,
                                      letterSpacing: -0.13,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
