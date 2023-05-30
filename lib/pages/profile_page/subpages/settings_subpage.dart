import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constans.dart';
import '../../../controllers/main_controller.dart';
import '../../../i18n/strings.g.dart';
import 'widgets/seed_color_toogle.dart';
import 'widgets/theme_toogle.dart';

class SettingsSubpage extends GetView<MainController> {
  const SettingsSubpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              t.settings.theme_mode,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(
              padding: EdgeInsets.all(appPadding),
              child: ThemeToggle(),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              t.settings.seed_color,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(
              padding: EdgeInsets.all(appPadding),
              child: SeedColorToogle(),
            ),
          ],
        ),
      ),
    );
  }
}
