import RxSwift
import Foundation

let disposeBag = DisposeBag()

//MARK: π€ Observable Append

//π StartWidth
print("----StartWidth----")
//β¨ StartWidth μμ μλ elementκ° λ¨Όμ  λμ€κ³  λλ¨Έμ§ element λμ΄

let λΈλλ° = Observable<String>.of("π§π»", "π¦πΌ", "π§π½")
λΈλλ°
    .enumerated()
    .map{ index, element in
        return element + "μ΄λ¦°μ΄" + "\(index)"
    }
    .startWith("ππ»ββοΈμ μλ")
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//π Concat
print("----Concat1----")
//β¨ Observable ν©μΉκΈ°

let λΈλλ°μ΄λ¦°μ΄λ€ = Observable<String>.of("π§π»", "π¦πΌ", "π§π½")
let μ μλ = Observable<String>.of("ππ»ββοΈμ μλ")

let μ€μμκ±·κΈ° = Observable
    .concat([μ μλ, λΈλλ°μ΄λ¦°μ΄λ€])
μ€μμκ±·κΈ°
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
    
print("----Concat2----")
μ μλ.concat(λΈλλ°μ΄λ¦°μ΄λ€)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


//π ConcatMap
print("----ConcatMap----")
//β¨ κ°κ°μ μνμ€κ° λ€μ μνμ€κ° κ΅¬λλκΈ°μ μ ν©μ³μ§λκ²
let μ΄λ¦°μ΄μ§: [String: Observable<String>] = [
    "λΈλλ°": Observable.of("π§π»", "π¦πΌ", "π§π½"),
    "νλλ°": Observable.of("π§π»", "π¦πΌ", "π§π½")
]

Observable.of("λΈλλ°", "νλλ°")
    .concatMap{ λ° in
        μ΄λ¦°μ΄μ§[λ°] ?? .empty()
    }.subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//MARK: π€ Observable μ‘°ν©

//π Merge
print("----Merge1----")
//β¨ μμλ₯Ό λ³΄μ₯νμ§μκ³  Observable ν©μΉκΈ°
//β¨ λͺ¨λ  Observableμ΄ μλ£λ λκΉμ§ Mergeν¨

let κ°λΆ = Observable.from(["κ°λΆκ΅¬", "μ±λΆκ΅¬", "λλλ¬Έκ΅¬", "μ’λ‘κ΅¬"])
let κ°λ¨ = Observable.from(["κ°λ¨κ΅¬", "κ°λκ΅¬", "μλ±ν¬κ΅¬", "μμ²κ΅¬"])

Observable.of(κ°λΆ, κ°λ¨)
    .merge()
    .subscribe(onNext: {
        print("μμΈνΉλ³μμ κ΅¬:", $0)
    })
    .disposed(by: disposeBag)

print("----Merge2----")
Observable.of(κ°λ¨, κ°λΆ)
    .merge(maxConcurrent: 1) // νλ²μ 1κ°λ§ ν©μ³μ€.. κ°μ μ ν
    .subscribe(onNext: {
        print("μμΈνΉλ³μμ κ΅¬:", $0)
    })
    .disposed(by: disposeBag)

//π CombineLatest
print("----CombineLatest1----")
//β¨ κ°κ°μ μ΅μ μ κ°μ΄ μ‘°ν©νλ λ°©μμΌλ‘ μ΄λ²€νΈ λ°©μΆ

let μ± = PublishSubject<String>()
let μ΄λ¦ = PublishSubject<String>()

let μ±λͺ = Observable.combineLatest(μ±, μ΄λ¦) { μ±, μ΄λ¦ in
    μ± + μ΄λ¦
}

μ±λͺ
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

μ±.onNext("κΉ")
μ΄λ¦.onNext("λλ")
μ΄λ¦.onNext("μμ")
μ΄λ¦.onNext("μμ")
μ±.onNext("λ°")
μ±.onNext("μ΄")
μ±.onNext("μ‘°")

print("----CombineLatest2----")
let λ μ§νμνμ = Observable<DateFormatter.Style>.of(.short, .long)
let νμ¬λ μ§ = Observable<Date>.of(Date())

let νμ¬λ μ§νμ = Observable
    .combineLatest(
        λ μ§νμνμ,
        νμ¬λ μ§,
        resultSelector: { νμ, λ μ§ -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = νμ
            return dateFormatter.string(from: λ μ§)
        }
    )

νμ¬λ μ§νμ
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----CombineLatest3----")
let lastName = PublishSubject<String>()     //μ±
let firstName = PublishSubject<String>()    //μ΄λ¦

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

//π Zip
print("----Zip----")
//β¨ μμλ₯Ό λ³΄μ₯νλ©° Observable μ‘°ν©
//β¨ νλμ Observableμ΄λΌλ μλ£λλ©΄ zip μ μ²΄κ° μλ£λ¨

enum μΉν¨ {
    case μΉ
    case ν¨
}

let μΉλΆ = Observable<μΉν¨>.of(.μΉ, .μΉ, .ν¨, .μΉ, .ν¨)
let μ μ = Observable<String>.of("π°π·", "π¨π­", "πΊπΈ", "π§π·", "π―π΅", "π¨π³")

