import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

Future<String?> showCreatePlaylistDialog(BuildContext context) {
  return _showNameDialog(context, title: 'New playlist', actionLabel: 'Create');
}

Future<String?> showRenamePlaylistDialog(
  BuildContext context,
  String currentName,
) {
  return _showNameDialog(
    context,
    title: 'Rename playlist',
    actionLabel: 'Save',
    initialName: currentName,
  );
}

Future<String?> _showNameDialog(
  BuildContext context, {
  required String title,
  required String actionLabel,
  String initialName = '',
}) {
  var text = initialName;

  void submit() {
    final name = text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  return GlassDialog.show<String>(
    context: context,
    title: title,
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: _NameField(
        initialName: initialName,
        onChanged: (value) => text = value,
        onSubmitted: submit,
      ),
    ),
    actions: [
      GlassDialogAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
      GlassDialogAction(label: actionLabel, isPrimary: true, onPressed: submit),
    ],
  );
}

class _NameField extends StatefulWidget {
  const _NameField({
    required this.initialName,
    required this.onChanged,
    required this.onSubmitted,
  });

  final String initialName;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: (_) => widget.onSubmitted(),
      decoration: const InputDecoration(
        hintText: 'Playlist name',
        hintStyle: TextStyle(color: Colors.white54),
      ),
    );
  }
}
