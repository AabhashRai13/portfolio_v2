String formatBlogDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

String formatReadTime(int minutes) {
  return '$minutes min read';
}
