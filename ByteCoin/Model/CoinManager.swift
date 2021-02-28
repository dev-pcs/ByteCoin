//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8A8666F7-5F7A-47D4-88F0-CE50DEE973DF"
    
    var delegate: CoinManagerDelegate?
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in         //function within function
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(coinPrice: safeData){
                        let bitcoinPriceString = String(format: "%.3f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: bitcoinPriceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(coinPrice: Data) ->Double? {
        let decoder = JSONDecoder()
        do {
            let decodedCoinPrice = try decoder.decode(CoinData.self, from: coinPrice)
            let coinRate = decodedCoinPrice.rate
            return coinRate
        }catch{
            return nil
            self.delegate?.didFailWithError(error: error)
        }
    }
}
