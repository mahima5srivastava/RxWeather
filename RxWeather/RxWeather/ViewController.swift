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

    @IBOutlet weak var humidityTextField: UILabel!
    @IBOutlet weak var temperatureTextField: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.rx.value.subscribe(onNext: {[weak self] city in
            guard let city = city, !city.isEmpty else {
                self?.displayWeather(nil)
                return
                
            }
            self?.fetchWeather(for: city)
            }).disposed(by: disposeBag)
    }

    private func displayWeather(_ weather: Weather?) {
        DispatchQueue.main.async {
            if let weather = weather {
                self.temperatureTextField.text = "\(weather.temp ?? 0.0)"
                self.humidityTextField.text = "\(weather.humidity ?? 0.0)"
            } else {
                self.temperatureTextField.text = ""
                self.humidityTextField.text = ""
            }
        }
        
    }
    
    private func fetchWeather(for city: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=fedc8496d0971019df7563ba6c49d33c") else {return}
        let resource = Resource<WeatherResult>(url: url)
        URLRequest.load(resource: resource).subscribe(onNext: { result in
            self.displayWeather(result.main)
        }).disposed(by: disposeBag)
    }

}

