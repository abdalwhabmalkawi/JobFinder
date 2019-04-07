//
//  ViewController.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//
import SwiftyJSON
import UIKit
import CoreLocation
class ViewController: AbdalwhabVC {
    @IBOutlet weak var providerTF: ClassTextFieldSizeClass!
    @IBOutlet weak var filterByLonLat: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AbdalwhabLocationManager.sharedInstance.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(SelectLocationFillter(_:)))
        tap.delegate = self
        self.filterByLonLat.addGestureRecognizer(tap)

    }
    @objc func SelectLocationFillter(_ gesture: UIGestureRecognizer) {
        if !AbdalwhabLocationManager.sharedInstance.checkLocationAuthorization() {
            self.ShowNotifyType1(message: "You must add permision Location from setting app", theme: .error)
            return
        }
        if AbdalwhabManager.instance.fillerByLonLat {
            self.filterByLonLat.backgroundColor = UIColor(named: "grayColor")
            AbdalwhabManager.instance.fillerByLonLat = false
        }else {
            self.filterByLonLat.backgroundColor = UIColor(named: "purpleColor")
            AbdalwhabManager.instance.fillerByLonLat = true
        }
    }
    
    @IBAction func NextBT(_ sender: Any){
        if AbdalwhabManager.instance.selectedBaseURL == "" {
            self.ShowNotifyType1(message: "You must select povider", theme: .error)
            return
        }
        self.performSegue(withIdentifier: "SearchVC", sender: nil)
    }
    @IBAction func SelectProvider(_ sender: ClassTextFieldSizeClass) {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        sender.inputView = picker
    }
    
}

extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AbdalwhabManager.instance.baseURL.count + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return ""
        }
        return AbdalwhabManager.instance.baseURL[row-1]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            let selectedProvider = AbdalwhabManager.instance.baseURL[row-1]
            self.providerTF.text = selectedProvider
            AbdalwhabManager.instance.selectedBaseURL = selectedProvider
        }else {
            self.providerTF.text = ""
            AbdalwhabManager.instance.selectedBaseURL = ""
        }
    }
    
}

extension ViewController : AbdalwhabLocationManagerDelegate {
    // to get user current location
    func didGetUserLocation(_ userLocation: CLLocation) {
        AbdalwhabManager.instance.long = String(userLocation.coordinate.longitude)
        AbdalwhabManager.instance.lat = String(userLocation.coordinate.latitude)
    }

}
