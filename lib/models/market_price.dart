class MarketPrice {
  final String state;
  final String district;
  final String market;
  final String commodity;
  final String variety;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final String date;

  MarketPrice({
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.variety,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.date,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      market: json['market'] ?? '',
      commodity: json['commodity'] ?? '',
      variety: json['variety'] ?? '',
      minPrice: double.tryParse(json['min_price'].toString()) ?? 0.0,
      maxPrice: double.tryParse(json['max_price'].toString()) ?? 0.0,
      modalPrice: double.tryParse(json['modal_price'].toString()) ?? 0.0,
      date: json['arrival_date'] ?? '',
    );
  }
} 