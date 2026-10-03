// chatbot_screen.dart
// Conversational AI Heritage Assistant ("Virasat Saathi")
// Guides visitors with monument history, architecture, and cultural stories

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'heritage_detail_screen.dart';
import 'voice_assistant_screen.dart';

class ChatbotScreen extends StatefulWidget {
  final String? initialQuery;
  final String? siteContext;

  const ChatbotScreen({
    super.key,
    this.initialQuery,
    this.siteContext,
  });

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  bool _isAITyping = false;
  String _activeLanguage = 'en';

  @override
  void initState() {
    super.initState();
    // Initial welcome message from Virasat Saathi
    _messages.add(
      ChatMessage(
        id: 'msg_welcome',
        text: 'नमस्ते! I am Virasat Saathi, your AI Cultural Heritage Guide. '
            'I can explain historical monuments, ancient Indian architecture, temple science, and travel itineraries across India. '
            'How can I guide your journey today?',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        suggestedActions: [
          'Tell me about Hampi',
          'Architecture of Konark Sun Temple',
          'Monolithic Kailash Temple mystery',
          'Mughal vs Rajput architecture',
        ],
      ),
    );

    // If an initial query was passed (e.g. from Detail Screen)
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    _textController.clear();

    // 1. Add user message
    final userMsg = ChatMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      text: query,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isAITyping = true;
    });
    _scrollToBottom();

    // 2. Fetch AI response via ApiService
    final aiResponse = await _apiService.sendChatQuery(
      query,
      language: _activeLanguage,
      siteContext: widget.siteContext,
    );

    if (mounted) {
      setState(() {
        _messages.add(aiResponse);
        _isAITyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryCrimson.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: AppTheme.primaryCrimson, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Virasat Saathi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('AI Heritage Guide • Online', style: TextStyle(fontSize: 11, color: AppTheme.emeraldHeritage)),
              ],
            ),
          ],
        ),
        actions: [
          // Voice Assistant Quick Jump
          IconButton(
            icon: const Icon(Icons.mic, color: AppTheme.primaryCrimson),
            tooltip: 'Open Voice Assistant',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoiceAssistantScreen()),
              );
            },
          ),
          // Clear History
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Chat',
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    id: 'msg_reset',
                    text: 'Chat history cleared. How may I help you explore India\'s heritage?',
                    sender: MessageSender.ai,
                    timestamp: DateTime.now(),
                    suggestedActions: AppConstants.sampleChatPrompts.take(3).toList(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 900 : double.infinity),
          child: Column(
            children: [
              // Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24.0 : 14.0,
                    vertical: 16.0,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildMessageBubble(msg, isDark);
                  },
                ),
              ),

              // AI Typing Indicator
              if (_isAITyping)
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryCrimson),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Virasat Saathi is thinking...',
                              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Input Bar
              _buildInputArea(isDark),
            ],
          ),
        ),
      ),
    );
  }

  // Chat Bubble Widget
  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    final isUser = msg.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryCrimson,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.temple_hindu, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppTheme.primaryCrimson
                        : (isDark ? AppTheme.cardSurfaceDark : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: isUser
                              ? Colors.white
                              : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary),
                        ),
                      ),
                      // Related Site Card Preview
                      if (msg.relatedSiteId != null && msg.relatedSiteName != null) ...[
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HeritageDetailScreen(siteId: msg.relatedSiteId!),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.peacockTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.peacockTeal.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.account_balance, size: 16, color: AppTheme.peacockTeal),
                                const SizedBox(width: 8),
                                Text(
                                  'Explore ${msg.relatedSiteName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.peacockTeal,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.peacockTeal),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.peacockTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 16),
                ),
              ],
            ],
          ),

          // Suggested Actions Chips underneath AI response
          if (!isUser && msg.suggestedActions != null && msg.suggestedActions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: msg.suggestedActions!.map((suggestion) {
                  return ActionChip(
                    label: Text(suggestion),
                    labelStyle: const TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.primaryCrimson,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: AppTheme.primaryCrimson.withOpacity(0.06),
                    side: BorderSide(color: AppTheme.primaryCrimson.withOpacity(0.2)),
                    onPressed: () => _handleSendMessage(suggestion),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Bottom Input Box
  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Voice Assistant shortcut button
            IconButton(
              icon: const Icon(Icons.mic_none, color: AppTheme.saffronWarm),
              tooltip: 'Speak query with Voice Assistant',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VoiceAssistantScreen()),
                );
              },
            ),

            // Text Input
            Expanded(
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.send,
                onSubmitted: _handleSendMessage,
                decoration: InputDecoration(
                  hintText: 'Ask about temples, forts, legends, history...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  isDense: true,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send Button
            Material(
              color: AppTheme.primaryCrimson,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _handleSendMessage(_textController.text),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
