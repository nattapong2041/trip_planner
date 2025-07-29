import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/utils/time_slot_utils.dart';
import 'package:trip_planner/models/activity.dart';

void main() {
  group('TimeSlotUtils', () {
    test('formatTimeSlot should format time correctly', () {
      expect(TimeSlotUtils.formatTimeSlot('09:00'), '9:00 AM');
      expect(TimeSlotUtils.formatTimeSlot('13:30'), '1:30 PM');
      expect(TimeSlotUtils.formatTimeSlot('00:00'), '12:00 AM');
      expect(TimeSlotUtils.formatTimeSlot('12:00'), '12:00 PM');
      expect(TimeSlotUtils.formatTimeSlot('23:59'), '11:59 PM');
    });

    test('isValidTimeSlot should validate time format', () {
      expect(TimeSlotUtils.isValidTimeSlot('09:00'), true);
      expect(TimeSlotUtils.isValidTimeSlot('23:59'), true);
      expect(TimeSlotUtils.isValidTimeSlot('00:00'), true);
      expect(TimeSlotUtils.isValidTimeSlot('24:00'), false);
      expect(TimeSlotUtils.isValidTimeSlot('09:60'), false);
      expect(TimeSlotUtils.isValidTimeSlot('9:00'), true);
      expect(TimeSlotUtils.isValidTimeSlot('invalid'), false);
    });

    test('timeOfDayToTimeSlot should convert TimeOfDay to string', () {
      expect(TimeSlotUtils.timeOfDayToTimeSlot(const TimeOfDay(hour: 9, minute: 0)), '09:00');
      expect(TimeSlotUtils.timeOfDayToTimeSlot(const TimeOfDay(hour: 13, minute: 30)), '13:30');
      expect(TimeSlotUtils.timeOfDayToTimeSlot(const TimeOfDay(hour: 0, minute: 0)), '00:00');
    });

    test('timeSlotToTimeOfDay should convert string to TimeOfDay', () {
      final result1 = TimeSlotUtils.timeSlotToTimeOfDay('09:00');
      expect(result1?.hour, 9);
      expect(result1?.minute, 0);

      final result2 = TimeSlotUtils.timeSlotToTimeOfDay('13:30');
      expect(result2?.hour, 13);
      expect(result2?.minute, 30);

      expect(TimeSlotUtils.timeSlotToTimeOfDay('invalid'), null);
      expect(TimeSlotUtils.timeSlotToTimeOfDay('25:00'), null);
    });

    test('sortActivitiesByTime should sort activities chronologically', () {
      final activities = [
        Activity(
          id: '1',
          tripId: 'trip1',
          place: 'Place 1',
          activityType: 'Type 1',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '14:00',
        ),
        Activity(
          id: '2',
          tripId: 'trip1',
          place: 'Place 2',
          activityType: 'Type 2',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '09:00',
        ),
        Activity(
          id: '3',
          tripId: 'trip1',
          place: 'Place 3',
          activityType: 'Type 3',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '11:30',
        ),
      ];

      final sorted = TimeSlotUtils.sortActivitiesByTime(activities);
      expect(sorted[0].timeSlot, '09:00');
      expect(sorted[1].timeSlot, '11:30');
      expect(sorted[2].timeSlot, '14:00');
    });

    test('separateActivitiesByTime should separate timed and untimed activities', () {
      final activities = [
        Activity(
          id: '1',
          tripId: 'trip1',
          place: 'Place 1',
          activityType: 'Type 1',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '14:00',
        ),
        Activity(
          id: '2',
          tripId: 'trip1',
          place: 'Place 2',
          activityType: 'Type 2',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: null,
        ),
        Activity(
          id: '3',
          tripId: 'trip1',
          place: 'Place 3',
          activityType: 'Type 3',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '09:00',
        ),
      ];

      final result = TimeSlotUtils.separateActivitiesByTime(activities);
      expect(result['timed']?.length, 2);
      expect(result['untimed']?.length, 1);
      expect(result['timed']?[0].timeSlot, '09:00'); // Should be sorted
      expect(result['timed']?[1].timeSlot, '14:00');
      expect(result['untimed']?[0].timeSlot, null);
    });

    test('generateSuggestedTimeSlots should return available slots', () {
      final existingActivities = [
        Activity(
          id: '1',
          tripId: 'trip1',
          place: 'Place 1',
          activityType: 'Type 1',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '09:00',
        ),
        Activity(
          id: '2',
          tripId: 'trip1',
          place: 'Place 2',
          activityType: 'Type 2',
          createdBy: 'user1',
          createdAt: DateTime.now(),
          timeSlot: '14:00',
        ),
      ];

      final suggestions = TimeSlotUtils.generateSuggestedTimeSlots(existingActivities);
      expect(suggestions.contains('09:00'), false);
      expect(suggestions.contains('14:00'), false);
      expect(suggestions.contains('10:00'), true);
      expect(suggestions.contains('15:00'), true);
    });
  });
}