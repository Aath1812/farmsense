class WeatherModel {
  final String city;
  final double temp;
  final String condition;
  final String iconCode;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.condition,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // 1. Safely extract nested maps to avoid crashes if they are null
    final mainData = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];

    // 2. Safely get the first item from the weather list
    final weatherItem = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    return WeatherModel(
      // 3. Use '??' to provide default values if any field is null
      city: (json['name'] as String?) ?? 'Unknown City',

      // Handle 'int' vs 'double' confusion automatically using 'num'
      temp: (mainData['temp'] as num?)?.toDouble() ?? 0.0,

      condition: (weatherItem['main'] as String?) ?? 'Unknown',

      iconCode: (weatherItem['icon'] as String?) ?? '01d',
    );
  }

  // For mock data or when API fails
  factory WeatherModel.mock() {
    return WeatherModel(
      city: "Mockville",
      temp: 28.0,
      condition: "Sunny",
      iconCode: "01d", // Default sunny icon
    );
  }
}