//
//  BookTableViewCell.swift
//  FavoriteBooks
//
//  Created by Wesley Keetch on 11/18/24.
//

import UIKit

class BookTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var lengthLabel: UILabel!

  func updateValueLabels(with book: Book) {
    titleLabel.text = book.title
    authorLabel.text = book.author
    genreLabel.text = book.genre
    lengthLabel.text = book.length
  }

}
