import UIKit

class DatePicker: UIViewController {

    var dateArray: [Date]!
    var onDone: ((String) -> Void)?
    var onCancel: (() -> Void)?

    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        datePicker.frame = CGRect(x: 0, y: view.frame.height - 300, width: view.frame.width, height: 300)
        toolBar.frame = CGRect(x: 0, y: view.frame.height - 300 - 44, width: view.frame.width, height: 44)
        toolBar.backgroundColor = .clear
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
    }

    @objc func doneTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Set the desired format for the date
        let dateString = dateFormatter.string(from: datePicker.date)
        onDone?(dateString)
        dismiss(animated: true, completion: nil)
    }


    @objc func cancelTapped() {
        onCancel?()
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        datePicker.datePickerMode = .date
        view.backgroundColor = .clear

        doneButton.tintColor = .black
        cancelButton.tintColor = .black
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)

        view.addSubview(datePicker)
        view.addSubview(toolBar)
    }
}

extension DatePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: dateArray[row])
    }
}






import UIKit

class ArrayItemPicker: UIViewController {
    var stringArray: [String]!
    var onDone: ((Int) -> Void)?
    var onCancel: (() -> Void)?
    let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        pickerView.frame = CGRect(x: 0, y: view.frame.height - 300, width: view.frame.width, height: 300)
        toolBar.frame = CGRect(x: 0, y: view.frame.height - 300 - 44, width: view.frame.width, height: 44)
        toolBar.backgroundColor = .clear
        pickerView.backgroundColor = .white
    }

    @objc func doneTapped() {
        onDone?(pickerView.selectedRow(inComponent: 0))
        dismiss(animated: true, completion: nil)
    }

    @objc func cancelTapped() {
        onCancel?()
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
        pickerView.dataSource = self
        pickerView.delegate = self
        view.backgroundColor = .clear

        doneButton.tintColor = .black
        cancelButton.tintColor = .black
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)

        view.addSubview(pickerView)
        view.addSubview(toolBar)
    }
}

extension ArrayItemPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stringArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stringArray[row]
    }
}
