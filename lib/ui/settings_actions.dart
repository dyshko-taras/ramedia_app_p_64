import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/dialogs/no_internet_dialog.dart';

Future<void> openPrivacyPolicy({
  required BuildContext context,
  required String url,
}) async {
  final navigator = Navigator.of(context);

  final uri = Uri.tryParse(url);
  if (uri == null) {
    await showNoInternetDialog(context: context);
    return;
  }

  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && navigator.mounted) {
    await showNoInternetDialog(context: context);
  }
}

Future<void> shareApplication(String url) async {
  await SharePlus.instance.share(ShareParams(text: url));
}
