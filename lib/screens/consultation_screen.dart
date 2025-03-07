import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  _ConsultationScreenState createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  String selectedFilter = 'All';  // Change back to simple string
  final searchController = TextEditingController();
  String searchQuery = '';  // Add this variable to track search input

  // Mock data for experts
  final List<Map<String, dynamic>> experts = [
    {
      'name': 'Dr. Rajesh Kumar',
      'image': 'assets/expert1.jpg',
      'specialization': 'Crop Disease Specialist',
      'experience': '15 years of experience in crop disease management and prevention',
      'tags': ['Crops', 'Disease Control'],
      'fee': '500',
      'rating': 4.8,
      'type': 'Crops',
    },
    {
      'name': 'Dr. Priya Sharma',
      'image': 'assets/expert2.jpg',
      'specialization': 'Soil Scientist',
      'experience': 'Expert in soil health and fertility management',
      'tags': ['Soil', 'Fertility'],
      'fee': '600',
      'rating': 4.9,
      'type': 'Soil',
    },
    {
      'name': 'Amit Patel',
      'image': 'assets/expert3.jpg',
      'specialization': 'Government Scheme Advisor',
      'experience': 'Specialized in agricultural schemes and subsidies',
      'tags': ['Government', 'Subsidies'],
      'fee': '400',
      'rating': 4.7,
      'type': 'Govt.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize search controller
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize selectedFilter with translated value if not already set
    selectedFilter ??= AppLocalizations.of(context)!.filterAll;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Add this method to filter experts
  List<Map<String, dynamic>> getFilteredExperts() {
    return experts.where((expert) {
      final matchesFilter = selectedFilter == 'All' || expert['type'] == selectedFilter;
      final matchesSearch = searchQuery.isEmpty ||
          expert['name'].toString().toLowerCase().contains(searchQuery) ||
          expert['specialization'].toString().toLowerCase().contains(searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final filteredExperts = getFilteredExperts();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.expertConsultationTitle),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: appLocalizations.searchExpertsHint,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  selected: selectedFilter == appLocalizations.filterAll,
                  label: Text(appLocalizations.filterAll),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = appLocalizations.filterAll;
                    });
                  },
                  selectedColor: const Color(0xFF8BC34A).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF8BC34A),
                ),
                SizedBox(width: 8),
                FilterChip(
                  selected: selectedFilter == appLocalizations.filterCrops,
                  label: Text(appLocalizations.filterCrops),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = appLocalizations.filterCrops;
                    });
                  },
                  selectedColor: const Color(0xFF8BC34A).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF8BC34A),
                ),
                FilterChip(
                  selected: selectedFilter == appLocalizations.filterSoil,
                  label: Text(appLocalizations.filterSoil),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = appLocalizations.filterSoil;
                    });
                  },
                  selectedColor: const Color(0xFF8BC34A).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF8BC34A),
                ),
                FilterChip(
                  selected: selectedFilter == appLocalizations.filterGovt,
                  label: Text(appLocalizations.filterGovt),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = appLocalizations.filterGovt;
                    });
                  },
                  selectedColor: const Color(0xFF8BC34A).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF8BC34A),
                ),
              ],
            ),
          ),

          // Experts List or No Results Message
          Expanded(
            child: filteredExperts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          appLocalizations.noExpertsFound,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          appLocalizations.tryDifferentSearch,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: filteredExperts.length,
                    itemBuilder: (context, index) {
                      final expert = filteredExperts[index];
                      return ExpertCard(
                        expert: expert,
                        appLocalizations: appLocalizations,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ExpertCard extends StatelessWidget {
  final Map<String, dynamic> expert;
  final AppLocalizations appLocalizations;

  const ExpertCard({
    super.key,
    required this.expert,
    required this.appLocalizations,
  });

  @override
  Widget build(BuildContext context) {
    // Move getTagColor logic inside build
    Color getTagColor(String type) {
      switch (type) {
        case String t when t == appLocalizations.expertType1:
          return Colors.green;
        case String t when t == appLocalizations.expertType2:
          return Colors.blue;
        case String t when t == appLocalizations.expertType3:
          return Colors.purple;
        default:
          return Colors.grey;
      }
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        expert['specialization'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(expert['experience']),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: (expert['tags'] as List).map<Widget>((tagKey) {
                return Chip(
                  label: Text(
                    tagKey == 'Crops' ? appLocalizations.tagCrops :
                    tagKey == 'Disease Control' ? appLocalizations.tagDisease :
                    tagKey == 'Soil' ? appLocalizations.tagSoil :
                    tagKey == 'Fertility' ? appLocalizations.tagFertility :
                    tagKey == 'Government' ? appLocalizations.tagGovt :
                    appLocalizations.tagSubsidies,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: getTagColor(
                    expert['type'] == 'Crops' ? appLocalizations.expertType1 :
                    expert['type'] == 'Soil' ? appLocalizations.expertType2 :
                    appLocalizations.expertType3
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.feePerSession(expert['fee']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      expert['rating'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.chat, color: Colors.black),
                  label: Text(appLocalizations.chatButton, style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.phone, color: Colors.black),
                  label: Text(appLocalizations.callButton, style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.videocam, color: Colors.white),
                  label: Text(appLocalizations.videoButton, style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}