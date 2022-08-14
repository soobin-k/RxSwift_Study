import RxSwift
import Foundation

let disposeBag = DisposeBag()

enum TraitsError: Error{
    case single
    case maybe
    case completable
}

//📌 Single
print("----Single1----")
Single<String>.just("✅")
    .subscribe(
        onSuccess: { // onNext + onCompleted
            print($0)
        },
        onFailure: {
            print("error: \($0)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("----Single2----")
Observable<String>
    .create{ observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(
        onSuccess: { // onNext + onCompleted
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("----Single3----")
struct SomeJson: Decodable{
    let name: String
}

enum JSONError: Error{
    case decodingError
}

let json1 = """
    {"name": "park"}
    """
let json2 = """
    {"my_name": "young"}
    """

// JSON 디코딩
func decode(json: String) -> Single<SomeJson>{
    Single<SomeJson>.create{observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJson.self, from: data) else{
            // 실패
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        // 성공
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe{
        switch $0{
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe{
        switch $0{
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

//📌 MayBe
print("----Maybe1----")
Maybe<String>.just("✅")
    .subscribe(
        onSuccess: { // onNext + onCompleted
            print($0)
        },
        onError: {
            print("error: \($0)")
        },
        onCompleted: {
            
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("----Maybe2----")
Observable<String>
    .create{ observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asMaybe()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print("error: \($0)")
        },
        onCompleted:{
            print("completed")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

//📌 Completable
print("----Completable1----")
//✨ asSingle, asMaybe처럼 asCompetable 키워드 사용 불가능 -> 반드시 create로만 만들어주기!
Completable.create { completable in
    completable(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("completed")
}, onError: {
    print("error: \($0.localizedDescription)")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

print("----Completable2----")
Completable.create { completable in
    completable(.completed)
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("completed")
}, onError: {
    print("error: \($0.localizedDescription)")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

