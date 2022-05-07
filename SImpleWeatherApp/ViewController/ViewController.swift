//
//  ViewController.swift
//  SImpleWeatherApp
//
//  Created by Juma on 5/6/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var models = [Daily]()
    var error : Error?
    var myModel : WeatherResponse?
    var weekDays : [String] = []
    var refreshControl = UIRefreshControl()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblView.delegate = self
        tblView.dataSource = self
        
        GetDataFromIPA()
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
       refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: UIControl.Event.valueChanged)
        tblView.addSubview(refreshControl)
    }
  

  // Mark: Refresh the weather data by calling the API again
    @objc private func refreshWeatherData() {

        GetDataFromIPA()
        self.refreshControl.endRefreshing()
    }
    
    
    
    
    func GetDataFromIPA(){
        let strURL = "https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&appid=0bdf513bdc9ef9d4213de34f46610fc0"
        guard let url = URL.init(string: strURL) else {return}
        
        URLSession.shared.dataTask(with: url){ data , response , error in
            self.error = error
            if let data = data  , error == nil {
                do {

                    let result = try JSONDecoder.init().decode(WeatherResponse.self, from: data)
                    let entries = result.daily
                    self.models = entries
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }

                }catch{
                    print(error)
                }
            }

        }.resume()
  
    }

}



extension ViewController :  UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell

        cell.configure(with: models[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(142)
    }
}
