
import UIKit

class FurnitureDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  var furniture: Furniture?

  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var choosePhotoButton: UIButton!
  @IBOutlet var furnitureTitleLabel: UILabel!
  @IBOutlet var furnitureDescriptionLabel: UILabel!

  init?(coder: NSCoder, furniture: Furniture?) {
    self.furniture = furniture
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    updateView()
  }

  func updateView() {
    guard let furniture = furniture else {return}
    if let imageData = furniture.imageData,
       let image = UIImage(data: imageData) {
      photoImageView.image = image
    } else {
      photoImageView.image = nil
    }

    furnitureTitleLabel.text = furniture.name
    furnitureDescriptionLabel.text = furniture.description
  }

  @IBAction func choosePhotoButtonTapped(_ sender: Any) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self

    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)

    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)})
        alertController.addAction(cameraAction)
    }
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)})
        alertController.addAction(photoLibraryAction)
    }
    alertController.popoverPresentationController?.sourceView = sender as? UIButton
    present(alertController, animated: true, completion: nil)
}

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let selectedImage = info[.originalImage] as? UIImage else { return }

      photoImageView?.image = selectedImage
      if let image = photoImageView.image, let jpegData = image.jpegData(compressionQuality: 0.9) {
          furniture?.imageData = jpegData
      }
      dismiss(animated: true, completion: nil)
      updateView()
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
  }

  @IBAction func actionButtonTapped(_ sender: Any) {
    guard let image = photoImageView.image else { return }
    let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    activityController.popoverPresentationController?.sourceView = sender as? UIButton
    present(activityController, animated: true, completion: nil)
  }

}
