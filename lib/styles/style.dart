import 'package:flutter/material.dart';

BoxDecoration kHeaderDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(35),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 5),
    ),
  ],
);
