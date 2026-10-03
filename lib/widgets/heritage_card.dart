// heritage_card.dart
// Reusable card widget for showcasing cultural heritage sites
// Responsive for both mobile lists and web multi-column grids

import 'package:flutter/material.dart';
import '../models/heritage_site.dart';
import '../theme/app_theme.dart';
import '../screens/heritage_detail_screen.dart';

class HeritageCard extends StatefulWidget {
  final HeritageSite site;
  final bool compact;
  final VoidCallback? onBookmarkToggle;

  const HeritageCard({
    super.key,
    required this.site,
    this.compact = false,
    this.onBookmarkToggle,
  });

  @override
  State<HeritageCard> createState() => _HeritageCardState();
}

class _HeritageCardState extends State<HeritageCard> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final site = widget.site;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeritageDetailScreen(siteId: site.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Overlays
            Stack(
              children: [
                Container(
                  height: widget.compact ? 130 : 170,
                  width: double.infinity,
                  color: const Color(0xFFE5D5C5),
                  child: Image.network(
                    site.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B2500), Color(0xFFC04E26)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_balance, size: 40, color: Colors.white70),
                              const SizedBox(height: 6),
                              Text(
                                site.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFFAF7F2),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryCrimson,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient overlay for readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // UNESCO Badge
                if (site.isUnesco)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 12, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'UNESCO',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Bookmark Action Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black.withOpacity(0.4),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        setState(() {
                          _isBookmarked = !_isBookmarked;
                        });
                        if (widget.onBookmarkToggle != null) {
                          widget.onBookmarkToggle!();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isBookmarked
                                  ? 'Saved ${site.name} to favorites'
                                  : 'Removed from favorites',
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 18,
                          color: _isBookmarked ? AppTheme.accentGold : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Location Pin Overlay at bottom of image
                Positioned(
                  bottom: 8,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${site.location}, ${site.state}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black, offset: Offset(0, 1)),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Site Information Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              site.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                fontFamily: 'serif',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (site.hindiName.isNotEmpty)
                              Text(
                                site.hindiName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Rating Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 13, color: Color(0xFFB78103)),
                            const SizedBox(width: 3),
                            Text(
                              site.rating.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6B4E00),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Era & Century Info
                  Row(
                    children: [
                      Icon(
                        Icons.history_edu,
                        size: 13,
                        color: isDark ? AppTheme.textMuted : AppTheme.primaryLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          site.era,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tags & Audio Indicator
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCrimson.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          site.category,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryCrimson,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (site.audioGuideAvailable)
                        Row(
                          children: [
                            const Icon(Icons.headphones, size: 13, color: AppTheme.peacockTeal),
                            const SizedBox(width: 4),
                            Text(
                              '${site.audioDurationMinutes} min',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.peacockTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
