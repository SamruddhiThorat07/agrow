import 'package:flutter/material.dart';
import '../models/market_price.dart';
import '../services/market_service.dart';

class MarketProvider extends ChangeNotifier {
  final MarketService _marketService = MarketService();
  List<MarketPrice> _prices = [];
  bool _isLoading = false;
  String? _error;
  
  // Filter states
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedCommodity;
  String? _searchQuery;
  List<String> _availableStates = [];
  List<String> _availableDistricts = [];
  List<String> _availableCommodities = [];

  // Location states
  bool _isLoadingLocation = false;
  String? _currentState;
  String? _currentDistrict;

  // Getters
  List<MarketPrice> get prices => _filterPrices();
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get availableStates => _availableStates;
  List<String> get availableDistricts => _availableDistricts;
  List<String> get availableCommodities => _availableCommodities;
  String? get selectedState => _selectedState;
  String? get selectedDistrict => _selectedDistrict;
  String? get selectedCommodity => _selectedCommodity;
  bool get isLoadingLocation => _isLoadingLocation;
  String? get currentState => _currentState;
  String? get currentDistrict => _currentDistrict;

  MarketProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      _isLoading = true;
      _isLoadingLocation = true;
      notifyListeners();

      // Get current location
      _currentState = await _marketService.getCurrentState();
      _currentDistrict = await _marketService.getCurrentDistrict();
      
      // Set initial filters to current location
      _selectedState = _currentState;
      _selectedDistrict = _currentDistrict;

      // Load available states and districts
      _availableStates = await _marketService.getStates();
      if (_selectedState != null) {
        _availableDistricts = await _marketService.getDistricts(_selectedState!);
      }
      _availableCommodities = await _marketService.getCommodities();

      // Fetch prices for current location
      await fetchPrices();

      _isLoadingLocation = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingLocation = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  List<MarketPrice> _filterPrices() {
    return _prices.where((price) {
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        if (!price.commodity.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<void> fetchPrices() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prices = await _marketService.getMarketPrices(
        state: _selectedState,
        district: _selectedDistrict,
        commodity: _selectedCommodity,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateFilters({
    String? state,
    String? district,
    String? commodity,
    String? search,
  }) async {
    _selectedState = state;
    _selectedDistrict = district;
    _selectedCommodity = commodity;
    _searchQuery = search;

    if (state != null && state != _selectedState) {
      _availableDistricts = await _marketService.getDistricts(state);
      _selectedDistrict = null;
    }

    fetchPrices();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
} 