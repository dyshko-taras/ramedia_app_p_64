import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../buttons/app_primary_button.dart';
import '../buttons/app_secondary_button.dart';
import '../fields/app_text_field.dart';

class AddYourNameResult {
  AddYourNameResult({
    required this.name,
    required this.photoPath,
    required this.didClear,
  });

  final String name;
  final String? photoPath;
  final bool didClear;
}

Future<AddYourNameResult?> showAddYourNameSheet({
  required BuildContext context,
  required String title,
  required String nameLabel,
  required String nameHint,
  required String photoLabel,
  required String saveLabel,
  required String clearLabel,
  required bool showClear,
  String? initialName,
  String? initialPhotoPath,
}) {
  return showModalBottomSheet<AddYourNameResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.layerSecondary,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
    clipBehavior: Clip.antiAlias,
    builder: (_) => _AddYourNameSheet(
      title: title,
      nameLabel: nameLabel,
      nameHint: nameHint,
      photoLabel: photoLabel,
      saveLabel: saveLabel,
      clearLabel: clearLabel,
      showClear: showClear,
      initialName: initialName,
      initialPhotoPath: initialPhotoPath,
    ),
  );
}

class _AddYourNameSheet extends StatefulWidget {
  const _AddYourNameSheet({
    required this.title,
    required this.nameLabel,
    required this.nameHint,
    required this.photoLabel,
    required this.saveLabel,
    required this.clearLabel,
    required this.showClear,
    this.initialName,
    this.initialPhotoPath,
  });

  final String title;
  final String nameLabel;
  final String nameHint;
  final String photoLabel;
  final String saveLabel;
  final String clearLabel;
  final bool showClear;
  final String? initialName;
  final String? initialPhotoPath;

  @override
  State<_AddYourNameSheet> createState() => _AddYourNameSheetState();
}

class _AddYourNameSheetState extends State<_AddYourNameSheet> {
  late final TextEditingController _controller;
  final _picker = ImagePicker();

  String? _photoPath;
  bool _didClear = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
    _photoPath = widget.initialPhotoPath;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _photoPath = image.path);
  }

  void _clear() {
    setState(() {
      _controller.text = '';
      _photoPath = null;
      _didClear = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final canSave = _controller.text.trim().isNotEmpty;
    final showClearButton =
        widget.showClear && (_controller.text.isNotEmpty || _photoPath != null);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        color: AppColors.layerSecondary,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: Insets.allLg,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: Insets.allLg,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.nameLabel,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textGray,
                                    ),
                          ),
                        ),
                        Gaps.hSm,
                        AppTextField(
                          controller: _controller,
                          hintText: widget.nameHint,
                          onChanged: (_) => setState(() {}),
                        ),
                        Gaps.hLg,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.photoLabel,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textGray,
                                    ),
                          ),
                        ),
                        Gaps.hSm,
                        _PhotoPicker(
                          photoPath: _photoPath,
                          onTap: _pickPhoto,
                        ),
                        Gaps.hLg,
                        if (showClearButton) ...[
                          SizedBox(
                            height: AppSizes.buttonHeight,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _clear,
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                foregroundColor: AppColors.textPrimary,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.xl,
                                ),
                              ),
                              child: Text(widget.clearLabel),
                            ),
                          ),
                          Gaps.hSm,
                        ],
                        AppPrimaryButton(
                          label: widget.saveLabel,
                          onPressed: canSave
                              ? () {
                                  Navigator.of(context).pop(
                                    AddYourNameResult(
                                      name: _controller.text.trim(),
                                      photoPath: _photoPath,
                                      didClear: _didClear,
                                    ),
                                  );
                                }
                              : null,
                          backgroundColor: AppColors.accentPrimary,
                          foregroundColor: AppColors.textPrimary,
                        ),
                        if (!widget.showClear) ...[
                          Gaps.hSm,
                          AppSecondaryButton(
                            label: AppStrings.commonCancel,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.photoPath,
    required this.onTap,
  });

  final String? photoPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final image = photoPath == null ? null : File(photoPath!);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.xl,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppRadius.xl,
        ),
        child: image == null
            ? Center(
                child: Container(
                  height: AppSizes.photoAddButtonSize,
                  width: AppSizes.photoAddButtonSize,
                  decoration: const BoxDecoration(
                    color: AppColors.accentSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: AppSizes.photoAddIconSize,
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: AppRadius.xl,
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
