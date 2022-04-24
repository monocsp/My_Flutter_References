import 'package:rxdart/rxdart.dart';

class RxIndexController {
  late int bottomIndex;
  late BehaviorSubject _subject;
  Function()? addListener;
  //Constructor(생성자)
  RxIndexController({int initIndex = 0, this.addListener}) {
    bottomIndex = initIndex;
    addListener ??= () {};
    _subject = BehaviorSubject.seeded(bottomIndex);
  }

  //streambuilder에서 stream에 연결될 부분
  Stream get stream => _subject.stream;

  jumpToIndex(int index) {
    if (index != bottomIndex) {
      bottomIndex = index;
      _subject.sink.add(bottomIndex);
      addListener!();
    }
  }
}
