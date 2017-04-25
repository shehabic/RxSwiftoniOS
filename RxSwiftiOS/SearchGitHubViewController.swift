import UIKit
import Unbox

import RxSwift
import RxCocoa

protocol SearchResultsView {
    func renderResults(_ repos: [Repo])
    func showError(_ message: String)
}

class SearchGitHubViewController: UIViewController, SearchResultsView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//         bindUIinMVVM()  // MVVM
        bindUIinMVP() // MVP
        presenter = SearchPresenterAndViewModel(SearchManager(), self)
    }






























    //////////////////////////////////////////////////////////////////////////////////////////
    //////////// M-V-VM
    //////////////////////////////////////////////////////////////////////////////////////////

    private let viewModel = SearchPresenterAndViewModel(SearchManager())

    func bindUIinMVVM() {
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return self.isValidQuery(query)
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest{ query -> Observable<[Repo]> in
                return self.viewModel.onSearchQuery(query)
            }
            .bindTo(tableView.rx.items) { tableView, row, repo in
                return self.createCell(repo, row)
            }
            .addDisposableTo(bag)
    }
































    //////////////////////////////////////////////////////////////////////////////////////////
    //////////// M-V-P
    //////////////////////////////////////////////////////////////////////////////////////////

    private var presenter: SearchPresenterAndViewModel?

    func bindUIinMVP() {
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return self.isValidQuery(query)
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { query in
                self.presenter!.onSearchQueryReceived(query)
            })
            .addDisposableTo(bag)
    }

    private func isValidQuery(_ query: String) -> Bool {
        return query.characters.count > 2 || query.characters.count == 0
    }

    func renderResults(_ repos: [Repo]) {
        tableView.dataSource = nil
        Observable<[Repo]>.just(repos, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .bindTo(tableView.rx.items) { tableView, row, repo in
                return self.createCell(repo, row)
            }
            .addDisposableTo(bag)
    }

    func createCell(_ repo: Repo, _ row: Int) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let user : String = (repo.username) != nil ? repo.username! : ""
        cell.textLabel!.text = String(row) + "-" + repo.name + " (by: " + user + ")"
        cell.detailTextLabel?.text = repo.language

        cell.rx

        return cell
    }

    func showError(_ message: String) {
        // Show an ugly error
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (presenter != nil) {
            presenter!.stopAll()
        }
    }
}