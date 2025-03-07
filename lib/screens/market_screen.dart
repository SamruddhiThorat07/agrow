import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/market_provider.dart';
import '../models/market_price.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final _searchController = TextEditingController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
    _setupAutoRefresh();
  }

  void _setupAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (_) => _refreshData());
  }

  void _refreshData() {
    context.read<MarketProvider>().fetchPrices();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple[700]!,
              Colors.deepPurple[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildFilters(),
              Expanded(
                child: _buildPricesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Market Prices',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refreshData,
                  ),
                ],
              ),
              if (provider.isLoadingLocation)
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Getting your location...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              else if (provider.currentState != null)
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${provider.currentDistrict ?? ''}, ${provider.currentState}',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search commodities...',
          prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.deepPurple),
                  onPressed: () {
                    _searchController.clear();
                    context.read<MarketProvider>().setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          context.read<MarketProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Select State',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip(
                    'All States',
                    provider.selectedState == null,
                    onSelected: (_) {
                      provider.updateFilters(state: null);
                    },
                  ),
                  ...provider.availableStates.map((state) {
                    return _buildFilterChip(
                      state,
                      provider.selectedState == state,
                      onSelected: (_) {
                        provider.updateFilters(state: state);
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            if (provider.selectedState != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Select District',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip(
                      'All Districts',
                      provider.selectedDistrict == null,
                      onSelected: (_) {
                        provider.updateFilters(
                          state: provider.selectedState,
                          district: null,
                        );
                      },
                    ),
                    ...provider.availableDistricts.map((district) {
                      return _buildFilterChip(
                        district,
                        provider.selectedDistrict == district,
                        onSelected: (_) {
                          provider.updateFilters(
                            state: provider.selectedState,
                            district: district,
                          );
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {required Function(bool) onSelected}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != 'All States' && label != 'All Districts')
              Icon(
                Icons.location_on,
                size: 16,
                color: isSelected ? Colors.white : Colors.deepPurple,
              ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.deepPurple,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.white,
        selectedColor: Colors.deepPurple,
        checkmarkColor: Colors.white,
        elevation: 2,
      ),
    );
  }

  Widget _buildPricesList() {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingShimmer();
        }

        if (provider.error != null) {
          return _buildError(provider.error!);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.prices.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildPriceCard(provider.prices[index]),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPriceCard(MarketPrice price) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.deepPurple[50]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.agriculture, color: Colors.deepPurple),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    price.commodity,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[900],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.deepPurple[300]),
                SizedBox(width: 8),
                Text(
                  '${price.market}, ${price.district}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriceInfo('Min', price.minPrice),
                _buildPriceInfo('Modal', price.modalPrice),
                _buildPriceInfo('Max', price.maxPrice),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, double price) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '₹${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple[700],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
