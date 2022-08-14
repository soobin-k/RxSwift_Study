import RxSwift

let disiposeBag = DisposeBag()

//📌 PublishSubject
print("----PublishSubject----")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1. 여러분 안녕하세요")

let 구독자1 = publishSubject
    .subscribe(onNext:{
        print("첫번째 구독:", $0)
    })

publishSubject.onNext("2. 들리세요?")
publishSubject.onNext("3. 안들리시나요?")

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(onNext:{
        print("두번째 구독:", $0)
    })

publishSubject.onNext("4. 여보세요")
publishSubject.onCompleted()
//✨ onCompleted 이후 이벤트는 방출되지 않는다.
publishSubject.onNext("5. 끝났나요")

구독자2.dispose()

publishSubject
    .subscribe{
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disiposeBag)

publishSubject.onNext("6. 찍할까요?")

//📌 BehaviorSubject
print("----BehaviorSubject----")
enum SubjectError: Error{
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")
behaviorSubject.onNext("1. 첫번째값")

behaviorSubject.subscribe{
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disiposeBag)

//publishSubject.onError(SubjectError.error1)

behaviorSubject.subscribe{
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disiposeBag)

//✨ .value()로 값 확인 가능
let value = try? behaviorSubject.value()
print(value)

//📌 ReplaySubject
print("----ReplaySubject----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 어렵지만")

replaySubject.subscribe{
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disiposeBag)

replaySubject.subscribe{
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disiposeBag)

replaySubject.onNext("4. 할 수 있어요.")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe{
    print("세번째 구독:", $0.element ?? $0)
}
.disposed(by: disiposeBag)
