import 'dart:async';

import './counter_event.dart';

class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  StreamSink<int> get _counterValueSink => _counterStateController.sink;

  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  StreamSink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementCounter) {
      _counter++;
    } else {
      _counter--;
    }

    // add is sort of like 'publish' in Rx terms
    _counterValueSink.add(_counter);
  }

  // Don't forget otherwise it would cause memory leak!
  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}
