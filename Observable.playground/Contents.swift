import Foundation
import RxSwift

//๐ Just: ํ๋์ element๋ฅผ ๋ฐฉ์ถ
print("----Just----")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })
// ํ๋์ intํ element๋ฅผ ๋ฐฉ์ถํ  Observable

//๐ Of: ์ฌ๋ฌ๊ฐ์ element๋ฅผ ๋ฐฉ์ถ
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
//โจ Observable์ ํ์ ์ถ๋ก ์ ํตํด Observable ์ํ์ค๋ฅผ ์์ฑํจ

//๐ From: array ํํ๋ง ๋ฐ๊ณ , array ์ element๋ค์ ํ๋์ฉ ๋ฐฉ์ถ
print("----From----")
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })
//โจ Observable์ ๊ตฌ๋๋๊ธฐ ์ ์ ์๋ฌด๋ฐ ์ด๋ฒคํธ๋ฅผ ๋ด๋ณด๋ด์ง ์๋๋ค.

//๐ Subscribe: ์ด๋ฒคํธ์ ์ธ์ฌ์ element๋ฅผ ๋ฐฉ์ถํจ
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

//๐ Empty: count 0 ์ธ Observable์ ๋ง๋ค ๋ ์ฌ์ฉ, ์๋ฌด๋ฐ ์ด๋ฒคํธ/element ๋ฐฉ์ถํ์ง ์์
print("----Empty----")
Observable<Void>.empty()
    .subscribe{
        print($0)
    }
//โจ ์ฆ์ ์ข๋ฃํ  ์ ์๋ Observable ๋ฆฌํดํ๊ณ  ์ถ์ ๋, ์๋์ ์ผ๋ก 0๊ฐ์ ๊ฐ์ ๊ฐ์ง๋ Observable์ ๋ฆฌํดํ๊ณ  ์ถ์ ๋ ์ฌ์ฉ

//๐ Never: ์๋์ ํ์ง๋ง ์๋ฌด๋ฐ ๊ฒ๋ ๋ด๋ฑ์ง ์์
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

//๐ Range: ๋ฒ์์ ์๋ array๋ฅผ start๋ถํฐ count๋งํผ ๊ฐ์ ๊ฐ๋๋ก ๋ง๋ค์ด์ค
print("----Range----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext:{
        print("2*\($0)=\(2*$0)")
    })

//๐ Dispose: Observable ๊ตฌ๋ ์ทจ์!
print("----Dispose----")
Observable.range(start: 1, count: 9)
    .subscribe{
        print($0)
    }
    .dispose()

//๐ DisposeBag: Disposable ํ์์ ๋ด์ ์ ์๋ ํด๋์ค, disposBag์ ํ ๋น ํด์  ํ  ๋๋ง๋ค ๋ชจ๋  ๊ตฌ๋์ ๋ํ dispose ํธ์ถ
print("----DisposeBag----")
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

// โจ ๋ฉ๋ชจ๋ฆฌ ๋์ ๋ฐฉ์ง๋ฅผ ์ํจ
// โจ Observable์ ๋ง๋ค๊ณ , ๊ตฌ๋ํ๊ณ , disposed ์์ผ์ฃผ๋ ๊ฒ์ ํ๋์ ์๋ช์ฃผ๊ธฐ๋ก ์๊ฐํ์!

//๐ Create: Observable์ ์ด์ฉํด์ Observable ์ํ์ค๋ฅผ ๋ง๋ฆ
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

// โจ onCompleted ์ด๋ฒคํธ ๋ค์์๋ onNext ์ด๋ฒคํธ๊ฐ ๋ฐฉ์ถ๋์ง ์๋๋ค

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

// โจ onError ์ด๋ฒคํธ๋ error๋ฅผ ๋ฐฉ์ถํ ํ, ํด๋น Observable์ ์ข๋ฃ์ํจ๋ค.

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

//๐ Deferred: Observable์ด ๊ตฌ๋๋  ๋๊น์ง ์์ฑ์ ๋ฏธ๋ฃธ
print("----Deffered1----")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

print("----Deffered2----")
var ๋ค์ง๊ธฐ: Bool = false
let factory: Observable<String> = Observable.deferred {
    ๋ค์ง๊ธฐ = !๋ค์ง๊ธฐ
    
    if ๋ค์ง๊ธฐ{
        return Observable.of("๐")
    }else{
        return Observable.of("๐")
    }
}

for _ in 0...3{
    factory.subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
}
