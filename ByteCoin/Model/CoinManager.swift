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
    let apiKey = "key"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(byteData: safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                                      
                            self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(byteData: Data)-> Double? {
        let decoder = JSONDecoder()
        print(byteData)
        
        do {
            let docodedData = try decoder.decode(CoinData.self, from: byteData)
            
            let lastPrice = docodedData.rate
            print(lastPrice)
            return lastPrice
        
        
        } catch {
            self.delegate?.didFailWithError(error: error)
            print(error)
            return nil
 
        }
    }
    
}