let μν©κ²°κ³Ό = Observable.zip(μΉλΆ, μ μ) { κ²°κ³Ό, λνμ μ in
    return λνμ μ + "μ μ" + " \(κ²°κ³Ό)!"
}

μν©κ²°κ³Ό
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//MARK: π€ νΈλ¦¬κ±° μ­ν  Observable

//π WithLatestFrom
print("----WithLatestFrom----")
// νΈλ¦¬κ±°κ° λ°μλ μμ μμ κ°μ₯ μ΅μ μ κ°λ§ λ°©μΆ, μ΄μ μ κ°μ λ¬΄μ
let π₯π« = PublishSubject<Void>()
let λ¬λ¦¬κΈ°μ μ = PublishSubject<String>()

π₯π«.withLatestFrom(λ¬λ¦¬κΈ°μ μ)
//    .distinctUntilChanged()     //Sampleκ³Ό λκ°μ΄ μ°κ³  μΆμ λ
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

λ¬λ¦¬κΈ°μ μ.onNext("ππ»ββοΈ")
λ¬λ¦¬κΈ°μ μ.onNext("ππ»ββοΈ ππ½ββοΈ")
λ¬λ¦¬κΈ°μ μ.onNext("ππ»ββοΈ ππ½ββοΈ ππΏ")
π₯π«.onNext(Void())
π₯π«.onNext(Void())

//π Sample
print("----Sample----")
// μμ λμΌνμ§λ§, λ¨ νλ²λ§ λ°©μμ  λ°©μΆ
let πμΆλ° = PublishSubject<Void>()
let F1μ μ = PublishSubject<String>()

F1μ μ.sample(πμΆλ°)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1μ μ.onNext("π")
F1μ μ.onNext("π   π")
F1μ μ.onNext("π      π   π")
πμΆλ°.onNext(Void())
πμΆλ°.onNext(Void())
πμΆλ°.onNext(Void())

//π Amb
print("----Amb----")
// λκ°μ§ Observableμ λ³΄κ³  μλ€κ° λ¨Όμ  λ°©μΆλλ Observableλ§ κ΅¬λ
let πλ²μ€1 = PublishSubject<String>()
let πλ²μ€2 = PublishSubject<String>()

let πλ²μ€μ λ₯μ₯ = πλ²μ€1.amb(πλ²μ€2)

πλ²μ€μ λ₯μ₯.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

πλ²μ€2.onNext("λ²μ€2-μΉκ°0: π©πΎβπΌ")
πλ²μ€1.onNext("λ²μ€1-μΉκ°0: π§πΌβπΌ")
πλ²μ€1.onNext("λ²μ€1-μΉκ°1: π¨π»βπΌ")
πλ²μ€2.onNext("λ²μ€2-μΉκ°1: π©π»βπΌ")
πλ²μ€1.onNext("λ²μ€1-μΉκ°1: π§π»βπΌ")
πλ²μ€2.onNext("λ²μ€2-μΉκ°2: π©πΌβπΌ")

//π SwitchLatest
print("----SwitchLatest----")
// source Observable(μλ€κΈ°)λ‘ λ€μ΄μ¨ λ§μ§λ§ μνμ€μ μμ΄νλ§ κ΅¬λ
let π©π»βπ»νμ1 = PublishSubject<String>()
let π§π½βπ»νμ2 = PublishSubject<String>()
let π¨πΌβπ»νμ3 = PublishSubject<String>()

let μλ€κΈ° = PublishSubject<Observable<String>>()

let μλ μ¬λλ§λ§ν μμλκ΅μ€ = μλ€κΈ°.switchLatest()
μλ μ¬λλ§λ§ν μμλκ΅μ€
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

μλ€κΈ°.onNext(π©π»βπ»νμ1)
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μ λ 1λ² νμμλλ€.")
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μ μ μ μ!!!")

μλ€κΈ°.onNext(π§π½βπ»νμ2)
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μ λ 2λ²μ΄μμ!")
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μ.. λ μμ§ ν λ§ μλλ°")

μλ€κΈ°.onNext(π¨πΌβπ»νμ3)
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μλ μ κΉλ§! λ΄κ°! ")
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μΈμ  λ§ν  μ μμ£ ")
π¨πΌβπ»νμ3.onNext("π¨πΌβπ»νμ3: μ λ 3λ² μλλ€~ μλ¬΄λλ μ κ° μ΄κΈ΄ κ² κ°λ€μ.")

μλ€κΈ°.onNext(π©π»βπ»νμ1)
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μλ, νλ Έμ΄. μΉμλ λμΌ.")
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: γ γ ")
π¨πΌβπ»νμ3.onNext("π¨πΌβπ»νμ3: μ΄κΈ΄ μ€ μμλλ°")
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μ΄κ±° μ΄κΈ°κ³  μ§λ μλ€κΈ°μλμ?")

//MARK: π€ μνμ€ λ΄μ μμλ€ κ²°ν©
//π Reduce
print("----Reduce----")
// κ°μ΄ λ°©μΆλ λλ§λ€ κ²°ν©, κ²°κ³Όκ°λ§ λ°©μΆ
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
//    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//π Scan
print("----Scan----")
// κ°μ΄ λ°©μΆλ λλ§λ€ κ²°ν©, λ³νλ κ°μ λͺ¨λ λ°©μΆ(return κ°μ΄ Observable)
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
