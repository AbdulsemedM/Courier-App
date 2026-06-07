import 'package:courier_app/features/manifest/data/model/manifest_model.dart';
import 'package:courier_app/features/manifest/data/repository/manifest_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manifest_event.dart';
part 'manifest_state.dart';

class ManifestBloc extends Bloc<ManifestEvent, ManifestState> {
  final ManifestRepository manifestRepository;

  int? _lastBranchId;
  String? _lastDate;

  ManifestBloc({required this.manifestRepository}) : super(ManifestInitial()) {
    on<FetchManifests>(_onFetchManifests);
    on<CreateManifest>(_onCreateManifest);
    on<AddAwbsToManifest>(_onAddAwbsToManifest);
    on<RemoveAwbFromManifest>(_onRemoveAwbFromManifest);
  }

  Future<void> _onFetchManifests(
    FetchManifests event,
    Emitter<ManifestState> emit,
  ) async {
    _lastBranchId = event.branchId;
    _lastDate = event.date;
    emit(FetchManifestsLoading());
    try {
      final manifests = await manifestRepository.fetchManifests(
        branchId: event.branchId,
        date: event.date,
      );
      emit(FetchManifestsSuccess(manifests: manifests));
    } catch (e) {
      emit(FetchManifestsFailure(message: e.toString()));
    }
  }

  Future<void> _onCreateManifest(
    CreateManifest event,
    Emitter<ManifestState> emit,
  ) async {
    emit(CreateManifestLoading());
    try {
      final message = await manifestRepository.createManifest(
        awbs: event.awbs,
        fileType: event.fileType,
        userId: event.userId,
      );
      emit(CreateManifestSuccess(message: message));

      if (_lastBranchId != null && _lastDate != null) {
        add(FetchManifests(branchId: _lastBranchId!, date: _lastDate!));
      }
    } catch (e) {
      emit(CreateManifestFailure(message: e.toString()));
    }
  }

  Future<void> _onAddAwbsToManifest(
    AddAwbsToManifest event,
    Emitter<ManifestState> emit,
  ) async {
    emit(ManifestAwbActionLoading());
    try {
      final message = await manifestRepository.addAwbsToManifest(
        manifestId: event.manifestId,
        awbs: event.awbs,
      );
      emit(ManifestAwbActionSuccess(message: message));
      add(FetchManifests(branchId: event.branchId, date: event.date));
    } catch (e) {
      emit(ManifestAwbActionFailure(message: e.toString()));
    }
  }

  Future<void> _onRemoveAwbFromManifest(
    RemoveAwbFromManifest event,
    Emitter<ManifestState> emit,
  ) async {
    emit(ManifestAwbActionLoading());
    try {
      final message = await manifestRepository.removeAwbFromManifest(
        manifestId: event.manifestId,
        awb: event.awb,
      );
      emit(ManifestAwbActionSuccess(message: message));
      add(FetchManifests(branchId: event.branchId, date: event.date));
    } catch (e) {
      emit(ManifestAwbActionFailure(message: e.toString()));
    }
  }
}
