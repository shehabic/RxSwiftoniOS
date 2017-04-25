import Foundation
import RxSwift

class SearchPresenterAndViewModel {

    let searchManager : SearchManager
    let filteredOutUser = "shehabicd"
















    /////// ViewModel
    /////// ViewModel
    /////// ViewModel
    /////// ViewModel

    init(_ searchManager : SearchManager) {
        self.searchManager = searchManager
        self.view = nil
    }

    func onSearchQuery(_ query: String) -> Observable<[Repo]> {
        return self.searchManager
            .findRepositories(query)
            .observeOn(MainScheduler.instance)
            .flatMap { json -> Observable<[Repo]> in
                guard
                    let json = json as? [String: Any],
                    let items = json["items"] as? [[String: Any]]
                else {
                    return Observable<[Repo]>.just([])
                }

                return Observable<[Repo]>.just(items.flatMap(Repo.init))
            }
            .map{ items in
                items.filter{ repo in
                    repo.username != self.filteredOutUser
                }
            }
    }































    /////// Presenter
    /////// Presenter
    /////// Presenter
    /////// Presenter

    let view: SearchResultsView?
    var disposable : Disposable?

    init?(_ searchManager : SearchManager, _ view: SearchResultsView) {
        self.view = view
        self.searchManager = searchManager
    }

    func onSearchQueryReceived(_ query: String) {
        disposable = self.searchManager
            .findRepositories(query)
            .flatMap { json -> Observable<[Repo]> in
                guard
                    let json = json as? [String: Any],
                    let items = json["items"] as? [[String: Any]]
                    else {
                return Observable<[Repo]>.just([])
                }

                return Observable<[Repo]>.just(items.flatMap(Repo.init))
            }
            .map{ items in
                items.filter{ repo in
                    repo.username != self.filteredOutUser
                }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { repos in
                self.view!.renderResults(repos)
            }, onError: { error in
                self.view!.showError("errorHappened")
            })
    }

    public func stopAll() {
        if (disposable != nil) {
            disposable!.dispose()
        }
    }
}