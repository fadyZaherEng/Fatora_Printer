import 'package:flutter/material.dart';

class BuildArrowWidget extends StatelessWidget {
  final bool isPrint;

  const BuildArrowWidget({
    super.key,
    required this.isPrint,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrint) {
      return const SizedBox(
        width: 300,
        height: 10,
        child: Divider(
          thickness: 1.5,
          color: Colors.black,
        ),
      );
    }
    return SizedBox(
      width: 300,
      height: 10,
      child: Row(
        children: [
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
          const SizedBox(width: 10),
          for (int i = 0;
              i < ((MediaQuery.of(context).size.width - 140) / 30);
              i++)
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
                const SizedBox(width: 8),
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
      ),
    );
  }
}
