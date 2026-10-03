// constants.dart
// Virasat – Roots & Radiance | Smart India Hackathon 2026
// Problem Statement ID: SIH26197 | Team ID: G109

import '../models/heritage_site.dart';
import '../models/cultural_story.dart';

class AppConstants {
  // Application Information
  static const String appName = 'Virasat';
  static const String appTagline = 'Roots & Radiance';
  static const String appSubtitle = 'Preserving India\'s Timeless Heritage & Traditions';
  static const String hackathonTitle = 'Smart India Hackathon 2026';
  static const String problemStatementId = 'SIH26197';
  static const String teamId = 'G109';
  static const String teamName = 'Team Virasat';

  // API Configuration (Ready for FastAPI / Node.js backend integration)
  static const String apiBaseUrl = 'http://localhost:8000/api';
  static const String apiSitesEndpoint = '$apiBaseUrl/heritage-sites';
  static const String apiStoriesEndpoint = '$apiBaseUrl/cultural-stories';
  static const String apiChatEndpoint = '$apiBaseUrl/ai/chatbot';
  static const String apiVoiceEndpoint = '$apiBaseUrl/ai/voice-assistant';
  static const String apiGeoEndpoint = '$apiBaseUrl/geo/nearby';

  // Heritage Categories
  static const List<String> heritageCategories = [
    'All Categories',
    'UNESCO Sites',
    'Forts & Palaces',
    'Ancient Temples',
    'Rock-cut Caves',
    'Living Traditions',
  ];

  // Indian Regions
  static const List<String> indianRegions = [
    'All India',
    'Northern Heritage',
    'Southern Temples',
    'Western Forts',
    'Eastern Wonders',
    'Central Marvels',
  ];

  // Heritage Circuits / Trails
  static const List<Map<String, String>> heritageCircuits = [
    {
      'title': 'Golden Triangle Circuit',
      'route': 'Delhi → Agra → Jaipur',
      'description': 'Witness the iconic monuments of Mughal & Rajput glory: Red Fort, Taj Mahal, and Amer Fort.',
      'duration': '4–5 Days',
    },
    {
      'title': 'Great Chola Temples Trail',
      'route': 'Thanjavur → Gangaikonda Cholapuram → Kumbakonam',
      'description': 'Marvel at 1000-year-old Dravidian granite architectural wonders of Tamil Nadu.',
      'duration': '3 Days',
    },
    {
      'title': 'Western Buddhist & Cave Trail',
      'route': 'Aurangabad → Ajanta → Ellora',
      'description': 'Ancient rock-hewn masterpieces from the 2nd century BCE featuring the Kailash temple monolith.',
      'duration': '2–3 Days',
    },
    {
      'title': 'Vijayanagara Empire Trail',
      'route': 'Hampi → Badami → Pattadakal',
      'description': 'Explore the open-air museum of stone chariots and boulders beside the Tungabhadra river.',
      'duration': '3–4 Days',
    },
  ];

  // Sample AI Chatbot Prompts
  static const List<String> sampleChatPrompts = [
    'Tell me the history of Hampi\'s Stone Chariot',
    'What makes the architecture of Konark Sun Temple unique?',
    'Explain the Dravidian style of temple architecture',
    'What was the mystery of the Iron Pillar of Delhi?',
    'Recommend a 3-day heritage itinerary for Rajasthan',
    'Who built the monolithic Kailash Temple at Ellora?',
  ];

  // Sample Voice Assistant Prompts
  static const List<Map<String, String>> sampleVoicePromptsEn = [
    {'title': 'Explore Taj Mahal', 'query': 'Tell me the history and architecture of Taj Mahal in Agra'},
    {'title': 'Karnataka Heritage', 'query': 'Show me the UNESCO World Heritage sites in Karnataka'},
    {'title': 'Forts of Rajasthan', 'query': 'Which are the most famous hill forts in Rajasthan?'},
    {'title': 'Brihadisvara Temple', 'query': 'What is the significance of the Big Temple of Thanjavur?'},
  ];

  static const List<Map<String, String>> sampleVoicePromptsHi = [
    {'title': 'ताजमहल का इतिहास', 'query': 'ताजमहल के निर्माण और वास्तुकला की कहानी बताएं'},
    {'title': 'हम्पी के स्मारक', 'query': 'कर्नाटक में हम्पी के प्रमुख स्मारकों के बारे में जानकारी दें'},
    {'title': 'राजस्थान के किले', 'query': 'राजस्थान के प्रमुख ऐतिहासिक किलों की सूची और इतिहास दिखाएं'},
    {'title': 'कोणार्क सूर्य मंदिर', 'query': 'कोणार्क के सूर्य मंदिर का क्या सांस्कृतिक महत्व है?'},
  ];

