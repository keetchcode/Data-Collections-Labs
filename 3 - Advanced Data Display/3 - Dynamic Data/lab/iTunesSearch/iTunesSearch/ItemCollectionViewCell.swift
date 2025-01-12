//
//  ItemCollectionViewCell.swift
//  iTunesSearch
//
//  Created by Wesley Keetch on 1/5/25.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell, ItemDisplaying {
  
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  
  static let placeholder = UIImage(systemName: "photo")!
}
