// cultural_story.dart
// Model representing a digital cultural story or historical legend
// Used for AI-assisted cultural storytelling in Virasat

class CulturalStory {
  final String id;
  final String title;
  final String hindiTitle;
  final String associatedSiteId;
  final String associatedSiteName;
  final String category;
  final String summary;
  final String content;
  final List<String> fullStoryParagraphs;
  final String narrator;
  final int readTimeMinutes;
  final String era;
  final String imageUrl;
  final String culturalSignificance;
  final List<String> tags;

  const CulturalStory({
    required this.id,
    required this.title,
    required this.hindiTitle,
    required this.associatedSiteId,
    required this.associatedSiteName,
    required this.category,
    required this.summary,
    required this.content,
    required this.fullStoryParagraphs,
    required this.narrator,
    required this.readTimeMinutes,
    required this.era,
    required this.imageUrl,
    required this.culturalSignificance,
    required this.tags,
  });

  factory CulturalStory.fromJson(Map<String, dynamic> json) {
    return CulturalStory(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      hindiTitle: json['hindi_title'] as String? ?? json['hindiTitle'] as String? ?? '',
      associatedSiteId: json['associated_site_id'] as String? ?? json['associatedSiteId'] as String? ?? '',
      associatedSiteName: json['associated_site_name'] as String? ?? json['associatedSiteName'] as String? ?? '',
      category: json['category'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      fullStoryParagraphs: (json['paragraphs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          (json['fullStoryParagraphs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      narrator: json['narrator'] as String? ?? 'Cultural Scholar',
      readTimeMinutes: json['read_time_minutes'] as int? ?? json['readTimeMinutes'] as int? ?? 4,
      era: json['era'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      culturalSignificance: json['cultural_significance'] as String? ?? json['culturalSignificance'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hindi_title': hindiTitle,
      'associated_site_id': associatedSiteId,
      'associated_site_name': associatedSiteName,
      'category': category,
      'summary': summary,
      'content': content,
      'paragraphs': fullStoryParagraphs,
      'narrator': narrator,
      'read_time_minutes': readTimeMinutes,
      'era': era,
      'image_url': imageUrl,
      'cultural_significance': culturalSignificance,
      'tags': tags,
    };
  }
}
