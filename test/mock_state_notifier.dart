import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockStateNotifier<T> extends StateNotifier<T> with Mock {
  MockStateNotifier(super.state);

  @override
  set state(T newState);
}
