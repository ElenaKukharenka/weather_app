import 'dart:convert';
import 'dart:developer';

import 'package:weather/models/weather_forecast_daily.dart';
import 'package:weather/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:weather/utilities/location.dart';

class WeatherApi {
  //прогноз по названию города
  Future<WeatherForecast> fetchWeatherForecast(
      {String cityName, bool isCity}) async {
    Location location = Location();
    await location.getCurrentLocation();

    Map<String, String> parameters;

    if (isCity == true) {
      var queryParameters = {
        //готовим запрос с параметрами
        'APPID': Constants.WEATHER_APP_ID,
        'units': 'metric',
        'q': cityName,
      };
      parameters = queryParameters;
    } else {
      var queryParameters = {
        'APPID': Constants.WEATHER_APP_ID,
        'units': 'metric',
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
      };
      parameters = queryParameters;
    }
//строим url
    var uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
        Constants.WEATHER_FORECAST_PATH, parameters);
//выводим uri в log
    log('reauest: ${uri.toString()}');
//запрос
    var response = await http.get(uri);
//выводим результат
    print('response: ${response?.body}');
//распарсим модель , если запрос успешный
    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error response');
    }
  }
}