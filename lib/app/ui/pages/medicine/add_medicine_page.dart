import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/add_medicine_controller.dart';
import '../../../controllers/medicine_controller.dart';
import '../../../data/models/medicine_model.dart';
import '../../widgets/custom_button.dart';

class AddMedicinePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final AddMedicineController addController = Get.put(AddMedicineController());
  final MedicineController medicineController = Get.find<MedicineController>();

  AddMedicinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Clear form when page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addController.clearForm();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
        backgroundColor: Colors.purple[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Medicine 💊',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fill in the details to track your medicine schedule.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              _buildNameSection(),
              const SizedBox(height: 20),
              _buildTypeSection(),
              const SizedBox(height: 20),
              _buildScheduleSection(),
              const SizedBox(height: 20),
              _buildNotesSection(),
              const SizedBox(height: 40),
              Obx(() => CustomButton(
                text: 'Add Medicine',
                onPressed: addController.isLoading.value ? null : _onAddPressed,
                isLoading: addController.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medicine Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: addController.nameController,
              decoration: const InputDecoration(
                hintText: 'Enter medicine name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter medicine name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medicine Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MedicineType.values.map((type) {
                final isSelected = addController.selectedType.value == type;
                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(medicineController.getMedicineTypeIcon(type)),
                      const SizedBox(width: 4),
                      Text(medicineController.getMedicineTypeName(type)),
                    ],
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      addController.selectMedicineType(type);
                    }
                  },
                  backgroundColor: Colors.purple[50],
                  selectedColor: Colors.purple[200],
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Schedule Times',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addScheduleTime,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Time'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (addController.scheduledTimes.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 40,
                        color: Colors.purple[300],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'No schedule times added',
                          style: TextStyle(
                            color: Colors.purple[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addController.scheduledTimes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final time = addController.scheduledTimes[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => addController.removeScheduleTime(index),
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: addController.notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Additional instructions or notes...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addScheduleTime() async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple[400]!,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
      addController.addScheduleTime(dateTime);
    }
  }

  void _onAddPressed() {
    if (_formKey.currentState!.validate()) {
      addController.saveMedicine();
    }
  }
}