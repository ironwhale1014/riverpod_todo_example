sealed class BaseModel<T> {}

class Loading<T> extends BaseModel<T> {}

class Model<T> extends BaseModel<T> {
  final List<T> data;

  Model(this.data);
}

class EmptyModel<T> extends Model<T> {
  EmptyModel(super.data);
}
