// home_screen.dart
// Main landing screen for Virasat – Roots & Radiance
// Showcases hero banner, category filters, featured heritage sites, circuits, and stories

import 'package:flutter/material.dart';
import '../models/heritage_site.dart';
import '../models/cultural_story.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/heritage_card.dart';
import '../widgets/story_card.dart';
import 'heritage_locations_screen.dart';
import 'heritage_detail_screen.dart';
import 'stories_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<HeritageSite> _featuredSites = [];
  List<CulturalStory> _stories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final sites = await _apiService.fetchFeaturedSites();
    final stories = await _apiService.fetchCulturalStories();
    if (mounted) {
      setState(() {
        _featuredSites = sites;
        _stories = stories;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeritageLocationsScreen(initialQuery: query.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryCrimson),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppTheme.primaryCrimson,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Cultural Banner
                    _buildHeroBanner(context, isDesktop),

                    // Main Content Container
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 48.0 : 16.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Quick Feature Modules
                          _buildQuickAccessModules(context, isDesktop),

                          const SizedBox(height: 36),

                          // 3. Featured Heritage Sites Section
                          _buildFeaturedSection(context, isDesktop, isDark),

                          const SizedBox(height: 36),

                          // 4. Heritage Trails & Circuits
                          _buildCircuitsSection(context, isDesktop, isDark),

                          const SizedBox(height: 36),

                          // 5. Cultural Story of the Day
                          _buildStorySection(context, isDesktop, isDark),

                          const SizedBox(height: 36),

                          // 6. Cultural Quote Banner
                          _buildCulturalQuoteBanner(isDark),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Hero Banner with Gradient & Cultural Motifs
  Widget _buildHeroBanner(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF5E1700),
            Color(0xFF8B2500),
            Color(0xFFB33927),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48.0 : 20.0,
        vertical: isDesktop ? 48.0 : 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hackathon Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, size: 14, color: AppTheme.accentGold),
                SizedBox(width: 6),
                Text(
                  'Smart India Hackathon 2026 • SIH26197',
                  style: TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Headline
          Text(
            'VIRASAT • विरासत',
            style: TextStyle(
              fontSize: isDesktop ? 44 : 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'serif',
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Roots & Radiance — Preserving India\'s Timeless Heritage',
            style: TextStyle(
              fontSize: isDesktop ? 18 : 15,
              color: const Color(0xFFFBE4D8),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 24),

          // Search Bar
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.search, color: AppTheme.primaryCrimson, size: 24),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _handleSearchSubmit,
                      decoration: const InputDecoration(
                        hintText: 'Search monuments, temples, forts, UNESCO sites...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        isDense: true,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleSearchSubmit(_searchController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryCrimson,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Feature Access Cards
  Widget _buildQuickAccessModules(BuildContext context, bool isDesktop) {
    final modules = [
      {
        'title': 'Heritage Sites',
        'subtitle': 'Explore 42+ UNESCO Marvels',
        'icon': Icons.account_balance,
        'color': AppTheme.primaryCrimson,
        'index': 1,
      },
      {
        'title': 'Interactive Map',
        'subtitle': 'Geo-Tagged Site Coordinates',
        'icon': Icons.map,
        'color': AppTheme.peacockTeal,
        'index': 2,
      },
      {
        'title': 'Cultural Stories',
        'subtitle': 'Folk Legends & Architecture',
        'icon': Icons.auto_stories,
        'color': AppTheme.saffronWarm,
        'index': 3,
      },
      {
        'title': 'AI Assistant',
        'subtitle': 'Chatbot & Bilingual Voice',
        'icon': Icons.smart_toy,
        'color': AppTheme.emeraldHeritage,
        'index': 4,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = isDesktop ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: isDesktop ? 1.6 : 1.3,
          ),
          itemBuilder: (context, index) {
            final mod = modules[index];
            final color = mod['color'] as Color;
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: color.withOpacity(0.2)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  final targetIndex = mod['index'] as int;
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(targetIndex);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(mod['icon'] as IconData, color: color, size: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mod['title'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mod['subtitle'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Featured Heritage Sites
  Widget _buildFeaturedSection(BuildContext context, bool isDesktop, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Heritage Sites',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                  ),
                ),
                Text(
                  'Handpicked UNESCO monuments and iconic architectural wonders',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HeritageLocationsScreen(),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View All'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.primaryCrimson),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Responsive Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final colCount = isDesktop ? 3 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _featuredSites.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 0.95 : 1.15,
              ),
              itemBuilder: (context, index) {
                return HeritageCard(site: _featuredSites[index]);
              },
            );
          },
        ),
      ],
    );
  }

  // Heritage Trails & Circuits
  Widget _buildCircuitsSection(BuildContext context, bool isDesktop, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Curated Heritage Trails',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        const Text(
          'Follow historic routes connecting ancient capitals, temples, and hill forts',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            final cols = isDesktop ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.heritageCircuits.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 2.4 : 2.0,
              ),
              itemBuilder: (context, index) {
                final circuit = AppConstants.heritageCircuits[index];
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardSurfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.route, color: AppTheme.primaryCrimson, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    circuit['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'serif',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.peacockTeal.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    circuit['duration'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.peacockTeal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              circuit['route'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryCrimson,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              circuit['description'] ?? '',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Cultural Story Preview
  Widget _buildStorySection(BuildContext context, bool isDesktop, bool isDark) {
    if (_stories.isEmpty) return const SizedBox.shrink();
    final firstStory = _stories.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cultural Storytelling',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                  ),
                ),
                Text(
                  'AI-curated oral histories, folklore, and engineering secrets',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StoriesScreen()),
                  );
                }
              },
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('All Stories'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.primaryCrimson),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
          child: StoryCard(
            story: firstStory,
            onReadTap: () {
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(3);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoriesScreen()),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Cultural Quote Banner
  Widget _buildCulturalQuoteBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF24201D) : const Color(0xFFF4ECE1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote, size: 36, color: AppTheme.accentGold),
          const SizedBox(height: 8),
          const Text(
            'अयं निजः परो वेति गणना लघुचेतसाम् ।\nउदारचरितानां तु वसुधैव कुटुम्बकम् ॥',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'serif',
              height: 1.5,
              color: AppTheme.primaryCrimson,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '“This is mine and that is yours, say the narrow-minded.\nFor the noble-hearted, the entire world is one family.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