  // Curated Mock Dataset for Local Demo & Offline Mode
  static final List<HeritageSite> mockHeritageSites = [
    const HeritageSite(
      id: 'site-1',
      name: 'Taj Mahal',
      hindiName: 'ताजमहल',
      location: 'Agra',
      state: 'Uttar Pradesh',
      era: 'Mughal Era (1632–1653 CE)',
      century: '17th Century',
      category: 'UNESCO Sites',
      description: 'An immense mausoleum of white marble, built in Agra between 1632 and 1653 by order of the Mughal emperor Shah Jahan in memory of his beloved wife Mumtaz Mahal. It is one of the universal masterpieces of world heritage.',
      history: 'Commissioned in 1631 by Mughal Emperor Shah Jahan, over 20,000 artisans, masons, stone-cutters, calligraphers, and carvers from across India, Persia, and Central Asia worked under chief architect Ustad Ahmad Lahori. The complex incorporates Charbagh quadrilateral gardens and intricate pietra dura gemstone inlays.',
      architecture: 'Mughal Architecture synthesizing Persian, Islamic, and Indian architectural styles. Features ivory-white Makrana marble, symmetrical minarets, central dome (35m high), intricate calligraphy inscriptions from the Quran, and floral marble reliefs.',
      imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1200&q=80',
      latitude: 27.1751,
      longitude: 78.0421,
      visitingHours: 'Sunrise to Sunset (Closed Fridays)',
      entryFee: '₹50 (Indian) / ₹1100 (Foreigners)',
      bestTimeToVisit: 'October to March',
      rating: 4.9,
      reviewsCount: 38240,
      isUnesco: true,
      tags: ['UNESCO World Heritage', 'Seven Wonders', 'Mughal Architecture', 'Marble Monument'],
      highlights: [
        'Pure white Makrana marble from Rajasthan that shifts hue with sunrise and moonlight',
        'Remarkable optical symmetry and minarets angled outward to safeguard the tomb from earthquakes',
        'Pietra dura lapidary work with semi-precious stones (lapis lazuli, jade, turquoise)',
        'Traditional Charbagh Persian garden representing paradise with reflecting pools'
      ],
      audioGuideAvailable: true,
      audioDurationMinutes: 28,
    ),
    const HeritageSite(
      id: 'site-2',
      name: 'Hampi Monuments',
      hindiName: 'हम्पी के स्मारक',
      location: 'Vijayanagara',
      state: 'Karnataka',
      era: 'Vijayanagara Empire (14th–16th Century)',
      century: '14th Century',
      category: 'UNESCO Sites',
      description: 'The capital of the historic Vijayanagara Empire situated on the banks of the Tungabhadra River. Hampi features austere, grandiose monuments amidst sprawling granite boulders and ruins that speak of immense medieval prosperity.',
      history: 'Hampi was the capital of the Vijayanagara Empire from 1336 to 1565. Described by Portuguese and Persian travelers as one of the richest and second-largest cities in the medieval world, it boasted flourishing markets of diamonds, silks, and spices before its sack in 1565.',
      architecture: 'Dravidian Architecture characterized by massive monolithic granite structures, multi-pillared mandapas, ornate musical stone pillars, elephant stables, stepped tanks (Pushkaranis), and intricate bas-reliefs depicting the Ramayana.',
      imageUrl: 'https://images.unsplash.com/photo-1600100397608-f010f443b793?auto=format&fit=crop&w=1200&q=80',
      latitude: 15.3350,
      longitude: 76.4600,
      visitingHours: '6:00 AM – 6:00 PM Daily',
      entryFee: '₹40 (Indian) / ₹600 (Foreigners)',
      bestTimeToVisit: 'November to February',
      rating: 4.8,
      reviewsCount: 19520,
      isUnesco: true,
      tags: ['UNESCO World Heritage', 'Vijayanagara', 'Stone Chariot', 'Musical Pillars', 'Dravidian Style'],
      highlights: [
        'Vittala Temple Stone Chariot – a world-renowned monolithic shrine carved from granite',
        '56 Musical Pillars in Vittala Temple that resonate musical notes when gently tapped',
        'Virupaksha Temple – continuously functioning sacred temple since the 7th century',
        'Stepped Royal Pushkarani showcasing advanced medieval hydraulic engineering'
      ],
      audioGuideAvailable: true,
      audioDurationMinutes: 35,
    ),
    const HeritageSite(
      id: 'site-3',
      name: 'Konark Sun Temple',
      hindiName: 'कोणार्क सूर्य मंदिर',
      location: 'Puri District',
      state: 'Odisha',
      era: 'Eastern Ganga Dynasty (c. 1250 CE)',
      century: '13th Century',
      category: 'Ancient Temples',
      description: 'Conceived as a colossal chariot for the Sun God Surya, with 24 elaborately carved stone wheels drawn by seven spirited horses, situated along the Bay of Bengal coast.',
      history: 'Constructed by King Narasimhadeva I of the Eastern Ganga Dynasty around 1250 CE. According to tradition, 1,200 artisans spent 12 years completing the temple under chief architect Bisu Maharana and his brilliant son Dharmapada.',
      architecture: 'Kalinga Architecture of the highest sophistication. The stone wheels act as precise sundials telling time to the minute. Extensive friezes depict royal life, battle processions, musicians, dancers, and celestial beings.',
      imageUrl: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80',
      latitude: 19.8876,
      longitude: 86.0945,
      visitingHours: '6:00 AM – 8:00 PM Daily',
      entryFee: '₹40 (Indian) / ₹600 (Foreigners)',
      bestTimeToVisit: 'September to March',
      rating: 4.7,
      reviewsCount: 14210,
      isUnesco: true,
      tags: ['UNESCO World Heritage', 'Kalinga Architecture', 'Sun Temple', 'Sundial Wheels'],
      highlights: [
        '24 Stone Wheels serving as sundials calculating time based on the shadows of the spokes',
        'Natya Mandir (Hall of Dance) carved with over 100 Classical Odissi dance postures',
        'Legendary iron beams and lodestone magnet that once suspended the main deity in mid-air',
        'Intricate chlorite stone carvings depicting fauna, flora, and divine narratives'
      ],
      audioGuideAvailable: true,
      audioDurationMinutes: 24,
    ),
    const HeritageSite(
      id: 'site-4',
      name: 'Amer Fort & Palace',
      hindiName: 'आमेर किला',
      location: 'Jaipur',
      state: 'Rajasthan',
      era: 'Kachwaha Rajput Dynasty (1592 CE)',
      century: '16th Century',
      category: 'Forts & Palaces',
      description: 'A majestic hilltop fortress crafted from red sandstone and yellow marble overlooking Maota Lake, famous for its artistic Hindu elements and opulent Sheesh Mahal (Mirror Palace).',
      history: 'Built by Raja Man Singh I in 1592 and expanded by Mirza Raja Jai Singh and Sawai Jai Singh. Amer was the seat of the Kachwaha rulers before the founding of the planned city of Jaipur in 1727.',
      architecture: 'Rajput-Mughal fusion architecture. Comprises four main courtyards, Diwan-e-Aam, Diwan-e-Khas, Ganesh Pol gateway, and the breathtaking Sheesh Mahal where a single candle illuminates the entire ceiling through thousands of Belgian convex mirrors.',
      imageUrl: 'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=1200&q=80',
      latitude: 26.9855,
      longitude: 75.8513,
      visitingHours: '8:00 AM – 5:30 PM & 6:30 PM – 9:15 PM',
      entryFee: '₹100 (Indian) / ₹500 (Foreigners)',
      bestTimeToVisit: 'October to March',
      rating: 4.8,
      reviewsCount: 22890,
      isUnesco: true,
      tags: ['UNESCO World Heritage', 'Hill Forts of Rajasthan', 'Rajput Heritage', 'Sheesh Mahal'],
      highlights: [
        'Sheesh Mahal – world-famous mirror palace reflecting candlelight across convex mirrors',
        'Ganesh Pol – ornate frescoed royal entrance dedicated to Lord Ganesha',
        'Underground passage connecting Amer Fort to the military bastion of Jaigarh Fort',
        'Aram Bagh Mughal-style geometric pleasure garden floating on Maota Lake'
      ],
      audioGuideAvailable: true,
      audioDurationMinutes: 30,
    ),
    const HeritageSite(
      id: 'site-5',
      name: 'Ajanta & Ellora Caves',
      hindiName: 'अजिंठा एवं एलोरा गुफाएँ',
      location: 'Chhatrapati Sambhajinagar',
      state: 'Maharashtra',
      era: 'Satavahana, Vakataka, Rashtrakuta Dynasties (2nd BCE – 10th CE)',
      century: '2nd BCE – 10th CE',
      category: 'Rock-cut Caves',
      description: 'Monumental rock-hewn caves carved into basalt cliffs. Ajanta holds masterwork Buddhist tempera murals, while Ellora features the Kailash Temple—the largest monolithic rock excavation on Earth.',
      history: 'Ajanta was carved in two phases starting in the 2nd century BCE and revived under King Harishena of the Vakataka dynasty. Ellora was crafted between the 6th and 10th centuries, uniting Buddhist, Hindu, and Jain sanctuaries.',
      architecture: 'Rock-cut architecture excavated from top to bottom out of a single volcanic basalt cliff. Kailash Temple (Cave 16) alone required the removal of 200,000 tonnes of rock without any joinery or scaffolding.',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=1200&q=80',
      latitude: 20.5519,
      longitude: 75.7033,
      visitingHours: '9:00 AM – 5:30 PM (Ajanta closed Mon, Ellora closed Tue)',
      entryFee: '₹40 (Indian) / ₹600 (Foreigners)',
      bestTimeToVisit: 'July to March',
      rating: 4.9,
      reviewsCount: 28100,
      isUnesco: true,
      tags: ['UNESCO World Heritage', 'Rock-cut Architecture', 'Buddhist Frescoes', 'Kailash Temple', 'Monolithic Marvel'],
      highlights: [
        'Kailash Temple (Cave 16) – colossal top-down monolithic temple twice the footprint of Parthenon',
        'Ajanta Cave 1 Bodhisattva Padmapani fresco renowned for timeless compassionate expression',
        'Cave 26 Chaitya hall with immense 7-meter reclining Buddha Mahaparinirvana sculpture',
        'Harmonious coexistence of Hindu, Buddhist, and Jain faiths in 34 rock-cut sanctuaries'
      ],
      audioGuideAvailable: true,
      audioDurationMinutes: 42,
    ),
    const HeritageSite(
      id: 'site-6',
      name: 'Brihadisvara Temple',
      hindiName: 'बृहदीश्वर मंदिर',
      location: 'Thanjavur',
      state: 'Tamil Nadu',
      era: 'Chola Dynasty (1010 CE)',
      century: '11th Century',
      category: 'Ancient Temples',
      description: 'The monumental Big Temple dedicated to Lord Shiva, built by Rajaraja Chola I. Its 66-meter granite vimana is crowned with an 80-tonne monolithic cupola.',
      history: 'Commissioned by Emperor Rajaraja Chola I to commemorate victories across southern India and Southeast Asia. Completed in 1010 CE, it marks the pinnacle of Chola bronze casting, stone carving, and sacred geometry.',
      architecture: 'Pure Dravidian Architecture built entirely of interlocking granite blocks without mortar. Features a hollow pyramidal tower (Vimana) of 16 stories and one of the largest monolithic Nandi bull statues in India.',
      imageUrl: 'https://images.unsplash.com/photo-1621847468516-1ed5d0df56fe?auto=format&fit=crop&w=1200&q=80',
      latitude: 10.7828,
      longitude: 79.1318,
      visitingHours: '6:00 AM – 12:30 PM & 4:00 PM – 8:30 PM',
      entryFee: 'Free entry (UNESCO Protected site)',
      bestTimeToVisit: 'October to March',
      rating: 4.9,
      reviewsCount: 16780,
      isUnesco: true,
      tags: ['UNESCO World Heritage', 'Chola Dynasty', 'Granite Temple', 'Dravidian Architecture', 'Great Living Chola Temples'],
      highlights: [
        '80-tonne granite Kumbam (octagonal dome) positioned atop the 66-meter high Vimana',
        'Vast monolithic Nandi carved from a single rock measuring 3.7m high and 6m long',
        'Exquisite 1000-year-old fresco paintings on inner ambulatory walls depicting Lord Shiva',
        'Ancient Tamil inscriptions recording names of every architect, dancer, and donor'
      ],
      audioGuideAvailable: true,
      audioDurationMinutes: 32,
    ),
  ];

