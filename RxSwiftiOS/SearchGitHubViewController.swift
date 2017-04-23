import UIKit
import Unbox

import RxSwift
import RxCocoa

class SearchGitHubViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    private let bag = DisposeBag()
    private let repos = Variable<[Repo]>([])
    private let presenter = SearchPresenter(SearchManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    func bindUI() {
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return query.characters.count > 2
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest{ query -> Observable<[Repo]> in
                return self.presenter.getRepos(query)
            }
            .bindTo(tableView.rx.items) { tableView, row, repo in
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                let user : String = (repo.username) != nil ? repo.username! : ""
                cell.textLabel!.text = String(row) + "-" + repo.name + " (by: " + user + ")"
                cell.detailTextLabel?.text = repo.language

                return cell
            }
            .addDisposableTo(bag)
    }

}