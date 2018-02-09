//
//  AddCertificateViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import Firebase

class AddCertificateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var equipmentTypeTextField: UITextField!
    @IBOutlet weak var equipmentSNTextField: UITextField!
    @IBOutlet weak var assetCodeTextField: UITextField!
    @IBOutlet weak var cerTypeTextField: UITextField!
    @IBOutlet weak var cerDateTextField: UITextField!
    @IBOutlet weak var cerNotesTextField: UITextField!
    
    var equipmentType : String?
    var equipmentSN : String?
    var assetCode : String?
    var cerDate : Date?
    var cerExpiryDate : Date?
    var duration = 0
    var certificateTypeList  = ["MPI","UTM","Pressure Test","MS-1","MS-2","MS-3","MS-4","Load Test","Other"]
    let certificatePicker = UIPickerView()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEdit(stat: false)
        // Setting up the Type picker
        certificatePicker.delegate = self
        certificatePicker.dataSource = self
        cerTypeTextField.inputView = certificatePicker
        // Setting the Date Paicker
        createDatePicker()
        // Sort the pickr data
        let sortedCertificate = certificateTypeList.sorted()
        certificateTypeList = sortedCertificate
        // Setting up the textField
        equipmentSNTextField.text = equipmentSN
        equipmentTypeTextField.text = equipmentType
        assetCodeTextField.text = assetCode
    }

    // MARK:- Buttons
    @IBAction func saveCertificatePressed(_ sender: Any) {
        let ref = Database.database().reference().child("certificates")
        guard let myType = cerTypeTextField.text else {return}
        guard let myNotes = cerNotesTextField.text else {return}
        // Converting the Date to string
        guard let myDate = cerDate?.description else {return}
        // Adding amount of months to the Date of expiry
        var datecomponent = DateComponents()
        if cerTypeTextField.text == "MS-1"{
            duration = 3
        } else if cerTypeTextField.text == "MS-2"{
            duration = 6
        }else if cerTypeTextField.text == "MPI" {
            duration = 6
        }else if cerTypeTextField.text == "MS-4"{
            duration = 60
        }else {
            duration = 12
        }
        datecomponent.month = duration
        cerExpiryDate = Calendar.current.date(byAdding: datecomponent, to: cerDate!)
        // Converting the expriy date to String
        guard let myExpiry = cerExpiryDate?.description else {return}
        let parameter = ["type" : myType,
                         "Notes" : myNotes,
                         "Date" : myDate,
                         "expiry" : myExpiry,
                         "equipmentType" : equipmentType,
                         "equipmentsn" : equipmentSN]
        ref.child(assetCode!).childByAutoId().setValue(parameter)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Functions
    
    func textFieldEdit(stat : Bool) {
        equipmentTypeTextField.isEnabled = stat
        equipmentSNTextField.isEnabled = stat
        assetCodeTextField.isEnabled = stat
    }
    
    // for Date picker
    func createDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBar = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneBar], animated: false)
        cerDateTextField.inputAccessoryView = toolBar
        cerDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed (){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        cerDateTextField.text = "\(dateString)"
        cerDate = datePicker.date
        self.view.endEditing(true)
    }
    
    // MARK:- Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK:-  Picker delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return certificateTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return certificateTypeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cerTypeTextField.text = certificateTypeList[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
