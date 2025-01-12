//
//  OrderConfirmatonViewController.swift
//  RestaurantApp
//
//  Created by Wesley Keetch on 1/4/25.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

  @IBOutlet weak var confirmationLabel: UILabel!

  let minutesToPrepare: Int
  init?(coder: NSCoder, minutesToPrepare: Int) {
    self.minutesToPrepare = minutesToPrepare
    super.init(coder: coder)

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    confirmationLabel.text = "Thank you for your order! Your Wait time is approximately \(minutesToPrepare) minutes"
  }

}
