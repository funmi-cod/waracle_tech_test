import 'package:equatable/equatable.dart';

/// Handles all cake-related events.
/// Events are dispatched to the CakeBloc to trigger
/// actions like fetching or refreshing cakes.
abstract class CakeEvent extends Equatable {
  const CakeEvent();

  @override
  List<Object?> get props => [];
}

/// Load cakes from the data source.
class FetchCakes extends CakeEvent {}

/// Refresh the existing cake list.
class RefreshCakes extends CakeEvent {}
