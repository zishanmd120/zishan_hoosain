import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zishan_hossain/feature/table_binding.dart';
import 'package:zishan_hossain/feature/table_screen.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBindings(),
      home: const DynamicTableApp(),
    ),
  );
}

