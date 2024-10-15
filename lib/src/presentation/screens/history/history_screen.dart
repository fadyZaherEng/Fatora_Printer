import 'package:fatora/src/core/base/widget/base_stateful_widget.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends BaseStatefulWidget {
  const HistoryScreen({super.key});

  @override
  BaseState<HistoryScreen> baseCreateState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseState<HistoryScreen> {
  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold();
  }
}