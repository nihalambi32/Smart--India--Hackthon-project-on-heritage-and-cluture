// stories_screen.dart
// Digital cultural storytelling and folklore exploration for Virasat
// Displays AI-curated legends, architectural mysteries, and oral histories

import 'package:flutter/material.dart';
import '../models/cultural_story.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/story_card.dart';
import 'heritage_detail_screen.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final ApiService _apiService = ApiService();
  List<CulturalStory> _stories = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Architectural Marvels',
    'Ancient Science',
    'Acoustic Marvels',
    'Royal Legends',
  ];

  @override
  void initState() {
    super.initState();
    _fetchStories();
  }

  Future<void> _fetchStories() async {
    setState(() => _isLoading = true);
    final stories = await _apiService.fetchCulturalStories(
      category: _selectedCategory == 'All' ? null : _selectedCategory,
    );
    if (mounted) {
      setState(() {
        _stories = stories;
        _isLoading = false;
      });
    }
  }

  void _openStoryReader(CulturalStory story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StoryReaderSheet(story: story),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Stories & Legends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Stories',
            onPressed: _fetchStories,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Chips Bar
          Container(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32.0 : 16.0,
              vertical: 12.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryCrimson,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = cat);
                          _fetchStories();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // Stories Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryCrimson))
                : _stories.isEmpty
                    ? const Center(child: Text('No stories found for this category.'))
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 32.0 : 16.0,
                          vertical: 16.0,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;
                            if (isDesktop) {
                              crossAxisCount = 3;
                            } else if (isTablet) {
                              crossAxisCount = 2;
                            }

                            return GridView.builder(
                              itemCount: _stories.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: isDesktop ? 0.95 : 1.15,
                              ),
                              itemBuilder: (context, index) {
                                return StoryCard(
                                  story: _stories[index],
                                  onReadTap: () => _openStoryReader(_stories[index]),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// Modal Reader Sheet for deep storytelling reading experience
class _StoryReaderSheet extends StatefulWidget {
  final CulturalStory story;

  const _StoryReaderSheet({required this.story});

  @override
  State<_StoryReaderSheet> createState() => _StoryReaderSheetState();
}

class _StoryReaderSheetState extends State<_StoryReaderSheet> {
  bool _isPlayingNarration = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark : const Color(0xFFFDFBF7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Sheet Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Reader Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCrimson.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          story.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryCrimson,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${story.readTimeMinutes} min read • Era: ${story.era}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Scrollable Story Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (story.hindiTitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          story.hindiTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.saffronWarm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // AI Narration Player Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.surfaceDark : const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(_isPlayingNarration ? Icons.pause_circle_filled : Icons.play_circle_filled),
                              color: AppTheme.primaryCrimson,
                              iconSize: 32,
                              onPressed: () {
                                setState(() => _isPlayingNarration = !_isPlayingNarration);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _isPlayingNarration
                                          ? 'Playing AI Audio Narration: ${story.title}'
                                          : 'Narration Paused',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Listen to Story Narration',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Narrated by ${story.narrator}',
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Paragraphs
                      ...story.fullStoryParagraphs.map((para) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            para,
                            style: TextStyle(
                              fontSize: 15.5,
                              height: 1.7,
                              fontFamily: 'serif',
                              color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      // Cultural Significance Footnote Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCrimson.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryCrimson.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lightbulb, color: AppTheme.primaryCrimson, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Cultural & Historical Significance',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryCrimson,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              story.culturalSignificance,
                              style: const TextStyle(fontSize: 13, height: 1.5),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Link to associated heritage site
                      if (story.associatedSiteId.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context); // close sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeritageDetailScreen(
                                    siteId: story.associatedSiteId,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.account_balance, size: 18),
                            label: Text('Explore ${story.associatedSiteName}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryCrimson,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),
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
}
