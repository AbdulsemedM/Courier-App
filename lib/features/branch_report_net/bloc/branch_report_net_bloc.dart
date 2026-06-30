import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_report_summary.dart';
import 'package:courier_app/features/branch_report_net/data/repository/branch_report_net_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'branch_report_net_event.dart';
part 'branch_report_net_state.dart';

class BranchReportNetBloc
    extends Bloc<BranchReportNetEvent, BranchReportNetState> {
  final BranchReportNetRepository repository;

  BranchReportNetBloc({required this.repository})
      : super(BranchReportNetInitial()) {
    on<FetchBranchReportNet>(_onFetchBranchReportNet);
  }

  Future<void> _onFetchBranchReportNet(
    FetchBranchReportNet event,
    Emitter<BranchReportNetState> emit,
  ) async {
    emit(BranchReportNetLoading());
    try {
      final result = await repository.fetchBranchReportNet(
        branchId: event.branchId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(
        BranchReportNetLoaded(
          shipments: result.shipments,
          summary: result.summary,
        ),
      );
    } catch (e) {
      emit(BranchReportNetError(message: e.toString()));
    }
  }
}
