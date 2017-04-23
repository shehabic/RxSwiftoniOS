import Foundation
import RxSwift
import Unbox

class SearchManager {
    func findRepositories(search: String) -> Observable<Any> {
        return Observable<String>
            .from(search)
            .map { search in
                var apiUrl = URLComponents(string: "https://api.github.com/search/repositories")!
                apiUrl.queryItems = [URLQueryItem(name: "q", value: search)]

                return URLRequest(url: apiUrl.url!)
            }
            .flatMap{ request in
                return URLSession.shared.rx.json(request: request).catchErrorJustReturn([])
            }
    }
}