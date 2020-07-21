//
//  ViewController.swift
//  RxWeather
//
//  Created by MAHIMA on 20/07/20.
//  Copyright © 2020 MAHIMA. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    let disposeBag = DisposeBag()
    var networkManager: NetworkProtocol = NetworkResource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityTextField.text }
            .subscribe(onNext: { city in
                
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(by city: String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&appid=fedc8496d0971019df7563ba6c49d33c") else {
                return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        
        /* With Binders
         let search = networkManager.load(resource: resource)
         .observeOn(MainScheduler.instance)
         .catchErrorJustReturn(WeatherResult.empty)
         search.map { "\($0.main.temp) ℉" }
         .bind(to: self.temperatureLabel.rx.text).disposed(by: disposeBag)
         search.map { "\($0.main.humidity) 💦" }
         .bind(to: self.humidityLabel.rx.text).disposed(by: disposeBag)
         */
        
        //With drivers
        let search = networkManager.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
        search.map { "\($0.main.temp) ℉" }
            .drive(self.temperatureLabel.rx.text).disposed(by: disposeBag)
        search.map { "\($0.main.humidity) 💦" }
            .drive(self.humidityLabel.rx.text).disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "🙈"
            self.humidityLabel.text = "⦰"
        }
    }

}

