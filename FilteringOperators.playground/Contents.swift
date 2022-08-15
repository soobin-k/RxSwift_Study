import RxSwift

let disposeBag = DisposeBag()

//📌 IgnoreElements
print("----IgnoreElements----")
// ✨ onNext 이벤트만 무시함

let 취침모드😴 = PublishSubject<String>()

취침모드😴.ignoreElements()
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

취침모드😴.onNext("🔔")
취침모드😴.onNext("🔔")
취침모드😴.onNext("🔔")

취침모드😴.onCompleted()

//📌 ElementAt
print("----ElementAt----")
// ✨ 특정 인덱스만 방출하고 나머지는 무시함

let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("🔔") // index 0
두번울면깨는사람.onNext("🔔") // index 1
두번울면깨는사람.onNext("🥺") // index 2
두번울면깨는사람.onNext("🔔") // index 3

//📌 Filter
print("----Filter----")
// ✨ filter 구문 내에 true인 값을 방출

Observable.of(1, 2, 3, 4, 5, 6, 7, 8) // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter{$0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//📌 Skip
print("----Skip----")
// ✨ 첫번째 요소부터 n개의 요소를 skip

Observable.of("😍", "🥰", "😘", "☺️", "😊", "🐸")
    .skip(5)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 SkipWhile
print("----SkipWhile----")
// ✨ skip할 로직이 false가 되었을 때부터 방출

Observable.of("😍", "🥰", "😘", "☺️", "😊", "🐸", "😴", "🥲")
    .skip(while: {
        $0 != "🐸"
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 SkipUntil
print("----SkipUntil----")
// ✨ 다른 Observable이 방출되기 전까지 현재 Observable이 방출하는 모든 이벤트를 무시
// ✨ 다른 Observable에 기반한 요소들을 filter하고 싶은 경우 사용

let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님 // 현재 Observable
    .skip(until: 문여는시간) // 다른 Observable
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("😊")
손님.onNext("😆")

문여는시간.onNext("🚪")
손님.onNext("😍")

//📌 Take
print("----Take----")
// ✨ 처음부터 n개의 값만 취함, skip의 반대 개념
Observable.of("🥇", "🥈", "🥉", "☺️", "😊")
    .take(3)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 TakeWhile
print("----TakeWhile----")
// ✨ take할 로직이 false가 되기 전까지 방출, skipWhile 반대 개념

Observable.of("🥇", "🥈", "🥉", "☺️", "😊")
    .take(while: {
        $0 != "🥉"
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 Enumerated
print("----Enumerated----")
// ✨ index와ㅏ element 둘다 방출, 방출된 요소의 인덱스를 참고하고 싶을 때 사용

Observable.of("🥇", "🥈", "🥉", "☺️", "😊")
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 TakeUntil
print("----TakeUntil----")
// ✨ 트리거가 되는 Observable가 구독되기 전까지의 이벤트만 받는다.

let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("🙋🏻‍♀️")
수강신청.onNext("🙋🏻")
신청마감.onNext("끝!")
수강신청.onNext("🙋🏻‍♂️")

//📌 DistinctUntilChanged
print("----DistinctUntilChanged----")
// ✨ 연달아 같은 값이 이어질 때 중복된 값을 막아주는 역할

Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "입니다", "입니다", "입니다", "입니다", "저는", "앵무새", "일까요?", "일까요?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
