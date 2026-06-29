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
  final Map<int, List<String>> _awbCache = {};

  ManifestBloc({required this.manifestRepository}) : super(ManifestInitial()) {
    on<FetchManifests>(_onFetchManifests);
    on<CreateManifest>(_onCreateManifest);
    on<UpdateManifest>(_onUpdateManifest);
    on<RemoveAwbFromManifest>(_onRemoveAwbFromManifest);
  }

  Future<List<String>> resolveManifestAwbs(ManifestModel manifest) async {
    final cached = _awbCache[manifest.id];
    if (cached != null && cached.isNotEmpty) {
      return List<String>.from(cached);
    }

    if (manifest.awbList.isNotEmpty) {
      _awbCache[manifest.id] = List<String>.from(manifest.awbList);
      return manifest.awbList;
    }

    final awbs = await manifestRepository.resolveManifestAwbs(manifest);
    if (awbs.isNotEmpty) {
      _awbCache[manifest.id] = List<String>.from(awbs);
    }
    return awbs;
  }

  List<ManifestModel> _mergeAwbs(List<ManifestModel> manifests) {
    return manifests
        .map((manifest) {
          final cached = _awbCache[manifest.id];
          if (cached == null || cached.isEmpty || manifest.awbList.isNotEmpty) {
            return manifest;
          }
          return manifest.copyWith(awbList: cached);
        })
        .toList();
  }

  void _cacheAwbs(int manifestId, List<String> awbs) {
    if (awbs.isEmpty) {
      _awbCache.remove(manifestId);
      return;
    }
    _awbCache[manifestId] = List<String>.from(awbs);
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
      emit(FetchManifestsSuccess(manifests: _mergeAwbs(manifests)));
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

  Future<void> _onUpdateManifest(
    UpdateManifest event,
    Emitter<ManifestState> emit,
  ) async {
    emit(ManifestAwbActionLoading());
    try {
      final message = await manifestRepository.updateManifest(
        manifestId: event.manifestId,
        awbs: event.awbs,
        fileType: event.fileType,
        userId: event.userId,
      );
      final cached = _awbCache[event.manifestId] ?? const <String>[];
      _cacheAwbs(
        event.manifestId,
        [...cached, ...event.awbs.where((awb) => !cached.contains(awb))],
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
      final cached = _awbCache[event.manifestId];
      if (cached != null) {
        _cacheAwbs(
          event.manifestId,
          cached.where((awb) => awb != event.awb).toList(),
        );
      }
      emit(ManifestAwbActionSuccess(message: message));
      add(FetchManifests(branchId: event.branchId, date: event.date));
    } catch (e) {
      emit(ManifestAwbActionFailure(message: e.toString()));
    }
  }
}
