import 'package:pizza_user_app/services/models/connected_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with
        ConnectedModel,
        AuthModel,
        Utilities {}
