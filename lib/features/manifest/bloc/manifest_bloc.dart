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
      final manifest = await manifestRepository.createManifest(
        awbs: event.awbs,
        fileType: event.fileType,
        userId: event.userId,
      );
      emit(CreateManifestSuccess(manifest: manifest));

      if (_lastBranchId != null && _lastDate != null) {
        add(FetchManifests(branchId: _lastBranchId!, date: _lastDate!));
      }
    } catch (e) {
      emit(CreateManifestFailure(message: e.toString()));
    }
  }
}
