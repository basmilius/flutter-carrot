import 'package:get_it/get_it.dart';

class CarrotServiceLocator {
  static final GetIt instance = GetIt.instance;

  static T get<T extends Object>() => instance.get<T>();

  static Future<T> getAsync<T extends Object>() => instance.getAsync<T>();

  static void register<T extends Object>(T service) => instance.registerSingleton<T>(service);

  static void registerLazy<T extends Object>(FactoryFunc<T> factory) => instance.registerLazySingleton<T>(factory);
}
