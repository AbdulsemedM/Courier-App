part of 'manifest_bloc.dart';

sealed class ManifestEvent extends Equatable {
  const ManifestEvent();

  @override
  List<Object> get props => [];
}

class FetchManifests extends ManifestEvent {
  final int branchId;
  final String date;

  const FetchManifests({required this.branchId, required this.date});

  @override
  List<Object> get props => [branchId, date];
}

class CreateManifest extends ManifestEvent {
  final List<String> awbs;
  final String fileType;
  final int userId;

  const CreateManifest({
    required this.awbs,
    required this.fileType,
    required this.userId,
  });

  @override
  List<Object> get props => [awbs, fileType, userId];
}
