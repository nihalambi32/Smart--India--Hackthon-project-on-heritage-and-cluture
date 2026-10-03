// chat_message.dart
// Model representing chat messages between user and AI Chatbot ("Virasat Saathi")
// Compatible with Fast-API / LLM response contracts

enum MessageSender { user, ai }

class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<String>? suggestedActions;
  final String? relatedSiteId;
  final String? relatedSiteName;
  final bool isVoiceResponse;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.suggestedActions,
    this.relatedSiteId,
    this.relatedSiteName,
    this.isVoiceResponse = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: json['text'] as String? ?? json['message'] as String? ?? '',
      sender: (json['sender'] == 'ai' || json['role'] == 'assistant')
          ? MessageSender.ai
          : MessageSender.user,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      suggestedActions: (json['suggested_actions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      relatedSiteId: json['related_site_id'] as String?,
      relatedSiteName: json['related_site_name'] as String?,
      isVoiceResponse: json['is_voice_response'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender == MessageSender.ai ? 'ai' : 'user',
      'timestamp': timestamp.toIso8601String(),
      'suggested_actions': suggestedActions,
      'related_site_id': relatedSiteId,
      'related_site_name': relatedSiteName,
      'is_voice_response': isVoiceResponse,
    };
  }
}
