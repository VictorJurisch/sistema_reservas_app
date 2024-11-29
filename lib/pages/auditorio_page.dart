import 'package:flutter/material.dart';

class AuditorioPage extends StatelessWidget {
  const AuditorioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditório'),
      ),
      body: const Center(
        child: Text('Aqui você pode gerenciar o auditório!'),
      ),
    );
  }
}
