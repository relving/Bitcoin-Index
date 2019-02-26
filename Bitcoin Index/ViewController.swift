//
//  ViewController.swift
//  Bitcoin Index
//
//  Created by Lena Azmi on 18/02/2019.
//  Copyright © 2019 Lena Azmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://blockchain.info/ru/ticker"
    let currencyArray = ["RUB", "USD", "AUD", "BRL","CAD","CHF", "CLP", "CNY","DKK", "EUR","GBP","HKD","INR","ISK","JPY","NZD","PLN","SEK","SGD","THB","TWD"]

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var bitcoinCurrencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBitcoinPrice(url: baseURL, selectedRow: currencyArray[0])
        
        bitcoinCurrencyPicker.delegate = self
        bitcoinCurrencyPicker.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        getBitcoinPrice(url: baseURL, selectedRow: currencyArray[row])
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPrice(url: String, selectedRow: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let bitcoinPriceJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinPrice(json: bitcoinPriceJSON[selectedRow])
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinPrice(json : JSON) {
        
        if let bitcoinPriceResult = json["sell"].int {
            let priceSymbol = json["symbol"].string
            updateUIWithBitcoinPrice(price : String(bitcoinPriceResult), symbol : priceSymbol!)
        }
    }
    
    func updateUIWithBitcoinPrice(price : String, symbol : String ) {
        bitcoinPriceLabel.text = price + " " + symbol
    }


}

