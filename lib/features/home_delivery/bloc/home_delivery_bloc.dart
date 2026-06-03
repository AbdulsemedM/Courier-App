import 'package:courier_app/features/home_delivery/data/repository/home_delivery_repository.dart';
import 'package:courier_app/features/home_delivery/data/model/home_delivery_model.dart';
import 'package:courier_app/features/messenger/data/model/messenger_model.dart';
import 'package:courier_app/features/messenger/data/repository/messenger_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_delivery_event.dart';
part 'home_delivery_state.dart';

class HomeDeliveryBloc extends Bloc<HomeDeliveryEvent, HomeDeliveryState> {
  final HomeDeliveryRepository homeDeliveryRepository;
  final MessengerRepository messengerRepository;

  int? _lastBranchId;
  HomeDeliveryView _lastView = HomeDeliveryView.all;
  String? _lastStatus;

  HomeDeliveryBloc({
    required this.homeDeliveryRepository,
    required this.messengerRepository,
  }) : super(HomeDeliveryInitial()) {
    on<FetchHomeDeliveries>(_onFetchHomeDeliveries);
    on<FetchMessengers>(_onFetchMessengers);
    on<AssignMessenger>(_onAssignMessenger);
  }

  Future<void> _onFetchHomeDeliveries(
    FetchHomeDeliveries event,
    Emitter<HomeDeliveryState> emit,
  ) async {
    _lastBranchId = event.branchId;
    _lastView = event.view;
    _lastStatus = event.status;
    emit(FetchHomeDeliveriesLoading());
    try {
      final deliveries = await homeDeliveryRepository.fetchDeliveries(
        branchId: event.branchId,
        view: event.view,
        status: event.status,
      );
      emit(FetchHomeDeliveriesSuccess(deliveries: deliveries));
    } catch (e) {
      emit(FetchHomeDeliveriesFailure(message: e.toString()));
    }
  }

  Future<void> _onFetchMessengers(
    FetchMessengers event,
    Emitter<HomeDeliveryState> emit,
  ) async {
    final previous = state;
    emit(FetchMessengersLoading(previous: previous));
    try {
      final messengers = await messengerRepository.fetchMessengersByBranch(
        event.branchId,
        status: 'ACTIVE',
      );
      emit(FetchMessengersSuccess(
        messengers: messengers,
        previous: previous is FetchMessengersLoading ? previous.previous : previous,
      ));
    } catch (e) {
      emit(FetchMessengersFailure(
        message: e.toString(),
        previous: previous is FetchMessengersLoading ? previous.previous : previous,
      ));
    }
  }

  Future<void> _onAssignMessenger(
    AssignMessenger event,
    Emitter<HomeDeliveryState> emit,
  ) async {
    final previous = state;
    emit(AssignMessengerLoading(previous: previous));
    try {
      final message = await homeDeliveryRepository.assignMessenger(
        awb: event.awb,
        messengerId: event.messengerId,
        assignedBy: event.assignedBy,
        estimatedDeliveryTime: event.estimatedDeliveryTime,
      );
      emit(AssignMessengerSuccess(message: message, previous: previous));

      if (_lastBranchId != null) {
        add(FetchHomeDeliveries(
          branchId: _lastBranchId!,
          view: _lastView,
          status: _lastStatus,
        ));
      }
    } catch (e) {
      emit(AssignMessengerFailure(
        message: e.toString(),
        previous: previous is AssignMessengerLoading ? previous.previous : previous,
      ));
    }
  }
}
