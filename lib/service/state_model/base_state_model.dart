sealed class BaseStateModel<T> {}

class Loading<T> extends BaseStateModel<T> {}

class LoadedModel<T> extends BaseStateModel<T> {
  final List<T> datas;

  LoadedModel(this.datas);
}

class Error<T> extends BaseStateModel<T> {
  final String message;

  Error(this.message);
}
