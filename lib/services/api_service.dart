// api_service.dart
// Service layer for communicating with backend APIs (FastAPI / Node.js)
// Separates API network communication completely from UI widgets.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/heritage_site.dart';
import '../models/cultural_story.dart';
import '../models/chat_message.dart';
import '../utils/constants.dart';

class ApiService {
  // Singleton pattern for application-wide service access
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String _baseUrl = AppConstants.apiBaseUrl;
  String get baseUrl => _baseUrl;

  void updateBaseUrl(String newUrl) {
    _baseUrl = newUrl;
  }

  // ==========================================
  // HERITAGE SITES API
  // ==========================================

  /// Fetches heritage sites with optional filters (category, search query, state)
  /// Ready to consume FastAPI endpoint: GET /api/heritage-sites?category=...&query=...
  Future<List<HeritageSite>> fetchHeritageSites({
    String? category,
    String? query,
    String? state,
  }) async {
    try {
      // Future live HTTP implementation:
      // final uri = Uri.parse('$_baseUrl/heritage-sites').replace(queryParameters: {
      //   if (category != null && category != 'All Categories') 'category': category,
      //   if (query != null && query.isNotEmpty) 'q': query,
      //   if (state != null && state != 'All States') 'state': state,
      // });
      // final response = await http.get(uri);
      // if (response.statusCode == 200) { ... parse json ... }

      // UI Development Fallback with local filtering
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate network latency
      List<HeritageSite> sites = List.from(AppConstants.mockHeritageSites);

      if (category != null && category != 'All Categories' && category != 'All') {
        sites = sites.where((s) => s.category.toLowerCase() == category.toLowerCase() ||
            s.tags.any((t) => t.toLowerCase().contains(category.toLowerCase()))).toList();
      }

      if (state != null && state != 'All States') {
        sites = sites.where((s) => s.state.toLowerCase() == state.toLowerCase()).toList();
      }

      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase().trim();
        sites = sites.where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.hindiName.contains(q) ||
              s.location.toLowerCase().contains(q) ||
              s.state.toLowerCase().contains(q) ||
              s.era.toLowerCase().contains(q) ||
              s.tags.any((t) => t.toLowerCase().contains(q));
        }).toList();
      }

      return sites;
    } catch (e) {
      debugPrint('Error fetching heritage sites: $e');
      return AppConstants.mockHeritageSites;
    }
  }

  /// Fetches a specific heritage site by its ID
  /// Ready to consume FastAPI endpoint: GET /api/heritage-sites/{id}
  Future<HeritageSite?> fetchHeritageSiteById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return AppConstants.mockHeritageSites.firstWhere(
        (site) => site.id == id,
        orElse: () => AppConstants.mockHeritageSites.first,
      );
    } catch (e) {
      debugPrint('Error fetching heritage site by ID: $e');
      return null;
    }
  }

  /// Fetches featured heritage sites for the home showcase
  Future<List<HeritageSite>> fetchFeaturedSites() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return AppConstants.mockHeritageSites.take(4).toList();
  }

  /// Fetches nearby heritage sites using PostGIS coordinates
  /// Ready to consume FastAPI endpoint: GET /api/geo/nearby?lat=...&lng=...&radius=...
  Future<List<HeritageSite>> fetchNearbySites(
    double latitude,
    double longitude, {
    double radiusKm = 200,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return AppConstants.mockHeritageSites;
  }

  // ==========================================
  // CULTURAL STORIES API
  // ==========================================

  /// Fetches cultural stories with optional category filtering
  /// Ready to consume FastAPI endpoint: GET /api/cultural-stories?category=...
  Future<List<CulturalStory>> fetchCulturalStories({String? category}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      List<CulturalStory> stories = List.from(AppConstants.mockCulturalStories);

      if (category != null && category != 'All' && category != 'All Stories') {
        stories = stories.where((story) {
          return story.category.toLowerCase() == category.toLowerCase() ||
              story.tags.any((t) => t.toLowerCase().contains(category.toLowerCase()));
        }).toList();
      }

      return stories;
    } catch (e) {
      debugPrint('Error fetching cultural stories: $e');
      return AppConstants.mockCulturalStories;
    }
  }

  /// Fetches a single cultural story by ID
  Future<CulturalStory?> fetchStoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return AppConstants.mockCulturalStories.firstWhere((story) => story.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // AI CHATBOT & VOICE ASSISTANT API
  // ==========================================

  /// Sends a message to the AI Chatbot backend ("Virasat Saathi")
  /// Ready to consume FastAPI endpoint: POST /api/ai/chatbot
  Future<ChatMessage> sendChatQuery(
    String userMessage, {
    String language = 'en',
    String? siteContext,
  }) async {
    try {
      // Simulate response latency from backend LLM
      await Future.delayed(const Duration(milliseconds: 600));

      final lower = userMessage.toLowerCase();
      String replyText;
      List<String>? suggestions;
      String? relatedSiteId;
      String? relatedSiteName;

      if (lower.contains('hampi') || lower.contains('विजयनगर') || lower.contains('हम्पी')) {
        relatedSiteId = 'site-2';
        relatedSiteName = 'Hampi Monuments';
        replyText =
            'Hampi was the majestic capital of the Vijayanagara Empire from 1336 to 1565. '
            'Its most celebrated marvels include the Vittala Temple Stone Chariot, the 56 Musical Pillars '
            'that resonate like classical instruments, and the grand Virupaksha Temple. '
            'In medieval times, European and Persian travelers wrote that diamonds and pearls were sold by the kilogram in Hampi\'s bazaars!';
        suggestions = ['Tell me about musical pillars', 'How to reach Hampi?', 'Show Hampi on Map'];
      } else if (lower.contains('taj') || lower.contains('महल') || lower.contains('ताजमहल')) {
        relatedSiteId = 'site-1';
        relatedSiteName = 'Taj Mahal';
        replyText =
            'The Taj Mahal in Agra was commissioned in 1631 by Mughal Emperor Shah Jahan for Mumtaz Mahal. '
            'Over 20,000 artisans crafted its pure Makrana marble and pietra dura inlay with lapis lazuli and jade. '
            'Notice how the four minarets tilt slightly outward—a deliberate architectural safety measure to protect the main dome during earthquakes!';
        suggestions = ['Visiting hours of Taj Mahal', 'Best time for photography', 'Show Taj Mahal details'];
      } else if (lower.contains('konark') || lower.contains('सूर्य') || lower.contains('कोणार्क')) {
        relatedSiteId = 'site-3';
        relatedSiteName = 'Konark Sun Temple';
        replyText =
            'The 13th-century Konark Sun Temple in Odisha is engineered as an immense stone chariot with 24 colossal wheels. '
            'Each wheel functions as an astronomical sundial accurate down to the minute, calculated by reading the shadows cast on the spokes!';
        suggestions = ['How do the sundials work?', 'Read Konark legends', 'Show Konark on Map'];
      } else if (lower.contains('ellora') || lower.contains('ajanta') || lower.contains('kailash') || lower.contains('एलोरा')) {
        relatedSiteId = 'site-5';
        relatedSiteName = 'Ajanta & Ellora Caves';
        replyText =
            'Cave 16 at Ellora—the Kailash Temple—is the largest monolithic rock excavation in the world! '
            'Ancient sculptors carved downwards from the mountain crest, chiseling away over 200,000 tonnes of basalt rock without scaffolding or joins.';
        suggestions = ['Read the Kailash Monolith story', 'Ajanta cave paintings info', 'Plan a visit to Ellora'];
      } else if (lower.contains('fort') || lower.contains('rajasthan') || lower.contains('amer') || lower.contains('किला')) {
        relatedSiteId = 'site-4';
        relatedSiteName = 'Amer Fort & Palace';
        replyText =
            'Rajasthan\'s hill forts represent brilliant Rajput defense architecture and opulent courtyards. '
            'Amer Fort is especially famed for its Sheesh Mahal, where convex Belgian mirrors allow a single candle to light up the whole hall like a starry night!';
        suggestions = ['View Sheesh Mahal details', 'Explore Rajasthan Forts', 'Golden Triangle Trail'];
      } else if (lower.contains('dravidian') || lower.contains('temple') || lower.contains('architecture')) {
        replyText =
            'Indian temple architecture features two primary classical styles:\n'
            '• Nagara Style (Northern): Pyramidal curvilinear spires (Shikharas) rising gradually.\n'
            '• Dravidian Style (Southern): Tiered pyramid towers (Vimanas), ornate gateway towers (Gopurams), and pillared mandapas as seen at Brihadisvara and Meenakshi temples.\n'
            '• Vesara Style (Central/Deccan): A harmonious fusion perfected by the Chalukyas and Hoysalas.';
        suggestions = ['Brihadisvara Temple details', 'Hampi architecture', 'Explore Ancient Temples'];
      } else {
        replyText =
            'Namaste! Welcome to Virasat AI Assistant. I can guide you through India\'s 42+ UNESCO World Heritage sites, '
            'ancient temple science, hill forts, and forgotten cultural folklore. '
            'Ask me about any monument, architectural style, or travel itinerary!';
        suggestions = [
          'History of Hampi',
          'Taj Mahal architecture',
          'Konark Sundial mystery',
          'Kailash Temple at Ellora'
        ];
      }

      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: replyText,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        suggestedActions: suggestions,
        relatedSiteId: relatedSiteId,
        relatedSiteName: relatedSiteName,
      );
    } catch (e) {
      debugPrint('Error in AI Chat service: $e');
      return ChatMessage(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        text: 'I am experiencing a momentary connection delay with the AI service. Please try again or explore our catalog of heritage sites.',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Processes voice input for the Bilingual Voice Assistant ("Virasat Vani")
  /// Ready to consume FastAPI endpoint: POST /api/ai/voice-assistant
  Future<Map<String, dynamic>> processVoiceQuery(
    String transcript, {
    String language = 'en',
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final isHindi = language == 'hi' ||
        transcript.contains('ताज') ||
        transcript.contains('हम्पी') ||
        transcript.contains('किला') ||
        transcript.contains('मंदिर');

    String responseText;
    String siteId = 'site-1';
    String siteTitle = 'Taj Mahal';

    if (transcript.toLowerCase().contains('hampi') || transcript.contains('हम्पी')) {
      siteId = 'site-2';
      siteTitle = 'Hampi Monuments';
      responseText = isHindi
          ? 'हम्पी कर्नाटक में तुंगभद्रा नदी के तट पर स्थित विजयनगर साम्राज्य की भव्य राजधानी थी। यहाँ का पत्थर का रथ और 56 संगीतमय स्तंभ वास्तुकला के बेजोड़ उदाहरण हैं।'
          : 'Hampi was the grand capital of the Vijayanagara Empire. It is renowned for the Vittala Temple Stone Chariot and the miraculous 56 musical stone pillars.';
    } else if (transcript.toLowerCase().contains('konark') || transcript.contains('कोणार्क')) {
      siteId = 'site-3';
      siteTitle = 'Konark Sun Temple';
      responseText = isHindi
          ? 'कोणार्क का सूर्य मंदिर 13वीं शताब्दी में राजा नरसिंहदेव प्रथम द्वारा बनवाया गया था। इसके 24 नक्काशीदार पहिये सूर्य की छाया से सटीक समय बताते हैं।'
          : 'The Konark Sun Temple in Odisha was conceived as a 24-wheeled colossal chariot for Surya. The wheels serve as accurate solar sundials.';
    } else if (transcript.toLowerCase().contains('amer') || transcript.contains('राजस्थान') || transcript.contains('किला')) {
      siteId = 'site-4';
      siteTitle = 'Amer Fort';
      responseText = isHindi
          ? 'आमेर का किला जयपुर, राजस्थान में स्थित एक ऐतिहासिक धरोहर है। इसका शीश महल दुनिया भर में अपनी अनूठी शीशे की कारीगरी के लिए प्रसिद्ध है।'
          : 'Amer Fort in Jaipur, Rajasthan is a UNESCO Hill Fort famed for its majestic Rajput architecture and the breathtaking Sheesh Mahal.';
    } else {
      siteId = 'site-1';
      siteTitle = 'Taj Mahal';
      responseText = isHindi
          ? 'ताजमहल भारत के उत्तर प्रदेश के आगरा में स्थित सफेद संगमरमर का एक विश्व प्रसिद्ध मकबरा है, जिसे यूनेस्को विश्व धरोहर का दर्जा प्राप्त है।'
          : 'The Taj Mahal is a UNESCO World Heritage monument in Agra, celebrated globally for its pure white Makrana marble and magnificent symmetry.';
    }

    return {
      'recognized_text': transcript,
      'response_text': responseText,
      'language': isHindi ? 'hi' : 'en',
      'site_id': siteId,
      'site_title': siteTitle,
      'audio_duration_seconds': 6,
    };
  }
}
