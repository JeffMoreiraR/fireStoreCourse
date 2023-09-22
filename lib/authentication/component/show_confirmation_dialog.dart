import 'package:firebase_alura/authentication/services/auth_service.dart';
import 'package:flutter/material.dart';

showConfirmationPasswordDialog({
  required String email,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      final passwordConfirmationController = TextEditingController();
      return AlertDialog(
        title: Text('Deseja excluir a conta $email ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Para confirmar a exclusão da conta, insira a sua senha:'),
            TextFormField(
              controller: passwordConfirmationController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Senha'),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthService()
                  .deleteAccount(
                password: passwordConfirmationController.text,
              )
                  .then((error) {
                if (error == null) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text('EXCLUIR CONTA'),
          ),
        ],
      );
    },
  );
}
