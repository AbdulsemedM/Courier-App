import 'package:courier_app/features/add_shipment/data/data_provider/add_shipment_data_provider.dart';
import 'package:courier_app/features/add_shipment/data/repository/add_shipment_repository.dart';
import 'package:courier_app/providers/provider_setup.dart';

class AddShipmentRepositoryFactory {
  static AddShipmentRepository create() {
    return AddShipmentRepository(
      addShipmentDataProvider: AddShipmentDataProvider(),
      cacheService: ProviderSetup.getCacheService(),
    );
  }
}
