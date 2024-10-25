sealed class ServiceLocator {
  static final _services = <Type, dynamic>{};

  static void addSingleton<T>(T singleton) => _services[T] = singleton;

  static T get<T>() => _services[T];
}
