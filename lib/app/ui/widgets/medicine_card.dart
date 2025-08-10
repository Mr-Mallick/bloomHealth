import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/medicine_model.dart';
import '../../utils/responsive_utils.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onDelete;
  final Function(bool)? onToggle;
  final bool showSchedule;

  const MedicineCard({
    Key? key,
    required this.medicine,
    this.onDelete,
    this.onToggle,
    this.showSchedule = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: ResponsiveUtils.cardMargin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          minHeight: ResponsiveUtils.medicineCardHeight,
        ),
        padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: medicine.isActive ? Colors.white : Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getMedicineTypeIcon(medicine.type),
                  style: TextStyle(fontSize: ResponsiveUtils.isSmallScreen ? 28 : 32),
                ),
                SizedBox(width: ResponsiveUtils.cardPadding / 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.headingFontSize,
                          fontWeight: FontWeight.bold,
                          color: medicine.isActive ? Colors.purple[800] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        _getMedicineTypeName(medicine.type),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.captionFontSize,
                          color: medicine.isActive ? Colors.purple[600] : Colors.grey[500],
                        ),
                      ),
                      if (medicine.notes != null && medicine.notes!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            medicine.notes!,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.captionFontSize,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Responsive action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onToggle != null)
                      Switch(
                        value: medicine.isActive,
                        onChanged: onToggle,
                        activeColor: Colors.purple[400],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete, 
                          color: Colors.red, 
                          size: ResponsiveUtils.iconSize,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ],
            ),
            
            // Schedule section
            if (showSchedule && medicine.scheduledTimes.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: ResponsiveUtils.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule:',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.captionFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple[700],
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.cardPadding / 4),
                    Wrap(
                      spacing: ResponsiveUtils.gridSpacing / 2,
                      runSpacing: ResponsiveUtils.gridSpacing / 2,
                      children: medicine.scheduledTimes.map((time) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.cardPadding / 2,
                            vertical: ResponsiveUtils.cardPadding / 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.captionFontSize,
                              color: Colors.purple[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getMedicineTypeIcon(MedicineType type) {
    switch (type) {
      case MedicineType.tablet:
        return '💊';
      case MedicineType.syrup:
        return '🧴';
      case MedicineType.drops:
        return '💧';
      case MedicineType.injection:
        return '💉';
      case MedicineType.capsule:
        return '💊';
    }
  }

  String _getMedicineTypeName(MedicineType type) {
    switch (type) {
      case MedicineType.tablet:
        return 'Tablet';
      case MedicineType.syrup:
        return 'Syrup';
      case MedicineType.drops:
        return 'Drops';
      case MedicineType.injection:
        return 'Injection';
      case MedicineType.capsule:
        return 'Capsule';
    }
  }
}