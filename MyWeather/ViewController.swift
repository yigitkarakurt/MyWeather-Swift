//
//  ViewController.swift
//  MyWeather
//
//  Created by Yiğit Karakurt on 29.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var color = "yellow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gradientLayer()
        refreshButtonClicked(UIButton())
        date()
    }

    func gradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.yellow.withAlphaComponent(0.6).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: -2)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
                
        var city = "Ardahan"
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=20b43ada755ac843b75ba766f8afa9c4")
        self.locationLabel.text = "📍 \(city)"
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            
            if error != nil {
                print("Error!")
                
            }else{
                
                if data != nil {
                    
                    do {
                        
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                                
                        DispatchQueue.main.async {
                            
                            //Main Part
                            if let main = jsonResponse!["main"] as? [String:Any]{
                                
                                //degree label
                                if var temp = main["temp"] as? Double {
                                    let temp2 = Int(temp-272.15)
                                    self.degreeLabel.text = "\(temp2) °"
                                }
                                
                                //humidity label
                                if let humidity = main["humidity"] as? Int {
                                    self.humidityLabel.text = "%\(humidity)"
                                }
                            }
                            
                            //Wind Part
                            if let wind = jsonResponse!["wind"] as? [String:Any]{
                                
                                if let speed = wind["speed"] as? Double{
                                    self.windSpeedLabel.text = "\(speed) km/h"
                                    
                                }
                            }
                            
                            //Weather Part
                            if let jsonDictionary = jsonResponse,let weatherArray = jsonDictionary["weather"] as? [[String:Any]],let mainValue = weatherArray[0]["main"] as? String{
                                    //Burada havanın nasıl olacağını öğrendik(bulutlu, yağmurlu vs)
                                
                                
                                switch mainValue {
                                
                                case "Clouds":
                                    self.weatherImageView.image = UIImage(named:"brokenClouds.png")
                                    //Arka Plan Rengi
                                    self.color = "yellow"
                                
                                case "Thunderstorm":
                                    self.weatherImageView.image = UIImage(named:"thunderStorm.png")
                                    self.color = "darkGrey"
                                    
                                case "Drizzle":
                                    self.weatherImageView.image = UIImage(named:"drizzle.png")
                                    self.color = "lightGray"
                                    
                                case "Rain":
                                    self.weatherImageView.image = UIImage(named:"showerRain.png")
                                    self.color = "systemBrown"
                                    
                                case "Snow":
                                    self.weatherImageView.image = UIImage(named: "snow.png")
                                    self.color = "white"
                                    
                                case "Mist","Smoke","Haze","Dust","Fog","Sand","Ash","Squall","Tornado":
                                    self.weatherImageView.image = UIImage(named: "mist.png")
                                    self.color = "systemGray4"
                                    
                                case "Clear":
                                    self.weatherImageView.image = UIImage(named: "clearSky.png")
                                    self.color = "systemTeal"
                                    
                                default:
                                    self.weatherImageView.image = UIImage(named: "brokenClouds.png")
                                    self.color = "yellow"
                                    
                                }
                                
                                
                                
                                

                                
                            }
                            
                            //Hava tanımı(fog, clear sky gibi)
                            if let jsonDictionary = jsonResponse,let weatherArray = jsonDictionary["weather"] as? [[String:Any]],let descriptionValue = weatherArray[0]["description"] as? String{
                                
                                self.weatherLabel.text = String(descriptionValue)
                                
                                
                            }
                                
                        }
                    } catch {
                        
                    }
                    
                }
                
            }
            
            
        }
        task.resume()
    }
    
    
    
    
    func date(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let currentDate = dateFormatter.string(from: Date())
        self.dateLabel.text = "Today is \(currentDate)"

    }
    
    
}

