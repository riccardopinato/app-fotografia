import 'package:flutter/material.dart';

import 'profile_editor.dart';
import 'profile_scope.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProfileScope.of(context);
    return StreamBuilder(
      stream: repository.watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ProfileEditor(profile: snapshot.data, onSave: repository.save);
      },
    );
  }
}
