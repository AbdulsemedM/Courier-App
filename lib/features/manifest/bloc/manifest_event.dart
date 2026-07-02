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
  final String? masterAwbAirline;

  const CreateManifest({
    required this.awbs,
    required this.fileType,
    required this.userId,
    this.masterAwbAirline,
  });

  @override
  List<Object> get props => [awbs, fileType, userId, masterAwbAirline ?? ''];
}

class UpdateManifest extends ManifestEvent {
  final int manifestId;
  final List<String> awbs;
  final String fileType;
  final int userId;
  final int branchId;
  final String date;

  const UpdateManifest({
    required this.manifestId,
    required this.awbs,
    required this.fileType,
    required this.userId,
    required this.branchId,
    required this.date,
  });

  @override
  List<Object> get props => [manifestId, awbs, fileType, userId, branchId, date];
}

class RemoveAwbFromManifest extends ManifestEvent {
  final int manifestId;
  final String awb;
  final int branchId;
  final String date;

  const RemoveAwbFromManifest({
    required this.manifestId,
    required this.awb,
    required this.branchId,
    required this.date,
  });

  @override
  List<Object> get props => [manifestId, awb, branchId, date];
}
