import 'package:equatable/equatable.dart';
import 'package:cake_it_app/src/features/cakes/models/cake.dart';

/// Represents all possible states of CakeBloc
/// such as loading data, displaying cakes, or showing errors.
abstract class CakeState extends Equatable {
  const CakeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any cake data is loaded.
class CakeInitial extends CakeState {}

/// State when cake data is being loaded.
/// The UI should display a loading indicator or shimmer effect
/// while data is being fetched.
class CakeLoading extends CakeState {}

/// State when cake data has been successfully loaded.
/// Returns list of cake data
class CakeLoaded extends CakeState {
  final List<Cake> cakes;

  const CakeLoaded({required this.cakes});

  @override
  List<Object?> get props => [cakes];
}

/// State when an error occurs while fetching cakes.
/// Returns the error message
class CakeError extends CakeState {
  final String message;

  const CakeError({required this.message});

  @override
  List<Object?> get props => [message];
}
