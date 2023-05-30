import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/strings.g.dart';

class ProfilePage extends GetView<void> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.navbar.profile),
              IconButton(
                onPressed: () {
                  context.push("/profile/settings");
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: const Placeholder());
  }
}
