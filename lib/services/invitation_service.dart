import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

/// Service for handling user invitations and sharing
class InvitationService {
  static final Logger _logger = Logger();
  
  /// Generate an invitation message for a trip
  static String generateInvitationMessage({
    required String tripName,
    required String inviterName,
    String? appDownloadLink,
  }) {
    final downloadLink = appDownloadLink ?? 'https://your-app-store-link.com'; // Replace with actual link
    
    return '''
Hi! 👋

$inviterName has invited you to collaborate on the trip "$tripName" in our Trip Planner app!

To join and start planning together:
1. Download the Trip Planner app: $downloadLink
2. Sign up with your email address
3. Let $inviterName know you've signed up so they can add you as a collaborator

Looking forward to planning an amazing trip together! ✈️

Best regards,
The Trip Planner Team
''';
  }
  
  /// Copy invitation message to clipboard
  static Future<void> copyInvitationToClipboard({
    required String tripName,
    required String inviterName,
    String? appDownloadLink,
  }) async {
    try {
      final message = generateInvitationMessage(
        tripName: tripName,
        inviterName: inviterName,
        appDownloadLink: appDownloadLink,
      );
      
      await Clipboard.setData(ClipboardData(text: message));
      _logger.i('Invitation message copied to clipboard');
    } catch (e) {
      _logger.e('Error copying invitation to clipboard: $e');
      throw Exception('Failed to copy invitation message');
    }
  }
  
  /// Get a shareable invitation text
  static String getShareableInvitation({
    required String tripName,
    required String inviterName,
    String? appDownloadLink,
  }) {
    return generateInvitationMessage(
      tripName: tripName,
      inviterName: inviterName,
      appDownloadLink: appDownloadLink,
    );
  }
}