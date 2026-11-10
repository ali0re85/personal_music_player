import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

Future<bool> showGlassConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  var confirmed = false;

  await GlassDialog.show(
    context: context,
    title: title,
    message: message,
    actions: [
      GlassDialogAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
      GlassDialogAction(
        label: confirmLabel,
        isDestructive: true,
        onPressed: () {
          confirmed = true;
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  return confirmed;
}
