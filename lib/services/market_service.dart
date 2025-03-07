import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/market_price.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MarketService {
  static const String baseUrl = 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070';
  
  Future<List<MarketPrice>> getMarketPrices({
    String? state,
    String? district,
    String? commodity,
    String? sortBy,
  }) async {
    try {
      final apiKey = dotenv.env['AGMARKNET_API_KEY'];
      if (apiKey == null) throw Exception('API key not found');

      final queryParams = {
        'api-key': apiKey,
        'format': 'json',
        'limit': '100',
        if (state != null) 'filters[state]': state,
        if (district != null) 'filters[district]': district,
        if (commodity != null) 'filters[commodity]': commodity,
        if (sortBy != null) 'sort[modal_price]': sortBy,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      print('Fetching from: $uri'); // For debugging

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['records'] == null) {
          throw Exception('No market data available');
        }
        
        final records = data['records'] as List;
        return records.map((record) => MarketPrice.fromJson(record)).toList();
      } else {
        throw Exception('Failed to load market prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching market prices: $e');
    }
  }

  Future<List<String>> getStates() async {
    try {
      final apiKey = dotenv.env['AGMARKNET_API_KEY'];
      if (apiKey == null) throw Exception('API key not found');

      final uri = Uri.parse('$baseUrl?api-key=$apiKey&format=json&limit=1000&select=state');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final records = data['records'] as List;
        final states = records.map((record) => record['state'] as String).toSet().toList();
        states.sort();
        return states;
      } else {
        throw Exception('Failed to load states');
      }
    } catch (e) {
      throw Exception('Error fetching states: $e');
    }
  }

  Future<List<String>> getDistricts(String state) async {
    try {
      final apiKey = dotenv.env['AGMARKNET_API_KEY'];
      if (apiKey == null) throw Exception('API key not found');

      final uri = Uri.parse('$baseUrl?api-key=$apiKey&format=json&limit=1000&filters[state]=$state&select=district');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final records = data['records'] as List;
        final districts = records.map((record) => record['district'] as String).toSet().toList();
        districts.sort();
        return districts;
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      throw Exception('Error fetching districts: $e');
    }
  }

  Future<List<String>> getCommodities() async {
    try {
      final apiKey = dotenv.env['AGMARKNET_API_KEY'];
      if (apiKey == null) throw Exception('API key not found');

      final uri = Uri.parse('$baseUrl?api-key=$apiKey&format=json&limit=1000&select=commodity');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final records = data['records'] as List;
        final commodities = records.map((record) => record['commodity'] as String).toSet().toList();
        commodities.sort();
        return commodities;
      } else {
        throw Exception('Failed to load commodities');
      }
    } catch (e) {
      throw Exception('Error fetching commodities: $e');
    }
  }

  Future<String?> getCurrentState() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();
      
      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.administrativeArea; // Returns state name
      }
      return null;
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }

  Future<String?> getCurrentDistrict() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.subAdministrativeArea; // Returns district name
      }
      return null;
    } catch (e) {
      throw Exception('Error getting district: $e');
    }
  }
} 