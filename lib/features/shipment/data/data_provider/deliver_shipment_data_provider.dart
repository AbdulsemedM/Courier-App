import 'dart:io';
import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/core/utils/image_compression_helper.dart';
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

      File? uploadFile = customerIdFile;
      if (uploadFile != null) {
        final fileSize = await uploadFile.length();
        if (fileSize > ImageCompressionHelper.maxUploadBytes) {
          uploadFile = await ImageCompressionHelper.compressForUpload(uploadFile);
        }
      }

      final response = await apiProvider.postMultipartRequest(
        '/api/v1/shipments/deliver',
        fields,
        uploadFile,
        'customerIdFile',
      );

      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

