import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:demo/Utils.dart';

class LoginViewModel {
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    sink.add(Utils.validateEmail(email));
  });
  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    sink.add(Utils.validatePass(pass));
  });

  Stream<String> get emailStream => _emailSubject.stream.transform(emailValidation);

  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream => _passwordSubject.stream.transform(passValidation);

  Sink<String> get passSink => _passwordSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;

  Sink<bool> get btnSink => _btnSubject.sink;

  LoginViewModel() {
    Rx.combineLatest2(_emailSubject, _passwordSubject, (email, pass) {
      return Utils.validateEmail(email) == null &&
          Utils.validatePass(pass) == null;
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    _btnSubject.close();
  }
}
