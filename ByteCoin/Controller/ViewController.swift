//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    //2 protocols added for UIpickerview(Data source and delegate)
    
    var coinManager = CoinManager()                                                                                 //object created from struct
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!                                                                      //UI labels
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        coinManager.delegate = self
        currencyPicker.delegate = self                                                                              //set the ViewController class as the delegate of the currencyPicker
        currencyPicker.dataSource = self                                                                            //set ViewController.swift as the datasource for the picker
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - UIPicker

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {     //Delegate method to display all the currencies
        return coinManager.currencyArray[row]                                                                       //Use row int to pick title from array
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {                //it will record the index number of the item
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {                                                   //No. of columns wanted in out UIPickerView (Datasource)
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {                    //No. of rows wanted in our UI PickerView (Datasource)
        return coinManager.currencyArray.count
    }
}
