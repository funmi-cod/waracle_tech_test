import 'dart:convert';
import 'package:http/http.dart' as http;

/// Performs HTTP requests for cake data.
class RequestClient {
  final http.Client _httpClient;

  RequestClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Fetches cake list from API and returns as a list of JSON objects.
  /// Throws exception if request fails or response format is invalid.
  Future<List<dynamic>> fetchCakes() async {
    final url = Uri.parse(
        "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList");

    final response = await _httpClient.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch cakes');
    }

    final decodedResponse = json.decode(response.body);
    if (decodedResponse is List) {
      return decodedResponse;
    } else {
      throw Exception('Unexpected response format');
    }
  }
}
