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
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var colorString = ""
    var citiesList = ["Istanbul","Mugla","Washington","Ankara","Izmir","Konya","Eskisehir"]
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //GradientLayer
        self.gradientLayer(colorChange: colorString)
        
        //Collection View
        self.collectionView()
        
        //Current Date
        date()
    }

    
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
        //Her refresh olduğunda üst üste biniyordu. Sıfırlamak için yazılan kod satırıdır
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.yellow.withAlphaComponent(0.0).cgColor]
        
        //Şehir ve API girildi
        let city = "Maldiv"
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=20b43ada755ac843b75ba766f8afa9c4")
        self.locationLabel.text = "📍 \(city)"
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            
            
            if error != nil {
                print("Error!")
                
                //Hata yoksa devam
            }else{
                
                //Datada hata yoksa devam
                if data != nil {
                    
                    do {
                        
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                                
                        DispatchQueue.main.async {
                            
                            //Main Part
                            if let main = jsonResponse!["main"] as? [String:Any]{
                                
                                //degree label
                                if let temp = main["temp"] as? Double {
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
                                    self.colorString = "systemGreen"
                                
                                case "Thunderstorm":
                                    self.weatherImageView.image = UIImage(named:"thunderStorm.png")
                                    self.colorString = "darkGray"
                                    
                                case "Drizzle":
                                    self.weatherImageView.image = UIImage(named:"drizzle.png")
                                    self.colorString = "lightGray"
                                    
                                case "Rain":
                                    self.weatherImageView.image = UIImage(named:"showerRain.png")
                                    self.colorString = "systemBrown"
                                    
                                case "Snow":
                                    self.weatherImageView.image = UIImage(named: "snow.png")
                                    self.colorString = "white"
                                    
                                case "Mist","Smoke","Haze","Dust","Fog","Sand","Ash","Squall","Tornado":
                                    self.weatherImageView.image = UIImage(named: "mist.png")
                                    self.colorString = "systemGray4"
                                    
                                case "Clear":
                                    self.weatherImageView.image = UIImage(named: "clearSky.png")
                                    self.colorString = "systemTeal"
                                    
                                default:
                                    self.weatherImageView.image = UIImage(named: "brokenClouds.png")
                                    self.colorString = "yellow"
                                    
                                }
                                
                                //ImageView ve Label kısımlarını animasyonla değiştirmek için
                                self.animation()
                                self.gradientLayer(colorChange: self.colorString)

                                
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
    
    func gradientLayer(colorChange : String){
        
        
        let alpha = 0.7

        switch colorChange {
            
        case "systemGreen" :
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemGreen.withAlphaComponent(alpha).cgColor]
        case "darkGray" :
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.withAlphaComponent(alpha).cgColor]
        case "lightGray":
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.lightGray.withAlphaComponent(alpha).cgColor]
        case "systemBrown":
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBrown.withAlphaComponent(alpha).cgColor]
        case "white":
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(alpha).cgColor]
        case "systemGray4":
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemGray4.withAlphaComponent(alpha).cgColor]
        case "systemTeal":
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemTeal.withAlphaComponent(alpha).cgColor]
        
        default:
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemGreen.withAlphaComponent(alpha).cgColor]
        }
    
        gradientLayer.startPoint = CGPoint(x: 0.5, y: -2)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }

    func date(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let currentDate = dateFormatter.string(from: Date())
        self.dateLabel.text = "Today is \(currentDate)"

    }
    
    func animation(){
        
        //Animation
        UIView.transition(with: self.degreeLabel, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            // Bu bloğun içinde, görüntülenen metni değiştirin
        }, completion: nil)
        UIView.transition(with: self.humidityLabel, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            // Bu bloğun içinde, görüntülenen metni değiştirin
        }, completion: nil)
        UIView.transition(with: self.windSpeedLabel, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            // Bu bloğun içinde, görüntülenen metni değiştirin
        }, completion: nil)
        UIView.transition(with: self.locationLabel, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            // Bu bloğun içinde, görüntülenen metni değiştirin
        }, completion: nil)
        UIView.transition(with: self.weatherLabel, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            // Bu bloğun içinde, görüntülenen metni değiştirin
        }, completion: nil)
        UIView.transition(with: self.dateLabel, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            // Bu bloğun içinde, görüntülenen metni değiştirin
        }, completion: nil)
        UIView.transition(with: self.weatherImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            // Bu bloğun içinde, görüntülenen resmi değiştirin
        }, completion: nil)
    }
    
    func collectionView(){
        
        //CollectionView
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)


        
    }
    
        
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.cityLabel.text = citiesList[indexPath.item]
        cell.cityLabel.layer.cornerRadius = cell.frame.height / 2
        return cell
    }
    
    
    
}

