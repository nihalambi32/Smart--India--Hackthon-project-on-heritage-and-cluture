// voice_assistant_screen.dart
// Bilingual AI Voice Assistant ("Virasat Vani" – विरासत वाणी)
// Provides hands-free audio guidance in Hindi and English

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'heritage_detail_screen.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  String _selectedLanguage = 'en'; // 'en' or 'hi'
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isPlayingResponse = false;

  String _currentQuery = '';
  String _currentResponse = '';
  String? _recognizedSiteId;
  String? _recognizedSiteTitle;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Initial default greeting
    _currentResponse =
        'नमस्ते! I am Virasat Vani. Tap the microphone and ask any question in English or हिंदी.';
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _processQuery(String queryText) async {
    setState(() {
      _currentQuery = queryText;
      _isListening = false;
      _isProcessing = true;
      _isPlayingResponse = false;
    });

    final result = await _apiService.processVoiceQuery(
      queryText,
      language: _selectedLanguage,
    );

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isPlayingResponse = true;
        _currentResponse = result['response_text'] as String? ?? '';
        _recognizedSiteId = result['site_id'] as String?;
        _recognizedSiteTitle = result['site_title'] as String?;
      });
    }
  }

  void _toggleListening() {
    if (_isListening) {
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _isPlayingResponse = false;
        _currentQuery = _selectedLanguage == 'hi'
            ? 'सुन रहा हूँ... (Listening in Hindi)'
            : 'Listening for voice input...';
      });

      // Simulate capturing speech after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isListening) {
          final sample = _selectedLanguage == 'hi'
              ? 'ताजमहल का इतिहास और वास्तुकला'
              : 'Tell me the history of Taj Mahal in Agra';
          _processQuery(sample);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prompts = _selectedLanguage == 'hi'
        ? AppConstants.sampleVoicePromptsHi
        : AppConstants.sampleVoicePromptsEn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilingual Voice Assistant'),
        actions: [
          // Language Switcher (English / हिन्दी)
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _selectedLanguage = 'en'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedLanguage == 'en' ? AppTheme.primaryCrimson : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'English',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _selectedLanguage == 'en' ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _selectedLanguage = 'hi'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedLanguage == 'hi' ? AppTheme.primaryCrimson : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'हिन्दी',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _selectedLanguage == 'hi' ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32.0 : 20.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                // Header Title & Tagline
                const Text(
                  'VIRASAT VANI • विरासत वाणी',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                    letterSpacing: 1,
                    color: AppTheme.primaryCrimson,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedLanguage == 'hi'
                      ? 'भारतीय सांस्कृतिक विरासत के लिए द्विभाषी वॉयस गाइड'
                      : 'AI Bilingual Audio Guide for Indian Cultural Heritage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),

                const SizedBox(height: 36),

                // Animated Pulsing Microphone Visualizer
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final scale = _isListening ? _pulseAnimation.value : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _isListening
                                  ? [const Color(0xFFE26D28), const Color(0xFFD4AF37)]
                                  : [AppTheme.primaryCrimson, AppTheme.primaryLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_isListening ? AppTheme.saffronWarm : AppTheme.primaryCrimson)
                                    .withOpacity(0.4),
                                blurRadius: _isListening ? 30 : 15,
                                spreadRadius: _isListening ? 8 : 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _toggleListening,
                              child: Center(
                                child: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Listening Status Text
                Text(
                  _isListening
                      ? (_selectedLanguage == 'hi' ? 'बोलिए, सुन रहे हैं...' : 'Listening... Speak now')
                      : (_selectedLanguage == 'hi'
                          ? 'बोलने के लिए माइक दबाएं'
                          : 'Tap microphone to speak'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isListening ? AppTheme.saffronWarm : AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                // Spoken Query & AI Response Display Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardSurfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentQuery.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.record_voice_over, size: 16, color: AppTheme.saffronWarm),
                            const SizedBox(width: 8),
                            const Text(
                              'Recognized Voice Query:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '“$_currentQuery”',
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(height: 24),
                      ],

                      // AI Response
                      Row(
                        children: [
                          const Icon(Icons.volume_up, size: 18, color: AppTheme.primaryCrimson),
                          const SizedBox(width: 8),
                          const Text(
                            'Virasat Vani Audio Response',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryCrimson,
                            ),
                          ),
                          const Spacer(),
                          if (_isPlayingResponse)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.emeraldHeritage.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.graphic_eq, size: 14, color: AppTheme.emeraldHeritage),
                                  SizedBox(width: 4),
                                  Text(
                                    'Playing',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.emeraldHeritage,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (_isProcessing)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: CircularProgressIndicator(color: AppTheme.primaryCrimson),
                          ),
                        )
                      else
                        Text(
                          _currentResponse,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            fontFamily: 'serif',
                            color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                          ),
                        ),

                      // Recognized Heritage Site Action
                      if (_recognizedSiteId != null) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HeritageDetailScreen(siteId: _recognizedSiteId!),
                              ),
                            );
                          },
                          icon: const Icon(Icons.account_balance, size: 16),
                          label: Text('Open ${_recognizedSiteTitle ?? "Heritage Site"} Details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCrimson,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Try Sample Voice Queries Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _selectedLanguage == 'hi'
                      ? 'ये प्रश्न पूछकर आज़माएं (Sample Queries):'
                      : 'Try Asking These Sample Voice Queries:',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // List of sample prompts
                ...prompts.map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _processQuery(prompt['query']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.peacockTeal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow, size: 16, color: AppTheme.peacockTeal),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prompt['title']!,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '“${prompt['query']!}”',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.mic, size: 16, color: AppTheme.primaryCrimson),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
