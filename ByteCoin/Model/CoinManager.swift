//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate: AnyObject {
    func didUpdateRate(_ coinManager: CoinManager, rate: Double)
    func didFailWithError(_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    weak var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/apikey-559B999B-6165-475B-A10F-42C5BCAED114/exchangerate/BTC/"
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    
    func getCoinPrice(for currency: String) {
        performRequest(with: baseURL + currency)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error {
                    delegate?.didFailWithError(self, error: error)
                }
                if let safeData = data {
                    if let rate = parseJSON(safeData) {
                        delegate?.didUpdateRate(self, rate: rate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
}
