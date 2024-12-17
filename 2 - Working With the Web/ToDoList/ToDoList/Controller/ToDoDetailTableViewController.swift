//
//  ToDoDetailTableViewController.swift
//  List
//
//  Created by Wesley Keetch on 10/24/24.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
  
  @IBOutlet var titleTextField: UITextField!
  @IBOutlet var isCompleteButton: UIButton!
  @IBOutlet var dueDateLabel: UILabel!
  @IBOutlet var dueDatePicker: UIDatePicker!
  @IBOutlet var notesTextView: UITextView!
  @IBOutlet var saveButton: UIBarButtonItem!
  
  var toDo: ToDo?
  var isDatePickerHidden = true
  let dateLabelIndexPath = IndexPath(row: 0, section: 1)
  let datePickerIndexPath = IndexPath(row: 1, section: 1)
  let notesIndexPath = IndexPath(row: 0, section: 2)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let currentDueDate: Date
    if let toDo = toDo {
      navigationItem.title = "To-Do"
      titleTextField.text = toDo.title
      isCompleteButton.isSelected = toDo.isComplete
      currentDueDate = toDo.dueDate
      notesTextView.text = toDo.notes
    } else {
      currentDueDate = Date().addingTimeInterval(24*60*60)
    }
    
    dueDatePicker.date = currentDueDate
    updateDueDateLabel(date: currentDueDate)
    updateSaveButtonState()
  }
  
  func updateDueDateLabel(date: Date) {
    dueDateLabel.text = date.formatted(
      .dateTime
        .month(.defaultDigits)
        .day()
        .year(.twoDigits)
        .hour()
        .minute()
    )
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    guard segue.identifier == "saveUnwind" else { return }
    
    let title = titleTextField.text!
    let isComplete = isCompleteButton.isSelected
    let dueDate = dueDatePicker.date
    let notes = notesTextView.text
    
    if toDo != nil {
      toDo?.title = title
      toDo?.isComplete = isComplete
      toDo?.dueDate = dueDate
      toDo?.notes = notes
    } else {
      toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath == dateLabelIndexPath {
      isDatePickerHidden.toggle()
      updateDueDateLabel(date: dueDatePicker.date)
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case datePickerIndexPath:
      return 216
    case notesIndexPath:
      return 200
    default:
      return UITableView.automaticDimension
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case datePickerIndexPath where isDatePickerHidden == true:
      return 0
    case notesIndexPath:
      return 200
    default:
      return UITableView.automaticDimension
    }
  }
  
  @IBAction func datePickerChanged(_ sender: UIDatePicker) {
    updateDueDateLabel(date: sender.date)
  }
  
  func updateSaveButtonState() {
    let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
    saveButton.isEnabled = shouldEnableSaveButton
  }
  
  @IBAction func textEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }
  
  @IBAction func returnPressed(_ sender: UITextField) {
    sender.resignFirstResponder()
  }
  
  @IBAction func isCompleteButtonTapped(_ sender: Any) {
    isCompleteButton.isSelected.toggle()
  }
  
}
