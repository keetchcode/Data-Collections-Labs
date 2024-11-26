//
//  ToDoCell.swift
//  List
//
//  Created by Wesley Keetch on 10/24/24.
//

import UIKit

protocol ToDoCellDelegate: AnyObject {
  func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
  
  @IBOutlet weak var isCompleteButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  weak var delegate: ToDoCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func completeButtonTapped(_ sender: UIButton) {
    delegate?.checkmarkTapped(sender: self)
  }
  
}
