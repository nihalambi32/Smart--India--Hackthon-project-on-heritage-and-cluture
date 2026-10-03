// heritage_locations_screen.dart
// Explores and filters geo-tagged Indian heritage sites by category, state, and search query

import 'package:flutter/material.dart';
import '../models/heritage_site.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/heritage_card.dart';

class HeritageLocationsScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const HeritageLocationsScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
  });

  @override
  State<HeritageLocationsScreen> createState() => _HeritageLocationsScreenState();
}

class _HeritageLocationsScreenState extends State<HeritageLocationsScreen> {
  final ApiService _apiService = ApiService();
  late TextEditingController _searchController;

  String _selectedCategory = 'All Categories';
  String _selectedState = 'All States';
  String _sortBy = 'Popularity';

  List<HeritageSite> _allSites = [];
  List<HeritageSite> _filteredSites = [];
  bool _isLoading = true;

  final List<String> _states = [
    'All States',
    'Uttar Pradesh',
    'Karnataka',
    'Odisha',
    'Rajasthan',
    'Maharashtra',
    'Tamil Nadu',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    _fetchSites();
  }

  Future<void> _fetchSites() async {
    setState(() => _isLoading = true);
    final sites = await _apiService.fetchHeritageSites(
      category: _selectedCategory,
      query: _searchController.text,
      state: _selectedState,
    );

    if (mounted) {
      setState(() {
        _allSites = sites;
        _applySorting();
        _isLoading = false;
      });
    }
  }

  void _applySorting() {
    List<HeritageSite> sorted = List.from(_allSites);
    if (_sortBy == 'Popularity') {
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Name (A-Z)') {
      sorted.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Reviews') {
      sorted.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
    }
    _filteredSites = sorted;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heritage Sites of India'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Sites',
            onPressed: _fetchSites,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Container(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32.0 : 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => _fetchSites(),
                        decoration: InputDecoration(
                          hintText: 'Search by site name, state, architecture...',
                          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryCrimson),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _fetchSites();
                                  },
                                )
                              : null,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // State Filter Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardSurfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedState,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryCrimson),
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          items: _states.map((st) {
                            return DropdownMenuItem<String>(
                              value: st,
                              child: Text(st),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedState = val);
                              _fetchSites();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Category Chips (Horizontal Scrollable)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppConstants.heritageCategories.map((cat) {
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
                              _fetchSites();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 8),

                // Result Counter and Sort Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${_filteredSites.length} Heritage Sites',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Sort by: ',
                          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryCrimson,
                              fontWeight: FontWeight.bold,
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Popularity', child: Text('Rating')),
                              DropdownMenuItem(value: 'Name (A-Z)', child: Text('Name (A-Z)')),
                              DropdownMenuItem(value: 'Reviews', child: Text('Most Reviewed')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _sortBy = val;
                                  _applySorting();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Main Sites Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryCrimson))
                : _filteredSites.isEmpty
                    ? _buildEmptyState()
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
                              itemCount: _filteredSites.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: isDesktop ? 0.95 : 1.15,
                              ),
                              itemBuilder: (context, index) {
                                return HeritageCard(site: _filteredSites[index]);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryCrimson.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.travel_explore, size: 48, color: AppTheme.primaryCrimson),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Heritage Sites Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try adjusting your search query, state, or category filters.',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = 'All Categories';
                _selectedState = 'All States';
              });
              _fetchSites();
            },
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }
}
