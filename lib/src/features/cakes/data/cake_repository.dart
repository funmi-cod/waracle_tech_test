import 'package:cake_it_app/src/core/request_client.dart';
import 'package:cake_it_app/src/features/cakes/models/cake.dart';

/// Repository responsible for handling all cake-related data operations.
///
/// Acts as an abstraction layer between the data source (e.g., API)
/// and the business logic (Bloc), providing cake data in a usable format.
class CakeRepository {
  final RequestClient _requestClient;

  /// Creates a CakeRepository with an optional [RequestClient].
  ///
  /// Allows dependency injection for easier testing by passing
  /// a mock or fake client. Defaults to a new instance if none is provided.
  CakeRepository({RequestClient? reqClient})
      : _requestClient = reqClient ?? RequestClient();

  /// Fetches a list of cakes from the data source.
  ///
  /// Converts raw JSON response into a list of [Cake] model
  Future<List<Cake>> getCakes() async {
    final cakesJson = await _requestClient.fetchCakes();
    return cakesJson.map((dynamic json) => Cake.fromJson(json)).toList();
  }
}
