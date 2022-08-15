import RxSwift
import Foundation

let disposeBag = DisposeBag()

//📌 ToArray
print("----ToArray----")
//✨ 옵저버블 독립적인 요소들을 array로 만들어줌

Observable.of("A", "B", "C")
    .toArray()
    .subscribe (onSuccess:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 Map
print("----Map----")
//✨ Observerble에 의해 방출되는 아이템들에 대해 각각 함수를 적용하여 변환

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

//📌 FlatMap
print("----FlatMap----")
//✨ Observable에서 발행한 아이템을 다른 Observable로 만들며, 만들어진 Observable에서 아이템을 발행
//✨ 중첩된 Observable에 사용

protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 🇰🇷국가대표 = 양궁선수(점수: BehaviorSubject(value: 10))
let 🇺🇸국가대표 = 양궁선수(점수: BehaviorSubject(value: 8))

let 올림픽경기 = PublishSubject<선수>()

올림픽경기
    .flatMap {
        $0.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(🇰🇷국가대표)
🇰🇷국가대표.점수.onNext(10)

올림픽경기.onNext(🇺🇸국가대표)
🇰🇷국가대표.점수.onNext(10)
🇺🇸국가대표.점수.onNext(9)

//📌 FlatMapLatest
print("----FlatMapLatest----")
//✨ 새로운 Observable을 만들고, 새로운 Observable이 동작하는 중에 새로 발행된 아이템이 전달되면, 만들어진 Observable은 dispose하고 새로운 Observable을 만든다.
//✨ 이전 Observable을 무시

struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject(value: 6))

let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMapLatest {
        $0.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

전국체전.onNext(서울)
서울.점수.onNext(9)

전국체전.onNext(제주)
서울.점수.onNext(10)
제주.점수.onNext(8)

//📌 Materialize && Dematerialize
print("----Materialize && Dematerialize----")
// ✨ Materialize : Type -> .Event<Type> 형태로 바꿔줌 ex) ".next(1)"
// ✨ Dematerialize : .Event<Type>을 -> Type 형태로 바꿔줌 ex) "1"

enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)

달리기100M
    .flatMapLatest {
        $0.점수
            .materialize()    // 1) materialize 추가
    }
    // 2) demeterialize 추가
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

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)

print("----전화번호 11자리----")
let input = PublishSubject<Int?>()

let list: [Int] = [1]
input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0) // optional 처리
    }
    .map { $0! } // optional 처리 완료
    .skip(while: { $0 != 0 }) // 첫 숫자가 0이 나오기 전까지 skip
    .take(11) // 11개만 받음
    .toArray() // array로 묶어주기
    .asObservable() // single -> observable
    .map {
        $0.map { "\($0)" } // Int -> String
    }
    .map { numbers in // "-" 문자 삽입
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8) // 010-1234-
        let number = numberList.reduce(" ", +) // 각각의 문자 더함
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
