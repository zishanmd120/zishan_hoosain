import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zishan_hossain/feature/table_controller.dart';

class DynamicTableApp extends GetView<TableController> {
  const DynamicTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Table with Zishan"),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: ListView.builder(
                          itemCount: controller.zosdata.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (int index2 = 0; index2 < controller.zosdata[index].length; index2++)
                                              SizedBox(
                                                width: 100,
                                                child: _buildTextField(controller.zosdata[index][index2], index, index2),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.errorMessage.isNotEmpty) {
                          Get.snackbar("Error", controller.errorMessage.value);
                          return;
                        }
                        controller.calculateSum();
                        Get.snackbar("Sum", "Sum: ${controller.sum.value}");
                      },
                      child: const Text('Calculate Sum'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(String data, int rowIndex, int columnIndex) {
    bool isNumber = double.tryParse(data) != null;
    TextEditingController? textController = controller.controllers[rowIndex][columnIndex];
    return isNumber
        ? TextField(
      controller: textController,
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    )
        : TextField(
      controller: textController,
      decoration: const InputDecoration(
        hintText: 'EditText',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        controller.validateInput(value, rowIndex, columnIndex);
        controller.calculateSum();
      },
    );
  }
}


