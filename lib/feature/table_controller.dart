import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zishan_hossain/feature/table_api.dart';

class TableController extends GetxController {
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;
  var sum = 0.obs;
  RxList<List<String>> zosdata = RxList([]);
  late RxList<List<TextEditingController?>> controllers;

  final TableApiService apiService = TableApiService();

  @override
  void onInit() {
    super.onInit();
    fetchTableData();
  }

  Future<void> fetchTableData() async {
    isLoading.value = true;
    try {
      final response = await apiService.fetchTableData();
      if (response.statusCode == 200) {
        parseTableRows(response.body);
      } else {
        errorMessage.value =
        "Failed to fetch data. Status Code: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  List<List<String>> parseTableRows(String html) {
    print(html);
    final tableStart = html.indexOf('<table>');
    final tableEnd = html.indexOf('</table>');

    if (tableStart == -1 || tableEnd == -1) {
      throw Exception("No <table> tag found in the HTML.");
    }

    final tableContent = html.substring(tableStart + 7, tableEnd);

    final rowMatches =
    RegExp(r"<tr>(.*?)</tr>", dotAll: true).allMatches(tableContent);

    final tableRows = rowMatches.map((match) {
      final rowContent = match.group(1)!;
      final cellMatches =
      RegExp(r"<td>(.*?)</td>", dotAll: true).allMatches(rowContent);

      final cells =
      cellMatches.map((cellMatch) => cellMatch.group(1)!.trim()).toList();

      return cells;
    }).toList();

    zosdata.value = tableRows;

    controllers = RxList(zosdata.map((row) {
      return row.map((text) {
        final controller = TextEditingController(
          text: text == "EditText" ? '' : text,
        );

        controller.addListener(() {
          int rowIndex = controllers.indexOf(row);
          int colIndex = row.indexOf(text);
          if (rowIndex != -1 && colIndex != -1) {
            zosdata[rowIndex][colIndex] = controller.text;
            validateInput(controller.text, rowIndex, colIndex);
            calculateSum();
          }
        });

        return controller;
      }).toList();
    }).toList());

    return tableRows;
  }

  void validateInput(String value, int row, int col) {
    errorMessage.value = '';

    if (value.isEmpty) return;

    final currentValue = int.tryParse(value);
    if (currentValue == null || currentValue < 100 || currentValue > 999) {
      errorMessage.value = "Please enter a number between 100 and 999.";
      return;
    }

    for (var i = 0; i < controllers.length; i++) {
      for (var j = 0; j < controllers[i].length; j++) {
        if (i == row && j == col) continue;

        final existingValue = controllers[i][j]?.text.trim();
        if (existingValue == value) {
          errorMessage.value = "Duplicate number detected.";
          return;
        }
      }
    }

    errorMessage.value = '';
  }

  void calculateSum() {
    sum.value = 0;

    for (var i = 0; i < controllers.length; i++) {
      for (var j = 0; j < controllers[i].length; j++) {
        final value = controllers[i][j]?.text.trim();
        final number = int.tryParse(value ?? '');

        if (number != null && number >= 100 && number <= 999) {
          sum.value += number;
        }
      }
    }
  }

  @override
  void onClose() {
    for (var row in controllers) {
      for (var controller in row) {
        controller?.dispose();
      }
    }
    super.onClose();
  }
}