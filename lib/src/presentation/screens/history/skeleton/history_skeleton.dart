import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    width: 200,
                    height: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  child: Column(children: [
                    for (int i = 0; i < 4; i++)
                      Column(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              width: 100,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              width: double.infinity,
                              height: 150,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
