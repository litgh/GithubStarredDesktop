import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Error extends StatelessWidget {
  final String? error;
  const Error({
    Key? key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error ?? ""),
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed('Home');
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
