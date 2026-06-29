import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/branch_report/data/repository/branch_report_repository.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_report_summary.dart';

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
      final result = await repository.fetchBranchShipments(
        branchId: event.branchId,
        startDate: event.startDate,
        endDate: event.endDate,
        search: event.search,
      );
      emit(
        BranchReportLoaded(
          shipments: result.shipments,
          summary: result.summary,
          branchName: result.branchName,
        ),
      );
    } catch (e) {
      emit(BranchReportError(message: e.toString()));
    }
  }
}
