sealed class BaseModel<T> {}

class Loading<T> extends BaseModel<T> {}

class Model<T> extends BaseModel<T> {
  final List<T> datas;

  Model(this.datas);
}
