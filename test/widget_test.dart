// widget_test.dart
// Basic smoke and widget tests for Virasat Flutter frontend

import 'package:flutter_test/flutter_test.dart';
import 'package:virasat_app/main.dart';
import 'package:virasat_app/models/heritage_site.dart';
import 'package:virasat_app/models/cultural_story.dart';
import 'package:virasat_app/models/chat_message.dart';
import 'package:virasat_app/utils/constants.dart';

void main() {
  testWidgets('VirasatApp smoke test: app boots and shows header', (WidgetTester tester) async {
    await tester.pumpWidget(const VirasatApp());
    await tester.pumpAndSettle();

    // Verify main brand title is present
    expect(find.textContaining('VIRASAT'), findsWidgets);
    expect(find.textContaining('Smart India Hackathon 2026'), findsWidgets);
  });

  test('HeritageSite model JSON serialization test', () {
    final site = AppConstants.mockHeritageSites.first;
    final json = site.toJson();
    final reconstructed = HeritageSite.fromJson(json);

    expect(reconstructed.id, site.id);
    expect(reconstructed.name, site.name);
    expect(reconstructed.isUnesco, true);
  });

  test('CulturalStory model JSON serialization test', () {
    final story = AppConstants.mockCulturalStories.first;
    final json = story.toJson();
    final reconstructed = CulturalStory.fromJson(json);

    expect(reconstructed.id, story.id);
    expect(reconstructed.title, story.title);
  });

  test('ChatMessage model serialization test', () {
    final msg = ChatMessage(
      id: 'test_1',
      text: 'Tell me about Taj Mahal',
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    final json = msg.toJson();
    final reconstructed = ChatMessage.fromJson(json);

    expect(reconstructed.text, 'Tell me about Taj Mahal');
    expect(reconstructed.sender, MessageSender.user);
  });
}
