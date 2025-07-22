import 'dart:developer';

import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:flutter/material.dart';
import 'package:my_portfolio/keys.dart';

class ContactServices {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    phoneController.dispose();
  }
void clearForm(){
  nameController.clear();
  emailController.clear();
  messageController.clear();
  phoneController.clear();
}


  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final templateParams = <String, dynamic>{
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'message': messageController.text.trim(),
        'phone': phoneController.text.trim(),
      };
          
      try {
     await emailjs.send(
          emailJsServiceId,
          emailJsTemplateId,
          templateParams,
          const emailjs.Options(
            publicKey: emailJsPublicKey,
            privateKey: emailJsPrivateKey,
          ),
        );
       
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully')),
          );
          clearForm();
        }
      } on Exception catch (error) {
        log('$error');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit form, please try again later.'),
            ),
          );
        }
      }
    }
  }
}
