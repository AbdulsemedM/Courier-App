import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/admin_report/data/repository/admin_report_repository.dart';
import 'package:courier_app/features/admin_report/data/model/admin_shipment_model.dart';

part 'admin_report_event.dart';
part 'admin_report_state.dart';

class AdminReportBloc extends Bloc<AdminReportEvent, AdminReportState> {
  final AdminReportRepository repository;

  AdminReportBloc({required this.repository}) : super(AdminReportInitial()) {
    on<FetchAdminShipments>(_onFetchAdminShipments);
  }

  Future<void> _onFetchAdminShipments(
    FetchAdminShipments event,
    Emitter<AdminReportState> emit,
  ) async {
    emit(AdminReportLoading());
    try {
      final shipments = await repository.fetchAdminShipments(
        branchId: event.branchId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(AdminReportLoaded(shipments: shipments));
    } catch (e) {
      emit(AdminReportError(message: e.toString()));
    }
  }
}

