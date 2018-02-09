//
//  AddEquipmentViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/10/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class AddEquipmentViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    

    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var buTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var nbvTextField: UITextField!
    @IBOutlet weak var aquireCostTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var poTextField: UITextField!
    @IBOutlet weak var assetCodeTextField: UITextField!
    @IBOutlet weak var blTextField: UITextField!
    
    // Equipment type picker
    let equipmentPicker = UIPickerView()
    
    // Setting QR scanner
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    //For reading QR
    var qrReadString : String?
    
    var equipmentList = ["Air Compressor","DAQ","Coflixp Basket","Flow Head Basket","Pipe Basket","BHS Kit","Burner","Centrifuge","Chemical Injection Pump","Coflixp Hose","Data Header","DWT","ESD","BOP ESD","Flanges","Flare line Basket","Flow Head","Forklift","Flare Stack","Ranarex","Gas Manifold","GSC","Gauge Carrier","Gauge Tank","Generator","Grease","Heating Jacket","Ignition System","Indirect Heater","Lab Cabin","Loading Gantry","Low Gas Meter","N2 Booster","Oil Manifold","OPC","PDC","Chart Recorder","Pressure Test Pump","RA Source","BOPSV","Separator","SCBA","Steam Generator","Water Bolier","Steam Exchanger","Stiff Joint","Storage Tank","Tank","SSV","Surge Tank","Trailer","Transfer Bench","Pump","Vacuum Pump"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Sorting the list
        let sortedEquipment = equipmentList.sorted()
        equipmentList = sortedEquipment
        // Setting up the type equipment picker list
        typeTextField.inputView = equipmentPicker
        equipmentPicker.delegate = self
        equipmentPicker.dataSource = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning == true){
            captureSession.stopRunning()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if (captureSession.isRunning == false){
//            captureSession.startRunning()
//        }
//    }


    
    //MARK:- Buttons
    
    @IBAction func saveTapped(_ sender: Any) {
        let ref = Database.database().reference()
        if typeTextField.text != "" && serialNumberTextField.text != "" && assetCodeTextField.text != "" {
            guard let assetcode = assetCodeTextField.text else {return}
            guard let serialNumber = serialNumberTextField.text else {return}
            guard let type = typeTextField.text else {return}
            guard let po = poTextField.text else {return}
            guard let nbv = nbvTextField.text else {return}
            guard let aquisitionCost = aquireCostTextField.text else {return}
            guard let bu = buTextField.text else {return}
            guard let bl = blTextField.text else {return}
            guard let notes = notesTextField.text else {return}
            guard let location = locationTextField.text else {return}
            let parameter = ["serialNumber":serialNumber,
                             "type":type,
                             "po":po,
                             "nbv":nbv,
                             "aquirecost":aquisitionCost,
                             "bu":bu,
                             "bl":bl,
                             "notes":notes,
                             "location":location]
            ref.child("equipment").child(assetcode).setValue(parameter)
        }
 
    }
    
    // MARK:- Buttons
    
    //QR code
    @IBAction func scanQRTapped(_ sender: Any) {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
    
    // MARK:- Functions
    
    // Functions for QR
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue!);
        }
//        dismiss(animated: true)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func found(code: String) {
        //        print(code)
        qrReadString = code
        if let equipmentArray = qrReadString?.components(separatedBy: "//"){
//            print(equipmentArray)
            if equipmentArray.count == 10 {
                typeTextField.text = equipmentArray[0]
                serialNumberTextField.text = equipmentArray[1]
                nbvTextField.text = equipmentArray[8]
                assetCodeTextField.text = equipmentArray[4]
                notesTextField.text = equipmentArray[6]
                buTextField.text = equipmentArray[2]
                blTextField.text = equipmentArray[3]
                aquireCostTextField.text = equipmentArray[7]
                poTextField.text = equipmentArray[5]
                locationTextField.text = equipmentArray[9]
                
                // Make the saving automatic
                
                let ref = Database.database().reference()
                if typeTextField.text != "" && serialNumberTextField.text != "" && assetCodeTextField.text != "" {
                    guard let assetcode = assetCodeTextField.text else {return}
                    guard let serialNumber = serialNumberTextField.text else {return}
                    guard let type = typeTextField.text else {return}
                    guard let po = poTextField.text else {return}
                    guard let nbv = nbvTextField.text else {return}
                    guard let aquisitionCost = aquireCostTextField.text else {return}
                    guard let bu = buTextField.text else {return}
                    guard let bl = blTextField.text else {return}
                    guard let notes = notesTextField.text else {return}
                    guard let location = locationTextField.text else {return}
                    let parameter = ["serialNumber":serialNumber,
                                     "type":type,
                                     "po":po,
                                     "nbv":nbv,
                                     "aquirecost":aquisitionCost,
                                     "bu":bu,
                                     "bl":bl,
                                     "notes":notes,
                                     "location":location]
                    ref.child("equipment").child(assetcode).setValue(parameter)
                }
                
            } else{
                captureSession.stopRunning()
                previewLayer.removeFromSuperlayer()
                alerting(issueTitle: "QR not supported", issueMessage: "This QR is not supported")
                let mainPage = MainPageViewController()
                self.navigationController?.popToViewController(mainPage, animated: true)
            }
        }
        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
        view.backgroundColor = UIColor.clear
//        let mainPage = MainPageViewController()
//        self.navigationController?.popToViewController(mainPage, animated: true)
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
        
    }
    
    // Alerting controller =====
    func alerting(issueTitle : String , issueMessage : String) {
        let alert = UIAlertController(title: issueTitle, message: issueMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   
    
    
    // MARK :- Data Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return equipmentList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return equipmentList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = equipmentList[row]
    }
    
    // Dismiss keyboard when touch empty space
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

/*
let ref = Database.database().reference()
if typeTextField.text != "" && serialNumberTextField.text != "" && assetCodeTextField.text != "" {
    ref.child("equipment").childByAutoId().child("assetcode").setValue(assetCodeTextField.text)
    ref.child("equipment").childByAutoId().child("serialNumber").setValue(serialNumberTextField.text)
    ref.child("equipment").childByAutoId().child("type").setValue(typeTextField.text)
    ref.child("equipment").childByAutoId().child("po").setValue(poTextField.text)
    ref.child("equipment").childByAutoId().child("nbv").setValue(nbvTextField.text)
    ref.child("equipment").childByAutoId().child("aquirecost").setValue(aquireCostTextField.text)
    ref.child("equipment").childByAutoId().child("bu").setValue(buTextField.text)
    ref.child("equipment").childByAutoId().child("bl").setValue(blTextField.text)
    ref.child("equipment").childByAutoId().child("notes").setValue(notesTextField.text)
    ref.child("equipment").childByAutoId().child("location").setValue(locationTextField.text)
}
*/

