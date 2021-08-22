import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide later.
/// You must override it in ProviderScope.
Provider<E> lateProvide<E>() {
  return Provider<E>((_) {
    throw UnimplementedError();
  });
}
