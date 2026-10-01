/// Quick-start topics for the contact form. They spare visitors a blank page
/// and tell freelance leads apart from hiring enquiries in the inbox.
enum ContactTopic {
  newApp('New app'),
  fixApp('Fix my app'),
  hiring('Hiring'),
  hello('Just saying hi');

  const ContactTopic(this.label);

  final String label;
}
