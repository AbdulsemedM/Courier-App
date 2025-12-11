import 'dart:io';
import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class DeliverShipmentDataProvider {
  Future<String> deliverShipment({
    required String awb,
    required bool isSelf,
    File? customerIdFile,
    String? deliveredToName,
    String? deliveredToPhone,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      
      final fields = <String, String>{
        'awb': awb,
        'isSelf': isSelf ? 'true' : 'false',
      };
      
      if (!isSelf) {
        if (deliveredToName != null) {
          fields['deliveredToName'] = deliveredToName;
        }
        if (deliveredToPhone != null) {
          fields['deliveredToPhone'] = deliveredToPhone;
        }
      }
      
      final response = await apiProvider.postMultipartRequest(
        '/api/v1/shipments/deliver',
        fields,
        customerIdFile,
        'customerIdFile',
      );
      
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

