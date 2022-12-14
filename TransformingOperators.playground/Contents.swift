import RxSwift
import Foundation

let disposeBag = DisposeBag()

//๐ ToArray
print("----ToArray----")
//โจ ์ต์ ๋ฒ๋ธ ๋๋ฆฝ์ ์ธ ์์๋ค์ array๋ก ๋ง๋ค์ด์ค

Observable.of("A", "B", "C")
    .toArray()
    .subscribe (onSuccess:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ Map
print("----Map----")
//โจ Observerble์ ์ํด ๋ฐฉ์ถ๋๋ ์์ดํ๋ค์ ๋ํด ๊ฐ๊ฐ ํจ์๋ฅผ ์ ์ฉํ์ฌ ๋ณํ

Observable.of(Date())
    .map{ date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe (onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ FlatMap
print("----FlatMap----")
//โจ Observable์์ ๋ฐํํ ์์ดํ์ ๋ค๋ฅธ Observable๋ก ๋ง๋ค๋ฉฐ, ๋ง๋ค์ด์ง Observable์์ ์์ดํ์ ๋ฐํ
//โจ ์ค์ฒฉ๋ Observable์ ์ฌ์ฉ

protocol ์ ์ {
    var ์ ์: BehaviorSubject<Int> { get }
}

struct ์๊ถ์ ์: ์ ์ {
    var ์ ์: BehaviorSubject<Int>
}

let ๐ฐ๐ท๊ตญ๊ฐ๋ํ = ์๊ถ์ ์(์ ์: BehaviorSubject(value: 10))
let ๐บ๐ธ๊ตญ๊ฐ๋ํ = ์๊ถ์ ์(์ ์: BehaviorSubject(value: 8))

let ์ฌ๋ฆผํฝ๊ฒฝ๊ธฐ = PublishSubject<์ ์>()

์ฌ๋ฆผํฝ๊ฒฝ๊ธฐ
    .flatMap {
        $0.์ ์
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

์ฌ๋ฆผํฝ๊ฒฝ๊ธฐ.onNext(๐ฐ๐ท๊ตญ๊ฐ๋ํ)
๐ฐ๐ท๊ตญ๊ฐ๋ํ.์ ์.onNext(10)

์ฌ๋ฆผํฝ๊ฒฝ๊ธฐ.onNext(๐บ๐ธ๊ตญ๊ฐ๋ํ)
๐ฐ๐ท๊ตญ๊ฐ๋ํ.์ ์.onNext(10)
๐บ๐ธ๊ตญ๊ฐ๋ํ.์ ์.onNext(9)

//๐ FlatMapLatest
print("----FlatMapLatest----")
//โจ ์๋ก์ด Observable์ ๋ง๋ค๊ณ , ์๋ก์ด Observable์ด ๋์ํ๋ ์ค์ ์๋ก ๋ฐํ๋ ์์ดํ์ด ์ ๋ฌ๋๋ฉด, ๋ง๋ค์ด์ง Observable์ disposeํ๊ณ  ์๋ก์ด Observable์ ๋ง๋ ๋ค.
//โจ ์ด์  Observable์ ๋ฌด์

struct ๋์ด๋ฐ๊ธฐ์ ์: ์ ์ {
    var ์ ์: BehaviorSubject<Int>
}

let ์์ธ = ๋์ด๋ฐ๊ธฐ์ ์(์ ์: BehaviorSubject(value: 7))
let ์ ์ฃผ = ๋์ด๋ฐ๊ธฐ์ ์(์ ์: BehaviorSubject(value: 6))

let ์ ๊ตญ์ฒด์  = PublishSubject<์ ์>()

์ ๊ตญ์ฒด์ 
    .flatMapLatest {
        $0.์ ์
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

์ ๊ตญ์ฒด์ .onNext(์์ธ)
์์ธ.์ ์.onNext(9)

์ ๊ตญ์ฒด์ .onNext(์ ์ฃผ)
์์ธ.์ ์.onNext(10)
์ ์ฃผ.์ ์.onNext(8)

//๐ Materialize && Dematerialize
print("----Materialize && Dematerialize----")
// โจ Materialize : Type -> .Event<Type> ํํ๋ก ๋ฐ๊ฟ์ค ex) ".next(1)"
// โจ Dematerialize : .Event<Type>์ -> Type ํํ๋ก ๋ฐ๊ฟ์ค ex) "1"

enum ๋ฐ์น: Error {
    case ๋ถ์ ์ถ๋ฐ
}

struct ๋ฌ๋ฆฌ๊ธฐ์ ์: ์ ์ {
    var ์ ์: BehaviorSubject<Int>
}

let ๊นํ ๋ผ = ๋ฌ๋ฆฌ๊ธฐ์ ์(์ ์: BehaviorSubject(value: 0))
let ๋ฐ์นํ = ๋ฌ๋ฆฌ๊ธฐ์ ์(์ ์: BehaviorSubject(value: 1))

let ๋ฌ๋ฆฌ๊ธฐ100M = BehaviorSubject<์ ์>(value: ๊นํ ๋ผ)

๋ฌ๋ฆฌ๊ธฐ100M
    .flatMapLatest {
        $0.์ ์
            .materialize()    // 1) materialize ์ถ๊ฐ
    }
    // 2) demeterialize ์ถ๊ฐ
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

๊นํ ๋ผ.์ ์.onNext(1)
๊นํ ๋ผ.์ ์.onError(๋ฐ์น.๋ถ์ ์ถ๋ฐ)
๊นํ ๋ผ.์ ์.onNext(2)

๋ฌ๋ฆฌ๊ธฐ100M.onNext(๋ฐ์นํ)

print("----์ ํ๋ฒํธ 11์๋ฆฌ----")
let input = PublishSubject<Int?>()

let list: [Int] = [1]
input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0) // optional ์ฒ๋ฆฌ
    }
    .map { $0! } // optional ์ฒ๋ฆฌ ์๋ฃ
    .skip(while: { $0 != 0 }) // ์ฒซ ์ซ์๊ฐ 0์ด ๋์ค๊ธฐ ์ ๊น์ง skip
    .take(11) // 11๊ฐ๋ง ๋ฐ์
    .toArray() // array๋ก ๋ฌถ์ด์ฃผ๊ธฐ
    .asObservable() // single -> observable
    .map {
        $0.map { "\($0)" } // Int -> String
    }
    .map { numbers in // "-" ๋ฌธ์ ์ฝ์
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8) // 010-1234-
        let number = numberList.reduce(" ", +) // ๊ฐ๊ฐ์ ๋ฌธ์ ๋ํจ
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(4)
