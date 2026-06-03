part of 'manifest_bloc.dart';

sealed class ManifestState extends Equatable {
  const ManifestState();

  @override
  List<Object> get props => [];
}

final class ManifestInitial extends ManifestState {}

final class FetchManifestsLoading extends ManifestState {}

final class FetchManifestsSuccess extends ManifestState {
  final List<ManifestModel> manifests;

  const FetchManifestsSuccess({required this.manifests});

  @override
  List<Object> get props => [manifests];
}

final class FetchManifestsFailure extends ManifestState {
  final String message;

  const FetchManifestsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateManifestLoading extends ManifestState {}

final class CreateManifestSuccess extends ManifestState {
  final ManifestModel manifest;

  const CreateManifestSuccess({required this.manifest});

  @override
  List<Object> get props => [manifest];
}

final class CreateManifestFailure extends ManifestState {
  final String message;

  const CreateManifestFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class ManifestAwbActionLoading extends ManifestState {}

final class ManifestAwbActionSuccess extends ManifestState {
  final String message;

  const ManifestAwbActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class ManifestAwbActionFailure extends ManifestState {
  final String message;

  const ManifestAwbActionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
