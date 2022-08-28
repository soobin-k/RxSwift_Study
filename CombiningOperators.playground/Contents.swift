import RxSwift
import Foundation

let disposeBag = DisposeBag()

//MARK: 🤍 Observable Append

//📌 StartWidth
print("----StartWidth----")
//✨ StartWidth 안에 있는 element가 먼저 나오고 나머지 element 나옴

let 노랑반 = Observable<String>.of("👧🏻", "👦🏼", "🧒🏽")
노랑반
    .enumerated()
    .map{ index, element in
        return element + "어린이" + "\(index)"
    }
    .startWith("🙆🏻‍♀️선생님")
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//📌 Concat
print("----Concat1----")
//✨ Observable 합치기

let 노랑반어린이들 = Observable<String>.of("👧🏻", "👦🏼", "🧒🏽")
let 선생님 = Observable<String>.of("🙆🏻‍♀️선생님")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])
줄서서걷기
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
    
print("----Concat2----")
선생님.concat(노랑반어린이들)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


//📌 ConcatMap
print("----ConcatMap----")
//✨ 각각의 시퀀스가 다음 시퀀스가 구독되기전에 합쳐지는것
let 어린이집: [String: Observable<String>] = [
    "노랑반": Observable.of("👧🏻", "👦🏼", "🧒🏽"),
    "파랑반": Observable.of("👧🏻", "👦🏼", "🧒🏽")
]

Observable.of("노랑반", "파랑반")
    .concatMap{ 반 in
        어린이집[반] ?? .empty()
    }.subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//MARK: 🤍 Observable 조합

//📌 Merge
print("----Merge1----")
//✨ 순서를 보장하지않고 Observable 합치기
//✨ 모든 Observable이 완료될때까지 Merge함

let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)

print("----Merge2----")
Observable.of(강남, 강북)
    .merge(maxConcurrent: 1) // 한번에 1개만 합쳐줌.. 개수 제한
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)

//📌 CombineLatest
print("----CombineLatest1----")
//✨ 각각의 최신의 값이 조합하는 방식으로 이벤트 방출

let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable.combineLatest(성, 이름) { 성, 이름 in
    성 + 이름
}

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("똘똘")
이름.onNext("영수")
이름.onNext("은영")
성.onNext("박")
성.onNext("이")
성.onNext("조")

print("----CombineLatest2----")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----CombineLatest3----")
let lastName = PublishSubject<String>()     //성
let firstName = PublishSubject<String>()    //이름

let fullName = Observable.combineLatest([firstName, lastName]) { name in
    name.joined(separator: " ")
}

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")

//📌 Zip
print("----Zip----")
//✨ 순서를 보장하며 Observable 조합
//✨ 하나의 Observable이라도 완료되면 zip 전체가 완료됨

enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("🇰🇷", "🇨🇭", "🇺🇸", "🇧🇷", "🇯🇵", "🇨🇳")

let 시합결과 = Observable.zip(승부, 선수) { 결과, 대표선수 in
    return 대표선수 + "선수" + " \(결과)!"
}

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//MARK: 🤍 트리거 역할 Observable

//📌 WithLatestFrom
print("----WithLatestFrom----")
// 트리거가 발생된 시점에서 가장 최신의 값만 방출, 이전의 값은 무시
let 💥🔫 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

💥🔫.withLatestFrom(달리기선수)
//    .distinctUntilChanged()     //Sample과 똑같이 쓰고 싶을 때
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("🏃🏻‍♀️")
달리기선수.onNext("🏃🏻‍♀️ 🏃🏽‍♂️")
달리기선수.onNext("🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿")
💥🔫.onNext(Void())
💥🔫.onNext(Void())

//📌 Sample
print("----Sample----")
// 위와 동일하지만, 단 한번만 방아쇠 방출
let 🏁출발 = PublishSubject<Void>()
let F1선수 = PublishSubject<String>()

F1선수.sample(🏁출발)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1선수.onNext("🏎")
F1선수.onNext("🏎   🚗")
F1선수.onNext("🏎      🚗   🚙")
🏁출발.onNext(Void())
🏁출발.onNext(Void())
🏁출발.onNext(Void())

//📌 Amb
print("----Amb----")
// 두가지 Observable을 보고 있다가 먼저 방출되는 Observable만 구독
let 🚌버스1 = PublishSubject<String>()
let 🚌버스2 = PublishSubject<String>()

let 🚏버스정류장 = 🚌버스1.amb(🚌버스2)

🚏버스정류장.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

🚌버스2.onNext("버스2-승객0: 👩🏾‍💼")
🚌버스1.onNext("버스1-승객0: 🧑🏼‍💼")
🚌버스1.onNext("버스1-승객1: 👨🏻‍💼")
🚌버스2.onNext("버스2-승객1: 👩🏻‍💼")
🚌버스1.onNext("버스1-승객1: 🧑🏻‍💼")
🚌버스2.onNext("버스2-승객2: 👩🏼‍💼")

//📌 SwitchLatest
print("----SwitchLatest----")
// source Observable(손들기)로 들어온 마지막 시퀀스의 아이템만 구독
let 👩🏻‍💻학생1 = PublishSubject<String>()
let 🧑🏽‍💻학생2 = PublishSubject<String>()
let 👨🏼‍💻학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest()
손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 저는 1번 학생입니다.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저요 저요!!!")

손들기.onNext(🧑🏽‍💻학생2)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저는 2번이예요!")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아.. 나 아직 할말 있는데")

손들기.onNext(👨🏼‍💻학생3)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 아니 잠깐만! 내가! ")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 언제 말할 수 있죠")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 저는 3번 입니다~ 아무래도 제가 이긴 것 같네요.")

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아니, 틀렸어. 승자는 나야.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: ㅠㅠ")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 이긴 줄 알았는데")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 이거 이기고 지는 손들기였나요?")

//MARK: 🤍 시퀀스 내의 요소들 결합
//📌 Reduce
print("----Reduce----")
// 값이 방출될때마다 결합, 결과값만 방출
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
//    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//📌 Scan
print("----Scan----")
// 값이 방출될때마다 결합, 변형된 값을 모두 방출(return 값이 Observable)
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
