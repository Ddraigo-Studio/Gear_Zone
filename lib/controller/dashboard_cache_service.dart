// A helper service to cache dashboard data
import 'package:intl/intl.dart';

class DashboardCacheService {
  // Singleton
  static final DashboardCacheService _instance = DashboardCacheService._internal();
  factory DashboardCacheService() => _instance;
  DashboardCacheService._internal();

  // Cache storage
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheExpiry = {};
  
  // Default cache duration: 15 minutes
  final Duration defaultCacheDuration = const Duration(minutes: 15);
  
  // Create a cache key from operation name and parameters
  String createCacheKey(String operation, DateTime startDate, DateTime endDate, [String? additionalParam]) {
    final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);
    return '$operation-$startDateStr-$endDateStr${additionalParam != null ? '-$additionalParam' : ''}';
  }
  
  // Check if data exists in cache and is still valid
  bool hasValidCache(String cacheKey) {
    if (!_cache.containsKey(cacheKey) || !_cacheExpiry.containsKey(cacheKey)) {
      return false;
    }
    return DateTime.now().isBefore(_cacheExpiry[cacheKey]!);
  }
  
  // Get data from cache
  T? getFromCache<T>(String cacheKey) {
    if (hasValidCache(cacheKey)) {
      return _cache[cacheKey] as T;
    }
    return null;
  }
  
  // Store data in cache with expiration
  void storeInCache(String cacheKey, dynamic data, [Duration? duration]) {
    _cache[cacheKey] = data;
    _cacheExpiry[cacheKey] = DateTime.now().add(duration ?? defaultCacheDuration);
  }
  
  // Clear specific cache entries by operation
  void clearCache([String? operation]) {
    if (operation == null) {
      _cache.clear();
      _cacheExpiry.clear();
    } else {
      final keysToRemove = _cache.keys.where((key) => key.startsWith('$operation-')).toList();
      for (final key in keysToRemove) {
        _cache.remove(key);
        _cacheExpiry.remove(key);
      }
    }
  }
  
  // Check cache size
  int get cacheSize => _cache.length;
}
