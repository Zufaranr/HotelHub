import 'package:flutter/material.dart';
import 'package:hotelhub/components/my_app.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body:
          Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Dark Theme"),
              trailing: Switch(
                value: notifier.isDark,
                onChanged: (value) => notifier.changeTheme(),
              ),
            )
          ],
        );
      }),
    );
  }
}
