export 'fire_storage_platform.dart'
    if (dart.library.html) 'web_fire_storage.dart'
    if (dart.library.io) 'mobile_fire_storage.dart';