  // Curated Cultural Stories
  static final List<CulturalStory> mockCulturalStories = [
    const CulturalStory(
      id: 'story-1',
      title: 'The Mystery of the Kailash Monolith',
      hindiTitle: 'कैलाश एकाश्म मंदिर का रहस्य',
      associatedSiteId: 'site-5',
      associatedSiteName: 'Ellora Caves',
      category: 'Architectural Marvels',
      summary: 'How ancient Indian rock sculptors carved an 8-story temple out of a mountain cliff from top to bottom, removing over 200,000 tonnes of basalt rock.',
      content: 'In the 8th century, King Krishna I of the Rashtrakuta dynasty dared to envision an earthly replica of Mount Kailash—the cosmic abode of Lord Shiva. Rather than assembling blocks of stone from the ground up, the master builders of Ellora chose the ultimate test of sculptural audacity: they carved downward from the summit of the volcanic hill.\n\nWithout modern cranes, laser leveling, or computer calculations, ancient sculptors used iron chisels and hammers to carve intricate galleries, life-sized elephants, multi-tiered towers, and expansive courtyards from a single living rock.\n\nToday, modern engineers marvel at the planning precision: a single misjudged hammer blow on the top roof would have ruined the entire structure below. Kailash stands not merely as stone, but as the pinnacle of human spirit and architectural devotion.',
      fullStoryParagraphs: [
        'In the 8th century, King Krishna I of the Rashtrakuta dynasty dared to envision an earthly replica of Mount Kailash—the cosmic abode of Lord Shiva.',
        'Rather than assembling blocks of stone from the ground up, the master builders of Ellora chose the ultimate test of sculptural audacity: they carved downward from the summit of the volcanic hill.',
        'Without modern cranes, laser leveling, or computer calculations, ancient sculptors used iron chisels and hammers to carve intricate galleries, life-sized elephants, multi-tiered towers, and expansive courtyards from a single living rock.',
        'Today, modern engineers marvel at the planning precision: a single misjudged hammer blow on the top roof would have ruined the entire structure below.',
        'Kailash stands not merely as stone, but as the pinnacle of human spirit and devotion.'
      ],
      narrator: 'Acharya Vidyadhar, Cultural Historian',
      readTimeMinutes: 4,
      era: 'Rashtrakuta Dynasty (756–774 CE)',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=1200&q=80',
      culturalSignificance: 'Demonstrates ancient India\'s advanced rock-mechanics, sculptural mastery, and mathematical planning.',
      tags: ['Ellora', 'Kailash Temple', 'Rock-cut Architecture', 'Ancient Engineering', 'Shiva'],
    ),
    const CulturalStory(
      id: 'story-2',
      title: 'The Secret of Konark\'s Sundial Wheels',
      hindiTitle: 'कोणार्क के कालचक्र पहियों का रहस्य',
      associatedSiteId: 'site-3',
      associatedSiteName: 'Konark Sun Temple',
      category: 'Ancient Science',
      summary: 'Discover how 24 monumental chariot wheels at Konark measure time accurately down to the minute using the sun\'s moving shadows.',
      content: 'Along the shoreline of Odisha stands the Surya Devalaya of Konark. The temple was built as a giant chariot with 24 carved stone wheels, each nearly 10 feet in diameter, pulled by seven horses symbolizing the seven days of the week.\n\nEach wheel contains eight major spokes and eight minor spokes. The major spokes divide the 24 hours of a day into 3-hour intervals (Prahars), while the beads on the rims and minor spokes break down the time into minutes.\n\nBy placing a thumb or finger at the center of the axle, the shadow cast across the spokes reveals the exact solar time of day—a testament to how art, sacred devotion, and astronomical science flourished hand in hand in 13th-century India.',
      fullStoryParagraphs: [
        'Along the shoreline of Odisha stands the Surya Devalaya of Konark, built as a giant chariot with 24 carved stone wheels.',
        'Each wheel contains eight major spokes and eight minor spokes, dividing the day into precise traditional Vedic time units.',
        'By observing the shadow cast across the carved spokes, visitors can still calculate the exact solar time of day.',
        'The wheels represent the eternal wheel of time (Kalachakra), harmonizing astronomy, philosophy, and stone artistry.'
      ],
      narrator: 'Dr. Pratima Sen, Archaeologist',
      readTimeMinutes: 5,
      era: 'Eastern Ganga Dynasty (1250 CE)',
      imageUrl: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80',
      culturalSignificance: 'Reveals the deep integration of astronomy, mathematics, and spiritual architecture in ancient India.',
      tags: ['Konark', 'Sun Temple', 'Sundial', 'Astronomy', 'Odisha Heritage'],
    ),
    const CulturalStory(
      id: 'story-3',
      title: 'The Resilient Bells of Hampi\'s Musical Pillars',
      hindiTitle: 'हम्पी के संगीत स्तंभों की गूँज',
      associatedSiteId: 'site-2',
      associatedSiteName: 'Hampi Monuments',
      category: 'Acoustic Marvels',
      summary: 'Uncover the acoustic marvel of the Vittala Temple mandapa, where hollowed granite pillars ring like classical Indian musical instruments.',
      content: 'In the majestic Vittala Temple complex at Hampi, the open Ranga Mandapa contains 56 monolithic pillars carved from solid granite. When gently tapped by priests and classical musicians centuries ago, each sub-pillar produced notes of different instruments—the Ghatam, Mridangam, Damru, and Jalatarangam.\n\nBritish geologists in the 19th century were so puzzled by how solid granite could emit distinct musical notes that they cut two pillars open to inspect the interior—only to discover they were carved from single solid stone blocks. Modern metallurgical and acoustic tests show varying densities of silica and iron inside the stone that produce distinct resonance frequencies.',
      fullStoryParagraphs: [
        'In the Vittala Temple at Hampi, the Ranga Mandapa contains 56 monolithic pillars carved from solid granite.',
        'When struck gently, the sub-pillars produce clear musical notes corresponding to the Sapta Swaras (seven notes) and percussion instruments.',
        'Ancient stone artisans selected specific granite rocks with micro-variations in iron and silica to achieve resonant pitch.',
        'This acoustic wizardry turned the stone temple into a living orchestra for classical dancers and sacred rituals.'
      ],
      narrator: 'Pandit Raghavendra Rao, Carnatic Musicologist',
      readTimeMinutes: 3,
      era: 'Vijayanagara Empire (15th Century)',
      imageUrl: 'https://images.unsplash.com/photo-1600100397608-f010f443b793?auto=format&fit=crop&w=1200&q=80',
      culturalSignificance: 'Highlights the acoustic engineering and sonic architecture mastered during the Vijayanagara renaissance.',
      tags: ['Hampi', 'Musical Pillars', 'Vijayanagara', 'Acoustic Science', 'Carnatic Heritage'],
    ),
    const CulturalStory(
      id: 'story-4',
      title: 'The Legend of the Sheesh Mahal Mirrors',
      hindiTitle: 'शीश महल और प्रकाश का जादू',
      associatedSiteId: 'site-4',
      associatedSiteName: 'Amer Fort & Palace',
      category: 'Royal Legends',
      summary: 'How royal craftsmen in Jaipur imported convex glass from Belgium to create a winter palace where a single earthen lamp lit the entire celestial dome.',
      content: 'Within the amber stone bastions of Amer Fort lies the Sheesh Mahal—the Hall of Mirrors. Constructed in 1623 by Mirza Raja Jai Singh, the palace was designed so that the queen could gaze upon the stars without stepping out into the cold night breeze.\n\nCraftsmen hand-cut thousands of tiny convex mirrors and set them into floral plaster arabesques. At night, when a single candle or ghee lamp is lit in the center of the hall, the concave and convex curvatures reflect light across the ceiling, creating the breathtaking illusion of a glittering starry sky inside the chamber.',
      fullStoryParagraphs: [
        'Within Amer Fort lies the Sheesh Mahal, built in the 17th century with convex mirrors imported from Belgium.',
        'Designed to keep royal chambers warm during winter, the mirrors reflect heat and illuminate the hall with minimal candles.',
        'A single flickering flame creates the illusion of thousands of twinkling stars across the ornate ceiling.',
        'It symbolizes the fusion of Rajput valor, Mughal elegance, and Persian decorative arts.'
      ],
      narrator: 'Kunwar Digvijay Singh, Royal Historian',
      readTimeMinutes: 4,
      era: 'Kachwaha Rajput Dynasty (1623 CE)',
      imageUrl: 'https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=1200&q=80',
      culturalSignificance: 'Exemplifies Rajput-Mughal architectural synthesis and decorative glass craftsmanship.',
      tags: ['Amer Fort', 'Sheesh Mahal', 'Jaipur', 'Rajput Heritage', 'Mirrors'],
    ),
  ];
}
