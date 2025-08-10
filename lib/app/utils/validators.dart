class Validators {
  static String? validateMedicineName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Medicine name is required';
    }
    if (value.trim().length < 2) {
      return 'Medicine name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Medicine name must be less than 50 characters';
    }
    return null;
  }

  static String? validateFluidAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (amount > 2000) {
      return 'Amount seems too high for a single intake';
    }
    
    return null;
  }

    static String? validateCycleLength(int? value) {
    if (value == null) {
      return 'Cycle length is required';
    }
    
    if (value < 21 || value > 40) {
      return 'Cycle length should be between 21 and 40 days';
    }
    
    return null;
  }

  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return 'Start date is required';
    }
    
    if (endDate == null) {
      return 'End date is required';
    }
    
    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }
    
    final difference = endDate.difference(startDate).inDays;
    if (difference > 10) {
      return 'Period duration seems too long (max 10 days)';
    }
    
    return null;
  }

   static String? validateFutureDate(DateTime? date) {
    if (date == null) return null;
    
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date cannot be in the future';
    }
    
    // Check if date is too far in the past (more than 2 years)
    final twoYearsAgo = now.subtract(const Duration(days: 730));
    if (date.isBefore(twoYearsAgo)) {
      return 'Date is too far in the past';
    }
    
    return null;
  }

  static String? validateNotes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Notes are optional
    }
    
    if (value.trim().length > 200) {
      return 'Notes must be less than 200 characters';
    }
    
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone number might be optional
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? validateDailyGoal(double? value) {
    if (value == null) {
      return 'Daily goal is required';
    }
    
    if (value < 500) {
      return 'Daily goal should be at least 500ml';
    }
    
    if (value > 5000) {
      return 'Daily goal seems too high (max 5L)';
    }
    
    return null;
  }

  static String? validateReminderInterval(int? value) {
    if (value == null) {
      return 'Reminder interval is required';
    }
    
    if (value < 15) {
      return 'Minimum interval is 15 minutes';
    }
    
    if (value > 240) {
      return 'Maximum interval is 4 hours';
    }
    
    return null;
  }

  static bool isValidTimeRange(DateTime startTime, DateTime endTime) {
    return endTime.isAfter(startTime);
  }
}