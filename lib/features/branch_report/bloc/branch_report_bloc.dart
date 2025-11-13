import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/branch_report/data/repository/branch_report_repository.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

part 'branch_report_event.dart';
part 'branch_report_state.dart';

class BranchReportBloc extends Bloc<BranchReportEvent, BranchReportState> {
  final BranchReportRepository repository;

  BranchReportBloc({required this.repository}) : super(BranchReportInitial()) {
    on<FetchBranchShipments>(_onFetchBranchShipments);
  }

  Future<void> _onFetchBranchShipments(
    FetchBranchShipments event,
    Emitter<BranchReportState> emit,
  ) async {
    emit(BranchReportLoading());
    try {
      final shipments = await repository.fetchBranchShipments(
        branchId: event.branchId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(BranchReportLoaded(shipments: shipments));
    } catch (e) {
      emit(BranchReportError(message: e.toString()));
    }
  }
}
