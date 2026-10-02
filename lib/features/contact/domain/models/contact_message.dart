class ContactMessage {
  const ContactMessage({
    required this.name,
    required this.email,
    required this.message,
  });

  final String name;
  final String email;
  final String message;

  Map<String, dynamic> toTemplateParams() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'message': message,
    };
  }
}
