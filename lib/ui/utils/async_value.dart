enum AsyncValueState { loading, success, error }

class AsyncValue<T> {
  final AsyncValueState state;
  final T? data;
  final Object? error;

  const AsyncValue._({required this.state, this.data, this.error});

  factory AsyncValue.loading() =>
      const AsyncValue._(state: AsyncValueState.loading);
  factory AsyncValue.success(T data) =>
      AsyncValue._(state: AsyncValueState.success, data: data);
  factory AsyncValue.error(Object error) =>
      AsyncValue._(state: AsyncValueState.error, error: error);

  bool get isLoading => state == AsyncValueState.loading;
  bool get isSuccess => state == AsyncValueState.success;
  bool get isError => state == AsyncValueState.error;
}
