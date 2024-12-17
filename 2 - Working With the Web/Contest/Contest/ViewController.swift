//
//  ViewController.swift
//  Contest
//
//  Created by Wesley Keetch on 12/13/24.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func submitButton(_ sender: Any) {
    if let input = emailTextField.text, !input.isEmpty, input.contains("@") {

      performSegue(withIdentifier: "showDetailView", sender: Any?.self)

    } else {

      _ = self.self.emailTextField.center
      let x: CGFloat = 5

      UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubic, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
          self.emailTextField.transform = CGAffineTransform(translationX: x, y: 0)
        }

        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
          self.emailTextField.transform = CGAffineTransform(translationX: -x, y: 0)
        }

        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
          self.emailTextField.transform = CGAffineTransform(translationX: x, y: 0)
        }

        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
          self.emailTextField.transform = CGAffineTransformIdentity
        }
      })
    }
  }
}
