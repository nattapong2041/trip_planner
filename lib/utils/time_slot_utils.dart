import 'package:flutter/material.dart';
import '../models/activity.dart';

/// Utility class for handling time slot operations and formatting
class TimeSlotUtils {
  /// Formats a time slot string (e.g., "09:00") to a user-friendly format
  static String formatTimeSlot(String timeSlot) {
    try {
      // Parse the time slot string (expected format: "HH:mm")
      final parts = timeSlot.split(':');
      if (parts.length != 2) return timeSlot;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      // Format to 12-hour format with AM/PM
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final displayMinute = minute.toString().padLeft(2, '0');
      
      return '$displayHour:$displayMinute $period';
    } catch (e) {
      // Return original string if parsing fails
      return timeSlot;
    }
  }
  
  /// Sorts activities by their time slots in chronological order
  static List<Activity> sortActivitiesByTime(List<Activity> activities) {
    final timedActivities = activities.where((a) => a.timeSlot != null).toList();
    
    timedActivities.sort((a, b) {
      final timeA = a.timeSlot!;
      final timeB = b.timeSlot!;
      
      try {
        // Parse time slots for comparison
        final partsA = timeA.split(':');
        final partsB = timeB.split(':');
        
        final hourA = int.parse(partsA[0]);
        final minuteA = int.parse(partsA[1]);
        final hourB = int.parse(partsB[0]);
        final minuteB = int.parse(partsB[1]);
        
        // Compare hours first, then minutes
        if (hourA != hourB) {
          return hourA.compareTo(hourB);
        }
        return minuteA.compareTo(minuteB);
      } catch (e) {
        // If parsing fails, fall back to string comparison
        return timeA.compareTo(timeB);
      }
    });
    
    return timedActivities;
  }
  
  /// Validates if a time slot string is in the correct format (HH:mm)
  static bool isValidTimeSlot(String timeSlot) {
    final regex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(timeSlot);
  }
  
  /// Converts TimeOfDay to time slot string format (HH:mm)
  static String timeOfDayToTimeSlot(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  /// Converts time slot string to TimeOfDay
  static TimeOfDay? timeSlotToTimeOfDay(String timeSlot) {
    try {
      final parts = timeSlot.split(':');
      if (parts.length != 2) return null;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }
      
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
  
  /// Separates activities into timed and untimed lists
  static Map<String, List<Activity>> separateActivitiesByTime(List<Activity> activities) {
    final timed = <Activity>[];
    final untimed = <Activity>[];
    
    for (final activity in activities) {
      if (activity.timeSlot != null && activity.timeSlot!.isNotEmpty) {
        timed.add(activity);
      } else {
        untimed.add(activity);
      }
    }
    
    return {
      'timed': sortActivitiesByTime(timed),
      'untimed': untimed,
    };
  }
  
  /// Generates suggested time slots based on existing activities
  static List<String> generateSuggestedTimeSlots(List<Activity> existingActivities) {
    final existingTimes = existingActivities
        .where((a) => a.timeSlot != null)
        .map((a) => a.timeSlot!)
        .toSet();
    
    // Common time slots throughout the day
    final commonSlots = [
      '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
      '14:00', '15:00', '16:00', '17:00', '18:00', '19:00',
      '20:00', '21:00'
    ];
    
    // Return slots that aren't already used
    return commonSlots.where((slot) => !existingTimes.contains(slot)).toList();
  }
}