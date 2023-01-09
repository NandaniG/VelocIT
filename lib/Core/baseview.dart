
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'Enum/viewState.dart';



GetIt getIt = GetIt.instance;

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T) onModelReady;

  const BaseView({required this.builder,   required this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = getIt<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
    print("errorsssssssss");

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: model,
        child:   Consumer<T>(builder: widget.builder),);
  }
}


class BaseModel extends ChangeNotifier {

  ViewState _state = ViewState.IDLE;
  ViewState get state => _state;

  late ApiError error;

  /// Returns true when a request did not return an error.
  bool get success => error == null;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  bool isNotError(dynamic response) {
    if (response is ApiError) {
      error = response;
      return false;
    } else {
      return true;
    }
  }
}
class ApiError {
  String status='';

  ApiError({ required this.status});

  ApiError.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}
