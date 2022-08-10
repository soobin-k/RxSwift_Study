import Foundation
import RxSwift

//📌 Just: 하나의 element를 방출
print("----Just----")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })
// 하나의 int형 element를 방출할 Observable

//📌 Of: 여러개의 element를 방출
print("----Of----")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })

print("----Of2----")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })
//✨ Observable은 타입 추론을 통해 Observable 시퀀스를 생성함

//📌 From: array 형태만 받고, array 속 element들을 하나씩 방출
print("----From----")
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })
//✨ Observable은 구독되기 전에 아무런 이벤트를 내보내지 않는다.

//📌 Subscribe: 이벤트에 싸여서 element를 방출함
print("----Subscribe1----")
Observable.of(1, 2, 3)
    .subscribe{
        print($0)
    }

print("----Subscribe2----")
Observable.of(1, 2, 3)
    .subscribe{
        if let element = $0.element{
            print(element)
        }
    }

print("----Subscribe3----")
Observable.of(1, 2, 3)
    .subscribe(onNext:{
        print($0)
    })

//📌 Empty: count 0 인 Observable을 만들 때 사용, 아무런 이벤트/element 방출하지 않음
print("----Empty----")
Observable<Void>.empty()
    .subscribe{
        print($0)
    }
//✨ 즉시 종료할 수 있는 Observable 리턴하고 싶을 때, 의도적으로 0개의 값을 가지는 Observable을 리턴하고 싶을 때 사용

//📌 Never: 작동은 하지만 아무런 것도 내뱉지 않음
print("----Never----")
Observable<Void>.never()
    .debug("never")
    .subscribe(
        onNext:{
            print($0)
        },
        onCompleted: {
            print("Completed")
        }
    )

//📌 Range: 범위에 있는 array를 start부터 count만큼 값을 갖도록 만들어줌
print("----Range----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext:{
        print("2*\($0)=\(2*$0)")
    })

//📌 Dispose: Observable 구독 취소!
print("----Dispose----")
Observable.range(start: 1, count: 9)
    .subscribe{
        print($0)
    }
    .dispose()

//📌 DisposeBag: Disposable 타입을 담을 수 있는 클래스, disposBag을 할당 해제 할 때마다 모든 구독에 대한 dispose 호출
print("----DisposeBag----")
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

// ✨ 메모리 누수 방지를 위함
// ✨ Observable을 만들고, 구독하고, disposed 시켜주는 것을 하나의 생명주기로 생각하자!

//📌 Create: Observable을 이용해서 Observable 시퀀스를 만듦
print("----Create1----")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    // observer.on(.next(1))
    observer.onCompleted()
    // observer.on(.complete)
    observer.onNext(2)
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

// ✨ onCompleted 이벤트 다음에는 onNext 이벤트가 방출되지 않는다

print("----Create2----")
enum MyError: Error{
    case anError
}
Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext:{
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

// ✨ onError 이벤트는 error를 방출한 후, 해당 Observable을 종료시킨다.

print("----Create3----")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(onNext: {
    print($0)
}, onError: {
    print($0)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
})

//📌 Deferred: Observable이 구독될 때까지 생성을 미룸
print("----Deffered1----")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

print("----Deffered2----")
var 뒤집기: Bool = false
let factory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    
    if 뒤집기{
        return Observable.of("👍")
    }else{
        return Observable.of("👎")
    }
}

for _ in 0...3{
    factory.subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
}
