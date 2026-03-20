import 'package:flutter/widgets.dart';

class Command<T> extends ChangeNotifier {
  Command({
    required this.data,
    this.isLoading = false,
    this.error,
  });

  T data;
  bool isLoading;
  String? error;

  void toggleLoading() {
    isLoading = !isLoading;
    if (isLoading) {
      error = null;
    }
    execute();
  }

  void setData(T newData) {
    data = newData;
    isLoading = false;
    error = null;
    execute();
  }

  void setError(String newError) {
    error = newError;
    isLoading = false;
    execute();
  }

  void start() {
    isLoading = true;
    error = null;
    execute();
  }

  void clear() {
    isLoading = false;
    error = null;
    execute();
  }

  void execute() => notifyListeners();
}
