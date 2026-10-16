import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ValueNotifier<String?> _channel = ValueNotifier<String?>('stable');

  @override
  void dispose() {
    _channel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField2<String>(
          valueListenable: _channel,
          decoration: const InputDecoration(
            labelText: 'Update channel',
            border: OutlineInputBorder(),
          ),
          items: const <DropdownItem<String>>[
            DropdownItem<String>(value: 'stable', child: Text('Stable')),
            DropdownItem<String>(value: 'beta', child: Text('Beta')),
          ],
          onChanged: (String? value) => _channel.value = value,
        ),
      ),
    );
  }
}