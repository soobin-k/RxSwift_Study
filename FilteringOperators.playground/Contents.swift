import RxSwift

let disposeBag = DisposeBag()

//๐ IgnoreElements
print("----IgnoreElements----")
// โจ onNext ์ด๋ฒคํธ๋ง ๋ฌด์ํจ

let ์ทจ์นจ๋ชจ๋๐ด = PublishSubject<String>()

์ทจ์นจ๋ชจ๋๐ด.ignoreElements()
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

์ทจ์นจ๋ชจ๋๐ด.onNext("๐")
์ทจ์นจ๋ชจ๋๐ด.onNext("๐")
์ทจ์นจ๋ชจ๋๐ด.onNext("๐")

์ทจ์นจ๋ชจ๋๐ด.onCompleted()

//๐ ElementAt
print("----ElementAt----")
// โจ ํน์  ์ธ๋ฑ์ค๋ง ๋ฐฉ์ถํ๊ณ  ๋๋จธ์ง๋ ๋ฌด์ํจ

let ๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋ = PublishSubject<String>()

๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋
    .element(at: 2)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 0
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 1
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐ฅบ") // index 2
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 3

//๐ Filter
print("----Filter----")
// โจ filter ๊ตฌ๋ฌธ ๋ด์ true์ธ ๊ฐ์ ๋ฐฉ์ถ

Observable.of(1, 2, 3, 4, 5, 6, 7, 8) // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter{$0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//๐ Skip
print("----Skip----")
// โจ ์ฒซ๋ฒ์งธ ์์๋ถํฐ n๊ฐ์ ์์๋ฅผ skip

Observable.of("๐", "๐ฅฐ", "๐", "โบ๏ธ", "๐", "๐ธ")
    .skip(5)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ SkipWhile
print("----SkipWhile----")
// โจ skipํ  ๋ก์ง์ด false๊ฐ ๋์์ ๋๋ถํฐ ๋ฐฉ์ถ

Observable.of("๐", "๐ฅฐ", "๐", "โบ๏ธ", "๐", "๐ธ", "๐ด", "๐ฅฒ")
    .skip(while: {
        $0 != "๐ธ"
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ SkipUntil
print("----SkipUntil----")
// โจ ๋ค๋ฅธ Observable์ด ๋ฐฉ์ถ๋๊ธฐ ์ ๊น์ง ํ์ฌ Observable์ด ๋ฐฉ์ถํ๋ ๋ชจ๋  ์ด๋ฒคํธ๋ฅผ ๋ฌด์
// โจ ๋ค๋ฅธ Observable์ ๊ธฐ๋ฐํ ์์๋ค์ filterํ๊ณ  ์ถ์ ๊ฒฝ์ฐ ์ฌ์ฉ

let ์๋ = PublishSubject<String>()
let ๋ฌธ์ฌ๋์๊ฐ = PublishSubject<String>()

์๋ // ํ์ฌ Observable
    .skip(until: ๋ฌธ์ฌ๋์๊ฐ) // ๋ค๋ฅธ Observable
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

์๋.onNext("๐")
์๋.onNext("๐")

๋ฌธ์ฌ๋์๊ฐ.onNext("๐ช")
์๋.onNext("๐")

//๐ Take
print("----Take----")
// โจ ์ฒ์๋ถํฐ n๊ฐ์ ๊ฐ๋ง ์ทจํจ, skip์ ๋ฐ๋ ๊ฐ๋
Observable.of("๐ฅ", "๐ฅ", "๐ฅ", "โบ๏ธ", "๐")
    .take(3)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ TakeWhile
print("----TakeWhile----")
// โจ takeํ  ๋ก์ง์ด false๊ฐ ๋๊ธฐ ์ ๊น์ง ๋ฐฉ์ถ, skipWhile ๋ฐ๋ ๊ฐ๋

Observable.of("๐ฅ", "๐ฅ", "๐ฅ", "โบ๏ธ", "๐")
    .take(while: {
        $0 != "๐ฅ"
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ Enumerated
print("----Enumerated----")
// โจ index์ใ element ๋๋ค ๋ฐฉ์ถ, ๋ฐฉ์ถ๋ ์์์ ์ธ๋ฑ์ค๋ฅผ ์ฐธ๊ณ ํ๊ณ  ์ถ์ ๋ ์ฌ์ฉ

Observable.of("๐ฅ", "๐ฅ", "๐ฅ", "โบ๏ธ", "๐")
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

//๐ TakeUntil
print("----TakeUntil----")
// โจ ํธ๋ฆฌ๊ฑฐ๊ฐ ๋๋ Observable๊ฐ ๊ตฌ๋๋๊ธฐ ์ ๊น์ง์ ์ด๋ฒคํธ๋ง ๋ฐ๋๋ค.

let ์๊ฐ์ ์ฒญ = PublishSubject<String>()
let ์ ์ฒญ๋ง๊ฐ = PublishSubject<String>()

์๊ฐ์ ์ฒญ
    .take(until: ์ ์ฒญ๋ง๊ฐ)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

์๊ฐ์ ์ฒญ.onNext("๐๐ปโโ๏ธ")
์๊ฐ์ ์ฒญ.onNext("๐๐ป")
์ ์ฒญ๋ง๊ฐ.onNext("๋!")
์๊ฐ์ ์ฒญ.onNext("๐๐ปโโ๏ธ")

//๐ DistinctUntilChanged
print("----DistinctUntilChanged----")
// โจ ์ฐ๋ฌ์ ๊ฐ์ ๊ฐ์ด ์ด์ด์ง ๋ ์ค๋ณต๋ ๊ฐ์ ๋ง์์ฃผ๋ ์ญํ 

Observable.of("์ ๋", "์ ๋", "์ต๋ฌด์", "์ต๋ฌด์", "์ต๋ฌด์", "์๋๋ค", "์๋๋ค", "์๋๋ค", "์๋๋ค", "์ ๋", "์ต๋ฌด์", "์ผ๊น์?", "์ผ๊น์?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
