//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        coinManager.getCoinPrice(for: coinManager.currencyArray.first!)
        currencyLabel.text = coinManager.currencyArray.first
    }
}

//MARK: UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
}

//MARK: UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
        currencyLabel.text = coinManager.currencyArray[row]
    }
}

//MARK: CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdateRate(_ coinManager: CoinManager, rate: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.bitcoinLabel.text = String(format: "%.2f", rate)
        }
    }
    
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print("Did fail with error: \(error.localizedDescription)")
    }
}
