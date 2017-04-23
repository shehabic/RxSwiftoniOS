import Foundation
import RxSwift

class SearchPresenter {

    let searchManager : SearchManager
    let filteredOutUser = "shehabic"

    init(_ searchManager : SearchManager) {
        self.searchManager = searchManager
    }

    func getRepos(_ query: String) -> Observable<[Repo]> {
        return self.searchManager
            .findRepositories(search: query)
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
                items.filter{ repo in repo.username != self.filteredOutUser }
            }
    }
}