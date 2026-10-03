// main.dart
// Entry point for Virasat – Roots & Radiance
// Smart India Hackathon 2026 | Team Virasat (SIH26197, G109)

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'widgets/navigation_bar.dart';
import 'screens/home_screen.dart';
import 'screens/heritage_locations_screen.dart';
import 'screens/heritage_detail_screen.dart';
import 'screens/map_screen.dart';
import 'screens/stories_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/voice_assistant_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VirasatApp());
}

class VirasatApp extends StatelessWidget {
  const VirasatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${AppConstants.appName} – ${AppConstants.appTagline} | SIH 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light warm heritage theme
      home: const MainNavigationShell(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/locations': (context) => const HeritageLocationsScreen(),
        '/map': (context) => const MapScreen(),
        '/stories': (context) => const StoriesScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/voice': (context) => const VoiceAssistantScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final siteId = settings.arguments as String? ?? 'site-1';
          return MaterialPageRoute(
            builder: (context) => HeritageDetailScreen(siteId: siteId),
          );
        }
        return null;
      },
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 6 Primary Navigation Destinations
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabChanged),
      const HeritageLocationsScreen(),
      const MapScreen(),
      const StoriesScreen(),
      const ChatbotScreen(),
      const VoiceAssistantScreen(),
    ];

    return VirasatAdaptiveNavigation(
      currentIndex: _currentIndex,
      onIndexChanged: _onTabChanged,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
    );
  }
}
