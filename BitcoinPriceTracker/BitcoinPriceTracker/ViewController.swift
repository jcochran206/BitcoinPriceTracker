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
        // Do any additional setup after loading the view, typically from a nib.
        getPrice()
    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR"){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let urldata = data {
                    if let json = try? JSONSerialization.jsonObject(with: urldata, options: []) as? [String : Double] {
                        if let jsonDict = json {
                            DispatchQueue.main.async {
                                if let usdPrice = jsonDict["USD"]{
                                    self.usdPricelbl.text = "$\(usdPrice)"
                                }
                                if let eurPrice = jsonDict["EUR"]{
                                    self.eurPricelbl.text = "$\(eurPrice)"
                                }
                                if let jpyPrice = jsonDict["JPY"]{
                                    self.jpyPricelbl.text = "$\(jpyPrice)"
                                }
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
    
    @IBAction func refreshTapped(_ sender: Any) {
        getPrice()
    }
    
}

