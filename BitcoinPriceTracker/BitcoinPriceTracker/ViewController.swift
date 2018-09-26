//
//  ViewController.swift
//  BitcoinPriceTracker
//
//  Created by Jonathan Cochran on 9/23/18.
//  Copyright © 2018 Jonathan Cochran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usdPricelbl: UILabel!
    @IBOutlet weak var eurPricelbl: UILabel!
    @IBOutlet weak var jpyPricelbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getDefaultPrices()
        getPrice()
    }
    
    func getDefaultPrices(){
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0{
            self.usdPricelbl.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD") + "~"
        }
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0{
            self.eurPricelbl.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR") + "~"
        }
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY")
        if jpyPrice != 0.0{
            self.jpyPricelbl.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY") + "~"
        }
    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR"){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let urldata = data {
                    if let json = try? JSONSerialization.jsonObject(with: urldata, options: []) as? [String : Double] {
                        if let jsonDict = json {
                            DispatchQueue.main.async {
                                
                                if let usdPrice = jsonDict["USD"]{
                                    
                                self.usdPricelbl.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
                                    UserDefaults.standard.set(usdPrice, forKey: "USD")
                                    
                                }
                                if let eurPrice = jsonDict["EUR"]{
                                    self.eurPricelbl.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
                                    UserDefaults.standard.set(eurPrice, forKey: "EUR")
                                }
                                if let jpyPrice = jsonDict["JPY"]{
                                    self.jpyPricelbl.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
                                    UserDefaults.standard.set(jpyPrice, forKey: "JPY")
                                }
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                    print("it worked")
                }else{
                    print("had issue")
                }
                }.resume()
        }
    }
    
    func doubleToMoneyString(price:Double,currencyCode:String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString = formatter.string(from: NSNumber(value: price))
        if priceString == nil {
            return "ERROR"
        } else {
            return priceString!
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        getPrice()
    }
    
}

