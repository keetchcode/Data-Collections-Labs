
import UIKit

@MainActor
class StoreItemContainerViewController: UIViewController, UISearchResultsUpdating {
  
  @IBOutlet var tableContainerView: UIView!
  @IBOutlet var collectionContainerView: UIView!
  
  let searchController = UISearchController()
  let storeItemController = StoreItemController()
  
  weak var collectionViewController: StoreItemCollectionViewController?
  
  var tableViewDataSource: StoreItemTableViewDiffableDataSource!
  var collectionViewDataSource: UICollectionViewDiffableDataSource<String, StoreItem>!
  
  var itemsSnapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
  
  var selectedSearchScope: SearchScope {
    let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
    let searchScope = SearchScope.allCases[selectedIndex]
    return searchScope
  }
  
  var searchTask: Task<Void, Never>? = nil
  var tableViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
  var collectionViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.automaticallyShowsSearchResultsController = true
    searchController.searchBar.showsScopeBar = true
    searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let tableViewController = segue.destination as? StoreItemListTableViewController {
      configureTableViewDataSource(tableViewController.tableView)
    }
    
    if let collectionViewController = segue.destination as? StoreItemCollectionViewController {
      collectionViewController.configureCollectionViewLayout(for: selectedSearchScope)
      configureCollectionViewDataSource(collectionViewController.collectionView)
      self.collectionViewController = collectionViewController
    }
  }
  
  func configureTableViewDataSource(_ tableView: UITableView) {
    tableViewDataSource = StoreItemTableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
      
      self.tableViewImageLoadTasks[indexPath]?.cancel()
      self.tableViewImageLoadTasks[indexPath] = Task {
        await cell.configure(for: item, storeItemController: self.storeItemController)
        self.tableViewImageLoadTasks[indexPath] = nil
      }
      
      return cell
    })
  }
  
  func configureCollectionViewDataSource(_ collectionView: UICollectionView) {
    collectionViewDataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! ItemCollectionViewCell
      
      self.collectionViewImageLoadTasks[indexPath]?.cancel()
      self.collectionViewImageLoadTasks[indexPath] = Task {
        await cell.configure(for: item, storeItemController: self.storeItemController)
        self.collectionViewImageLoadTasks[indexPath] = nil
      }
      
      return cell
    })
    
    collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
      
      let headerView =
      collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: StoreItemCollectionViewSectionHeader.reuseIdentifier, for: indexPath) as! StoreItemCollectionViewSectionHeader
      let title = self.itemsSnapshot.sectionIdentifiers[indexPath.section]
      headerView.setTitle(title)
      
      return headerView
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
    perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
  }
  
  @IBAction func switchContainerView(_ sender: UISegmentedControl) {
    tableContainerView.isHidden.toggle()
    collectionContainerView.isHidden.toggle()
  }
  
  func createSectionedSnapshot(from items: [StoreItem]) ->
  NSDiffableDataSourceSnapshot<String, StoreItem> {
    
    let movies = items.filter { $0.kind == "feature-movie" }
    let music = items.filter { $0.kind == "song" || $0.kind == "album" }
    let apps = items.filter { $0.kind == "software" }
    let books = items.filter { $0.kind == "ebook" }
    
    let grouped: [(SearchScope, [StoreItem])] = [
      (.movies, movies),
      (.music, music),
      (.apps, apps),
      (.books, books)
    ]
    
    var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
    grouped.forEach { (scope, items) in
      if items.count > 0 {
        snapshot.appendSections([scope.title])
        snapshot.appendItems(items, toSection: scope.title)
      }
    }
    
    return snapshot
  }
  
  
  func handleFetchedItems(_ items: [StoreItem]) async {
    
    let currentSnapshotItems = itemsSnapshot.itemIdentifiers
    let updatedSnapshot = createSectionedSnapshot(from: currentSnapshotItems + items)
    itemsSnapshot = updatedSnapshot
    
    collectionViewController?.configureCollectionViewLayout(for: selectedSearchScope)
    
    await tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
    await collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
  }
  
  func fetchAndHandleItemsForSearchScopes(_ searchScopes: [SearchScope], withSearchTerm searchTerm: String) async throws {
    
    try await withThrowingTaskGroup(of: (SearchScope, [StoreItem]).self) { group in
      try Task.checkCancellation()
      for searchScope in searchScopes { group.addTask {
        try Task.checkCancellation()
        let query = [
          "term": searchTerm,
          "media": searchScope.mediaType,
          "lang": "en_us",
          "limit": "50"
        ]
        return (searchScope, try await self.storeItemController.fetchItems(matching: query))
      }
      }
      for try await (searchScope, items) in group {
        try Task.checkCancellation()
        if searchTerm == self.searchController.searchBar.text && (self.selectedSearchScope == .all || searchScope == self.selectedSearchScope) {
          await handleFetchedItems(items)
        }
      }
    }
  }
  
  @objc func fetchMatchingItems() {
    
    itemsSnapshot.deleteAllItems()
    let searchTerm = searchController.searchBar.text ?? ""
    
    let searchScopes: [SearchScope]
    if selectedSearchScope == .all {
      searchScopes = [.movies, .music, .apps, .books]
    } else {
      searchScopes = [selectedSearchScope]
    }
    
    collectionViewImageLoadTasks.values.forEach { task in task.cancel() }
    collectionViewImageLoadTasks = [:]
    tableViewImageLoadTasks.values.forEach { task in task.cancel() }
    tableViewImageLoadTasks = [:]
    
    searchTask?.cancel()
    searchTask = Task {
      if !searchTerm.isEmpty {
        
        do {
          try await fetchAndHandleItemsForSearchScopes(searchScopes, withSearchTerm: searchTerm)
        } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
        } catch {
          print(error)
        }
        
      } else {
        await self.tableViewDataSource.apply(self.itemsSnapshot, animatingDifferences: true)
        await self.collectionViewDataSource.apply(self.itemsSnapshot, animatingDifferences: true)
      }
      searchTask = nil
    }
  }
  
}
