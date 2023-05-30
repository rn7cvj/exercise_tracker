import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../i18n/strings.g.dart';

class CastomPage extends GetView<void> {
  const CastomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(t.navbar.castompage),
        ),
        body: const Placeholder());
  }
}
