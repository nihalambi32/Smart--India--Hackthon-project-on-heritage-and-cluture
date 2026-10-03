// map_screen.dart
// Interactive geo-tagged heritage mapping of India
// Compatible across Flutter Web, Mobile, and Desktop without external API key dependencies

import 'package:flutter/material.dart';
import '../models/heritage_site.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/location_card.dart';

class MapScreen extends StatefulWidget {
  final String? selectedSiteId;

  const MapScreen({super.key, this.selectedSiteId});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ApiService _apiService = ApiService();
  List<HeritageSite> _sites = [];
  HeritageSite? _selectedSite;
  String _activeCategory = 'All Categories';
  String _activeRegion = 'All India';
  double _zoomLevel = 1.0;
  bool _showCircuits = false;

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    final sites = await _apiService.fetchHeritageSites();
    if (mounted) {
      setState(() {
        _sites = sites;
        if (widget.selectedSiteId != null) {
          _selectedSite = sites.firstWhere(
            (s) => s.id == widget.selectedSiteId,
            orElse: () => sites.first,
          );
        } else if (sites.isNotEmpty) {
          _selectedSite = sites.first;
        }
      });
    }
  }

  // Map coordinate bounds for India (Approx Lat 8°N to 35°N, Lng 68°E to 97°E)
  Offset _projectCoordinatesToCanvas(double lat, double lng, Size mapSize) {
    const minLat = 8.0;
    const maxLat = 33.0;
    const minLng = 68.0;
    const maxLng = 90.0;

    // Invert lat for canvas Y (top is north)
    final double normalizedX = (lng - minLng) / (maxLng - minLng);
    final double normalizedY = 1.0 - ((lat - minLat) / (maxLat - minLat));

    return Offset(
      normalizedX * mapSize.width,
      normalizedY * mapSize.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Heritage Map'),
        actions: [
          IconButton(
            icon: Icon(
              _showCircuits ? Icons.alt_route : Icons.alt_route_outlined,
              color: _showCircuits ? AppTheme.accentGold : null,
            ),
            tooltip: 'Toggle Heritage Circuits',
            onPressed: () {
              setState(() => _showCircuits = !_showCircuits);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_showCircuits ? 'Heritage circuits enabled' : 'Circuits hidden'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Center Map of India',
            onPressed: () {
              setState(() {
                _zoomLevel = 1.0;
                _activeRegion = 'All India';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Bar
          _buildFilterBar(isDark),

          // Main Map Area (Split view on Desktop, Stack on Mobile)
          Expanded(
            child: isDesktop
                ? Row(
                    children: [
                      // Desktop Left: Interactive Map Canvas
                      Expanded(
                        flex: 3,
                        child: _buildInteractiveMap(isDark),
                      ),
                      // Desktop Right: Sites List & Details Panel
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: isDark ? AppTheme.borderSubtleDark : AppTheme.borderSubtle,
                              ),
                            ),
                          ),
                          child: _buildSidebarPanel(isDark),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      // Mobile: Full Map
                      Positioned.fill(child: _buildInteractiveMap(isDark)),

                      // Floating Bottom Card for Selected Site
                      if (_selectedSite != null)
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: LocationCard(
                            site: _selectedSite!,
                            isSelected: true,
                            onFocusOnMap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Focused on ${_selectedSite!.name}'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Top Filter Bar
  Widget _buildFilterBar(bool isDark) {
    return Container(
      color: isDark ? AppTheme.surfaceDark : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...AppConstants.indianRegions.map((region) {
                  final isSelected = _activeRegion == region;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(region),
                      selected: isSelected,
                      selectedColor: AppTheme.peacockTeal,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _activeRegion = region);
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Custom Geo Map Canvas
  Widget _buildInteractiveMap(bool isDark) {
    final filteredSites = _getFilteredSites();

    return Container(
      color: isDark ? const Color(0xFF171921) : const Color(0xFFEBF1F5), // Water background
      child: Stack(
        children: [
          // India Map Canvas
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mapSize = Size(constraints.maxWidth, constraints.maxHeight);

                return CustomPaint(
                  size: mapSize,
                  painter: _IndiaMapPainter(
                    isDark: isDark,
                    zoom: _zoomLevel,
                    showCircuits: _showCircuits,
                  ),
                );
              },
            ),
          ),

          // Geo-Tagged Pins Placed on Coordinates
          LayoutBuilder(
            builder: (context, constraints) {
              final mapSize = Size(constraints.maxWidth, constraints.maxHeight);

              return Stack(
                children: filteredSites.map((site) {
                  final offset = _projectCoordinatesToCanvas(site.latitude, site.longitude, mapSize);
                  final isSelected = _selectedSite?.id == site.id;

                  return Positioned(
                    left: (offset.dx - 18).clamp(10.0, mapSize.width - 36),
                    top: (offset.dy - 36).clamp(10.0, mapSize.height - 40),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedSite = site);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryCrimson : Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              site.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            size: isSelected ? 34 : 26,
                            color: isSelected ? AppTheme.primaryCrimson : AppTheme.saffronWarm,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Zoom Controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildMapButton(Icons.add, () {
                  setState(() => _zoomLevel = (_zoomLevel + 0.2).clamp(0.8, 2.5));
                }),
                const SizedBox(height: 8),
                _buildMapButton(Icons.remove, () {
                  setState(() => _zoomLevel = (_zoomLevel - 0.2).clamp(0.8, 2.5));
                }),
              ],
            ),
          ),

          // Map Legend Indicator
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black87 : Colors.white).withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hub, size: 14, color: AppTheme.primaryCrimson),
                  SizedBox(width: 6),
                  Text(
                    'Geo-Tagged via PostGIS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: AppTheme.textPrimary),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Sidebar Panel for Desktop Layout
  Widget _buildSidebarPanel(bool isDark) {
    final filtered = _getFilteredSites();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Geo-Tagged Heritage Sites (${filtered.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Click on any monument or pin to inspect coordinates & details',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final site = filtered[index];
                final isSelected = _selectedSite?.id == site.id;
                return InkWell(
                  onTap: () => setState(() => _selectedSite = site),
                  child: LocationCard(
                    site: site,
                    isSelected: isSelected,
                    onFocusOnMap: () => setState(() => _selectedSite = site),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<HeritageSite> _getFilteredSites() {
    if (_activeRegion == 'Northern Heritage') {
      return _sites.where((s) => s.state == 'Uttar Pradesh' || s.state == 'Rajasthan').toList();
    } else if (_activeRegion == 'Southern Temples') {
      return _sites.where((s) => s.state == 'Karnataka' || s.state == 'Tamil Nadu').toList();
    } else if (_activeRegion == 'Western Forts') {
      return _sites.where((s) => s.state == 'Maharashtra' || s.state == 'Rajasthan').toList();
    } else if (_activeRegion == 'Eastern Wonders') {
      return _sites.where((s) => s.state == 'Odisha').toList();
    }
    return _sites;
  }
}

// Custom Painter representing India's cartography and geo-grid
class _IndiaMapPainter extends CustomPainter {
  final bool isDark;
  final double zoom;
  final bool showCircuits;

  _IndiaMapPainter({
    required this.isDark,
    required this.zoom,
    required this.showCircuits,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final landPaint = Paint()
      ..color = isDark ? const Color(0xFF262A36) : const Color(0xFFF7F2E9)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isDark ? const Color(0xFF3F4659) : const Color(0xFFDACBBA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw Lat/Lng Grid Lines
    for (double i = 0; i < size.width; i += size.width / 8) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double j = 0; j < size.height; j += size.height / 8) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), gridPaint);
    }

    // Draw Stylized Landmass Shape of India subcontinent
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Northern Himalayas
    path.moveTo(w * 0.40, h * 0.08);
    path.lineTo(w * 0.52, h * 0.05); // Kashmir/Ladakh
    path.lineTo(w * 0.62, h * 0.16); // Himachal/Uttarakhand
    path.lineTo(w * 0.76, h * 0.22); // Nepal/Sikkim border
    path.lineTo(w * 0.88, h * 0.25); // Northeast India / Assam
    path.lineTo(w * 0.84, h * 0.36); // Bengal / Delta
    path.lineTo(w * 0.75, h * 0.46); // Odisha coast
    path.lineTo(w * 0.68, h * 0.68); // Andhra coast
    path.lineTo(w * 0.58, h * 0.88); // Tamil Nadu coast
    path.lineTo(w * 0.52, h * 0.95); // Kanyakumari (Southernmost tip)
    path.lineTo(w * 0.45, h * 0.85); // Kerala Malabar coast
    path.lineTo(w * 0.38, h * 0.68); // Karnataka / Goa
    path.lineTo(w * 0.32, h * 0.52); // Maharashtra Konkan
    path.lineTo(w * 0.22, h * 0.40); // Gujarat Kathiawar peninsula
    path.lineTo(w * 0.20, h * 0.34); // Rann of Kutch
    path.lineTo(w * 0.32, h * 0.22); // Rajasthan border
    path.lineTo(w * 0.38, h * 0.14); // Punjab
    path.close();

    canvas.drawPath(path, landPaint);
    canvas.drawPath(path, borderPaint);

    // Draw Heritage Circuits connecting routes if enabled
    if (showCircuits) {
      final circuitPaint = Paint()
        ..color = AppTheme.primaryCrimson.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Golden Triangle (Delhi - Agra - Jaipur)
      final p1 = Offset(w * 0.42, h * 0.28);
      final p2 = Offset(w * 0.46, h * 0.31);
      final p3 = Offset(w * 0.38, h * 0.32);

      final circuitPath = Path();
      circuitPath.moveTo(p1.dx, p1.dy);
      circuitPath.lineTo(p2.dx, p2.dy);
      circuitPath.lineTo(p3.dx, p3.dy);
      circuitPath.close();
      canvas.drawPath(circuitPath, circuitPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _IndiaMapPainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.zoom != zoom ||
        oldDelegate.showCircuits != showCircuits;
  }
}
