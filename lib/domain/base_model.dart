sealed class BaseModel {}

class Loading extends BaseModel {}

class Model<T> extends BaseModel {
  final List<T> data;

  Model(this.data);
}

class EmptyModel<T> extends Model<T> {
  EmptyModel(super.data);
}
