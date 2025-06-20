// provider_setup.dart
import 'package:courier_app/core/services/cache_service.dart';
import 'api_provider.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

class ProviderSetup {
  static final CacheService cacheService = CacheService();

  static ApiProvider getApiProvider(String baseUrl, {String? authToken}) {
    return ApiProvider(
      // baseUrl: baseUrl,
      authInterceptor: AuthInterceptor(token: authToken),
      errorInterceptor: ErrorInterceptor(),
      loggingInterceptor: LoggingInterceptor(),
    );
  }

  static CacheService getCacheService() {
    return cacheService;
  }
}
