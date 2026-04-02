import 'package:cake_it_app/src/features/cakes/data/cake_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cake_event.dart';
import 'cake_state.dart';

/// CakeBloc handles all business logic related to cakes.
///
/// It listens to [CakeEvent]s such as fetching or refreshing cakes
/// and emits corresponding [CakeState]s like loading, loaded, or error.
///
/// This bloc communicates with the [CakeRepository] to retrieve cake data
/// from API
class CakeBloc extends Bloc<CakeEvent, CakeState> {
  final CakeRepository cakeRepository;

  /// Creates a CakeBloc with the required CakeRepository.
  ///
  /// The repository is injected to promote better testability and
  /// separation of concerns, allowing the use of mock or fake
  /// implementations during unit testing.
  CakeBloc({required this.cakeRepository}) : super(CakeInitial()) {
    /// Register event handlers
    on<FetchCakes>(_onFetchCakes);
    on<RefreshCakes>(_onRefreshCakes);
  }

  /// Handles the [FetchCakes] event.
  ///
  /// Emits:
  /// - [CakeLoading] while fetching data
  /// - [CakeLoaded] when data is successfully fetched
  /// - [CakeError] if an error occurs
  Future<void> _onFetchCakes(FetchCakes event, Emitter<CakeState> emit) async {
    emit(CakeLoading());
    try {
      final cakes = await cakeRepository.getCakes();
      emit(CakeLoaded(cakes: cakes));
    } catch (e) {
      emit(CakeError(message: e.toString()));
    }
  }

  /// Handles the [RefreshCakes] event.
  ///
  /// Refreshes cake data without emitting loading state,
  /// typically used for pull-to-refresh functionality.
  Future<void> _onRefreshCakes(
      RefreshCakes event, Emitter<CakeState> emit) async {
    try {
      final cakes = await cakeRepository.getCakes();
      emit(CakeLoaded(cakes: cakes));
    } catch (e) {
      emit(CakeError(message: e.toString()));
    }
  }
}
