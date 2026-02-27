import 'dart:io';

Future<bool> hasInternetConnection({
  Duration timeout = const Duration(seconds: 3),
}) async {
  try {
    final result = await InternetAddress.lookup('example.com').timeout(timeout);
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
