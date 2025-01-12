//
//  StoreItemTableViewDiffableDataSource.swift
//  iTunesSearch
//
//  Created by Wesley Keetch on 1/6/25.
//

import Foundation
import UIKit

@MainActor
class StoreItemTableViewDiffableDataSource: UITableViewDiffableDataSource<String, StoreItem> {
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return snapshot().sectionIdentifiers[section]
  }
}
