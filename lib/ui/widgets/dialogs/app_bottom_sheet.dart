import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.xl),
    builder: (_) => SafeArea(child: child),
  );
}

