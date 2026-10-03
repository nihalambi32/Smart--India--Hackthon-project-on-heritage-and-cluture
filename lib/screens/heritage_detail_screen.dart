// heritage_detail_screen.dart
// In-depth detail screen for a cultural heritage site
// Displays historical background, architectural highlights, audio guide player, and geo-info

import 'package:flutter/material.dart';
import '../models/heritage_site.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'chatbot_screen.dart';
import 'map_screen.dart';

class HeritageDetailScreen extends StatefulWidget {
  final String siteId;

  const HeritageDetailScreen({super.key, required this.siteId});

  @override
  State<HeritageDetailScreen> createState() => _HeritageDetailScreenState();
}

class _HeritageDetailScreenState extends State<HeritageDetailScreen> {
  final ApiService _apiService = ApiService();
  HeritageSite? _site;
  bool _isLoading = true;

  // Audio Guide Player Simulation State
  bool _isPlayingAudio = false;
  double _audioProgress = 0.25;
  String _audioLanguage = 'en'; // 'en' or 'hi'
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() => _isLoading = true);
    final site = await _apiService.fetchHeritageSiteById(widget.siteId);
    if (mounted) {
      setState(() {
        _site = site;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primaryCrimson)),
      );
    }

    if (_site == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Site Not Found')),
        body: const Center(child: Text('Unable to load heritage site information.')),
      );
    }

    final site = _site!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Sliver App Bar with Hero Image
          SliverAppBar(
            expandedHeight: isDesktop ? 360 : 260,
            pinned: true,
            backgroundColor: AppTheme.primaryCrimson,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: _isBookmarked ? AppTheme.accentGold : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  setState(() => _isBookmarked = !_isBookmarked);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isBookmarked
                            ? 'Saved ${site.name} to bookmarks'
                            : 'Removed from bookmarks',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sharing ${site.name} — Virasat Heritage Platform'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    site.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.primaryCrimson,
                      child: const Center(
                        child: Icon(Icons.account_balance, size: 60, color: Colors.white70),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Title inside Hero
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (site.isUnesco)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'UNESCO WORLD HERITAGE SITE',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        Text(
                          site.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            shadows: [
                              Shadow(blurRadius: 8, color: Colors.black, offset: Offset(0, 2)),
                            ],
                          ),
                        ),
                        if (site.hindiName.isNotEmpty)
                          Text(
                            site.hindiName,
                            style: const TextStyle(
                              color: Color(0xFFFBE4D8),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Body Details
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 960 : double.infinity),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32.0 : 16.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location & Rating Header Bar
                      Row(
                        children: [
                          const Icon(Icons.place, color: AppTheme.primaryCrimson, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${site.location}, ${site.state}, India',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryCrimson,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3CD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 15, color: Color(0xFFB78103)),
                                const SizedBox(width: 4),
                                Text(
                                  '${site.rating} (${site.reviewsCount} reviews)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6B4E00),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Quick Stats Strip
                      _buildQuickFactsStrip(site, isDark),

                      const SizedBox(height: 24),

                      // Interactive Audio Guide Tour Widget
                      if (site.audioGuideAvailable) ...[
                        _buildAudioGuideWidget(site, isDark),
                        const SizedBox(height: 24),
                      ],

                      // Overview & Significance
                      const Text(
                        'Historical Significance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        site.description,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.6,
                          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        site.history,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.6,
                          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Architectural Marvels & Engineering
                      const Text(
                        'Architectural Highlights & Science',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        site.architecture,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.6,
                          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Highlight Bullets
                      ...site.highlights.map((highlight) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryCrimson.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: AppTheme.primaryCrimson,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  highlight,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Geo Location & Coordinates Preview
                      _buildLocationMapBox(context, site, isDark),

                      const SizedBox(height: 32),

                      // Action Buttons
                      _buildActionButtons(context, site),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Facts Strip
  Widget _buildQuickFactsStrip(HeritageSite site, bool isDark) {
    final facts = [
      {'label': 'Era', 'value': site.century, 'icon': Icons.history},
      {'label': 'Timing', 'value': site.visitingHours, 'icon': Icons.schedule},
      {'label': 'Entry', 'value': site.entryFee, 'icon': Icons.confirmation_number},
      {'label': 'Best Season', 'value': site.bestTimeToVisit, 'icon': Icons.wb_sunny},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardSurfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle),
      ),
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: facts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isWide ? 2.5 : 2.2,
            ),
            itemBuilder: (context, index) {
              final f = facts[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCrimson.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(f['icon'] as IconData, size: 18, color: AppTheme.primaryCrimson),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          f['label'] as String,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                        Text(
                          f['value'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Audio Guide Player Widget
  Widget _buildAudioGuideWidget(HeritageSite site, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF261D18), const Color(0xFF1F1713)]
              : [const Color(0xFFFFF7ED), const Color(0xFFFEF3C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCrimson,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.headphones, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Bilingual Audio Tour',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                    ),
                    Text(
                      'Narrated guide in Hindi & English • ${site.audioDurationMinutes} min',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              // Language Switcher Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _audioLanguage = 'en'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _audioLanguage == 'en' ? AppTheme.primaryCrimson : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'EN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _audioLanguage == 'en' ? Colors.white : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _audioLanguage = 'hi'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _audioLanguage == 'hi' ? AppTheme.primaryCrimson : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'हिन्दी',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _audioLanguage == 'hi' ? Colors.white : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Audio Slider & Controls
          Row(
            children: [
              IconButton(
                iconSize: 36,
                color: AppTheme.primaryCrimson,
                icon: Icon(_isPlayingAudio ? Icons.pause_circle_filled : Icons.play_circle_fill),
                onPressed: () {
                  setState(() => _isPlayingAudio = !_isPlayingAudio);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isPlayingAudio
                            ? 'Playing ${_audioLanguage == 'hi' ? 'हिंदी' : 'English'} Audio Guide for ${site.name}'
                            : 'Audio Guide Paused',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.primaryCrimson,
                    inactiveTrackColor: AppTheme.primaryCrimson.withOpacity(0.2),
                    thumbColor: AppTheme.primaryCrimson,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _audioProgress,
                    onChanged: (val) => setState(() => _audioProgress = val),
                  ),
                ),
              ),
              Text(
                '${(_audioProgress * site.audioDurationMinutes).toStringAsFixed(1)} / ${site.audioDurationMinutes}:00',
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Geo Location Preview Box
  Widget _buildLocationMapBox(BuildContext context, HeritageSite site, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardSurfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Geo-Tagged Coordinates',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                  ),
                  Text('PostGIS Compatible Location Metadata', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(selectedSiteId: site.id),
                    ),
                  );
                },
                icon: const Icon(Icons.map, size: 16),
                label: const Text('Open Map', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.peacockTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.peacockTeal.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.pin_drop, color: AppTheme.peacockTeal, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Latitude: ${site.latitude.toStringAsFixed(4)}° N  |  Longitude: ${site.longitude.toStringAsFixed(4)}° E',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.peacockTeal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Action Buttons
  Widget _buildActionButtons(BuildContext context, HeritageSite site) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatbotScreen(
                    initialQuery: 'Tell me about the history and architecture of ${site.name}',
                    siteContext: site.name,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.smart_toy, size: 18),
            label: const Text('Ask AI Guide'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryCrimson,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(selectedSiteId: site.id),
                ),
              );
            },
            icon: const Icon(Icons.explore, size: 18),
            label: const Text('Locate on Map'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
