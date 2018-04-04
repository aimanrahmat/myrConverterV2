//
//  ViewController.swift
//  myrConverter
//
//  Created by Admin on 26/03/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

struct Currency:Decodable{
    let base: String
    let date: String
    let rates: [String:Double]
}

class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var conversionTable: UITableView!
    
    var myr:Currency?
    var baseRate = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        conversionTable.dataSource = self
        conversionTable.allowsSelection = false
        fetchData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencyFetched = myr{
            return currencyFetched.rates.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier:nil)
        if let currencyFetched = myr{
            cell.textLabel?.text = Array(currencyFetched.rates.keys)[indexPath.row]
            let selectedRate = baseRate * Array(currencyFetched.rates.values)[indexPath.row]
            cell.detailTextLabel?.text = "\(selectedRate)"
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func Convert(_ sender: UIButton) {
        if let iGetString = input.text{
            if let isDouble = Double(iGetString){
                baseRate = isDouble
                fetchData()
            }
        }
    }
    
    func fetchData(){
        let url = URL(string: "https://api.fixer.io/latest?base=MYR")
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            if error == nil{
                do{
                    self.myr = try JSONDecoder().decode(Currency.self, from: data!)
                }catch{
                    print("parseError")
                }
                DispatchQueue.main.async {
                    self.conversionTable.reloadData()
                }
            }else{
                print("Error")
            }
        }.resume()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

