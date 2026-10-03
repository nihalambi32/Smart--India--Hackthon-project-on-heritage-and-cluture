// heritage_site.dart
// Model representing a cultural heritage site in India
// Compatible with future PostgreSQL / PostGIS backend serialization

class HeritageSite {
  final String id;
  final String name;
  final String hindiName;
  final String location;
  final String state;
  final String era;
  final String century;
  final String category;
  final String description;
  final String history;
  final String architecture;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String visitingHours;
  final String entryFee;
  final String bestTimeToVisit;
  final double rating;
  final int reviewsCount;
  final bool isUnesco;
  final List<String> tags;
  final List<String> highlights;
  final bool audioGuideAvailable;
  final int audioDurationMinutes;

  const HeritageSite({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.location,
    required this.state,
    required this.era,
    required this.century,
    required this.category,
    required this.description,
    required this.history,
    required this.architecture,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.visitingHours,
    required this.entryFee,
    required this.bestTimeToVisit,
    required this.rating,
    required this.reviewsCount,
    required this.isUnesco,
    required this.tags,
    required this.highlights,
    required this.audioGuideAvailable,
    required this.audioDurationMinutes,
  });

  factory HeritageSite.fromJson(Map<String, dynamic> json) {
    return HeritageSite(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      hindiName: json['hindi_name'] as String? ?? json['hindiName'] as String? ?? '',
      location: json['location'] as String? ?? '',
      state: json['state'] as String? ?? '',
      era: json['era'] as String? ?? '',
      century: json['century'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      history: json['history'] as String? ?? '',
      architecture: json['architecture'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      visitingHours: json['visiting_hours'] as String? ?? json['visitingHours'] as String? ?? '9:00 AM – 5:00 PM',
      entryFee: json['entry_fee'] as String? ?? json['entryFee'] as String? ?? 'Free',
      bestTimeToVisit: json['best_time_to_visit'] as String? ?? json['bestTimeToVisit'] as String? ?? 'Winter',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewsCount: json['reviews_count'] as int? ?? json['reviewsCount'] as int? ?? 0,
      isUnesco: json['is_unesco'] as bool? ?? json['isUnesco'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      audioGuideAvailable: json['audio_guide_available'] as bool? ?? json['audioGuideAvailable'] as bool? ?? false,
      audioDurationMinutes: json['audio_duration_minutes'] as int? ?? json['audioDurationMinutes'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hindi_name': hindiName,
      'location': location,
      'state': state,
      'era': era,
      'century': century,
      'category': category,
      'description': description,
      'history': history,
      'architecture': architecture,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'visiting_hours': visitingHours,
      'entry_fee': entryFee,
      'best_time_to_visit': bestTimeToVisit,
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_unesco': isUnesco,
      'tags': tags,
      'highlights': highlights,
      'audio_guide_available': audioGuideAvailable,
      'audio_duration_minutes': audioDurationMinutes,
    };
  }
}
