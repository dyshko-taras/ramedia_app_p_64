import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';
import 'add_your_name_sheet.dart';

Future<AddYourNameResult?> showAddParticipantSheet({
  required BuildContext context,
  bool showClear = true,
  String? initialName,
  String? initialPhotoPath,
}) {
  return showAddYourNameSheet(
    context: context,
    title: AppStrings.addYourNameTitle,
    nameLabel: AppStrings.addYourNameAddNameLabel,
    nameHint: AppStrings.addYourNameParticipantNamePlaceholder,
    photoLabel: AppStrings.addYourNameAddPhotoLabel,
    saveLabel: AppStrings.commonSave,
    clearLabel: AppStrings.commonClearInformation,
    showClear: showClear,
    initialName: initialName,
    initialPhotoPath: initialPhotoPath,
  );
}

