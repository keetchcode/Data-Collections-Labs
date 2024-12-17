
import UIKit

@MainActor
class StoreItemListTableViewController: UITableViewController {

  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var filterSegmentedControl: UISegmentedControl!

  // add item controller property

  var items = [StoreItem]()
  var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
  var storeItemController = StoreItemController()
  let queryOptions = ["movie", "music", "software", "ebook"]

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  func fetchMatchingItems() {

    self.items = []
    self.tableView.reloadData()

    let searchTerm = searchBar.text ?? ""
    let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]

    if !searchTerm.isEmpty {

      // set up query dictionary
      let query = [
        "term" : searchTerm,
        "media": mediaType,
        "limit": "10",
        "lang": "en_us"
      ]

      // use the item controller to fetch items
      Task {
        do {
          self.items = try await storeItemController.fetchItems(matching: query)
          self.tableView.reloadData()
        } catch {
          throw itemsError.itemNotFound
        }
      }
      // if successful, use the main queue to set self.items and reload the table view
      // otherwise, print an error to the console
    }
  }

  func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? ItemCell else { return }
    let item = items[indexPath.row]

    configure(cell: cell, for: item, indexPath: indexPath)
  }


  func configure(cell: ItemCell, for item: StoreItem, indexPath: IndexPath) {
    // set cell.name to the item's name
    cell.name = item.name

    // set cell.artist to the item's artist
    cell.artist = item.artist

    // set cell.artworkImage to nil
    cell.artworkImage = nil

    // initialize a network task to fetch the item's artwork keeping track of the task
    // in imageLoadTasks so they can be cancelled if the cell will not be shown after
    // the task completes.
    imageLoadTasks[indexPath] = Task {
      // Code to fetch the image using the URL
      let task = URLSession.shared.dataTask(with: item.artworkURL) { [weak self] data, response, error in
        guard let data = data, error == nil else { return }

        DispatchQueue.main.async { [weak self] in // execute on main thread
          cell.artworkImage = UIImage(data: data)
          self?.imageLoadTasks[indexPath] = nil
        }
      }

      task.resume()
      // Once the task is complete remove it from the list of pending tasks
    }
    // if successful, set the cell.artworkImage using the returned image

  }

  @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {

    fetchMatchingItems()
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
    configure(cell: cell, forItemAt: indexPath)

    return cell
  }

  // MARK: - Table view delegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // cancel the image fetching task if we no longer need it
    imageLoadTasks[indexPath]?.cancel()
  }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    fetchMatchingItems()
    searchBar.resignFirstResponder()
  }
}
