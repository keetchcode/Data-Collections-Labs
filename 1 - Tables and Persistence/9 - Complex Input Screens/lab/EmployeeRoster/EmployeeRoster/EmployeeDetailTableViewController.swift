
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
  func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {

  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var dobLabel: UILabel!
  @IBOutlet var dobDatePicker: UIDatePicker!
  @IBOutlet var employeeTypeLabel: UILabel!
  @IBOutlet var saveBarButtonItem: UIBarButtonItem!

  weak var delegate: EmployeeDetailTableViewControllerDelegate?
  var employee: Employee?
  var employeeType: EmployeeType?
  var isEditingBirthday: Bool = false {
    didSet {
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    updateView()
    updateSaveButtonState()
  }

  func updateView() {
    if let employee = employee {
      navigationItem.title = employee.name
      nameTextField.text = employee.name
      dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
      dobLabel.textColor = .label
      employeeTypeLabel.text = employee.employeeType.description
      employeeTypeLabel.textColor = .label
    } else {
      navigationItem.title = "New Employee"
      prepareDobPicker()
    }
  }

  private func updateSaveButtonState() {
    let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeType != nil
    saveBarButtonItem.isEnabled = shouldEnableSaveButton
  }

  @IBAction func saveButtonTapped(_ sender: Any) {
    guard
      let name = nameTextField.text,
      let employeeType = employeeType
    else {
      return
    }

    let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
    delegate?.employeeDetailTableViewController(self, didSave: employee)
  }

  @IBAction func cancelButtonTapped(_ sender: Any) {
    employee = nil
  }

  @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
    updateSaveButtonState()
  }

  @IBAction func dobPickerValueChanged(_ sender: Any) {
    dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
  }


  @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
    let typeController = EmployeeTypeTableViewController(coder: coder)
    typeController?.delegate = self

    return typeController
  }


  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath == IndexPath(row: 2, section: 0) && isEditingBirthday == false {
      return 0
    } else {
      return UITableView.automaticDimension
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if indexPath == IndexPath(row: 1, section: 0) {
      isEditingBirthday.toggle()
      dobLabel.textColor = .label
      dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
  }

  func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
    self.employeeType = employeeType
    employeeTypeLabel.textColor = .black
    employeeTypeLabel.text = employeeType.description
    updateSaveButtonState()
  }

  private func prepareDobPicker()  {
    var dateComponents  = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    dateComponents.calendar = Calendar.current
    guard let currentYear = dateComponents.year else { return }
    dateComponents.month = 6
    dateComponents.day = 15
    dateComponents.year = (currentYear - 40)
    dobDatePicker.date = dateComponents.date ?? Date()
  }
}
