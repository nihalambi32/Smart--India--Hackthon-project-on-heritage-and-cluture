// navigation_bar.dart
// Responsive navigation widget supporting both mobile bottom-bar and web top-header navigation
// Allows seamless switching across all 7 frontend screens

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class VirasatAdaptiveNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final Widget body;

  const VirasatAdaptiveNavigation({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDesktop) {
      // Desktop / Web Top-Header Layout
      return Scaffold(
        body: Column(
          children: [
            _buildWebHeader(context, isDark),
            Expanded(child: body),
          ],
        ),
      );
    } else {
      // Mobile / Tablet Bottom Navigation Layout
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex.clamp(0, 5),
          onDestinationSelected: onIndexChanged,
          backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
          indicatorColor: AppTheme.primaryCrimson.withOpacity(0.15),
          elevation: 4,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppTheme.primaryCrimson),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance, color: AppTheme.primaryCrimson),
              label: 'Locations',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: AppTheme.primaryCrimson),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories, color: AppTheme.primaryCrimson),
              label: 'Stories',
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined),
              selectedIcon: Icon(Icons.smart_toy, color: AppTheme.primaryCrimson),
              label: 'AI Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.mic_none_outlined),
              selectedIcon: Icon(Icons.mic, color: AppTheme.primaryCrimson),
              label: 'Voice',
            ),
          ],
        ),
      );
    }
  }

  Widget _buildWebHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Logo & Branding
          InkWell(
            onTap: () => onIndexChanged(0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryCrimson, AppTheme.saffronWarm],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryCrimson.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.temple_hindu, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppConstants.appName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                            color: AppTheme.primaryCrimson,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '• विरासत',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.saffronWarm,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Smart India Hackathon 2026',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 32),

          // Nav Items
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavItem(0, 'Home', Icons.home),
                _buildNavItem(1, 'Heritage Sites', Icons.account_balance),
                _buildNavItem(2, 'Interactive Map', Icons.map),
                _buildNavItem(3, 'Cultural Stories', Icons.auto_stories),
                _buildNavItem(4, 'AI Chatbot', Icons.smart_toy),
                _buildNavItem(5, 'Voice Assistant', Icons.mic),
              ],
            ),
          ),

          // Team Badge / Hackathon Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryCrimson.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryCrimson.withOpacity(0.2)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, size: 16, color: AppTheme.primaryCrimson),
                SizedBox(width: 6),
                Text(
                  'SIH Team Virasat',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryCrimson,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () => onIndexChanged(index),
        icon: Icon(
          icon,
          size: 17,
          color: isSelected ? AppTheme.primaryCrimson : AppTheme.textSecondary,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryCrimson : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13.5,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppTheme.primaryCrimson.withOpacity(0.08) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
