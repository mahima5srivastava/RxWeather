//
//  WeatherModel.swift
//  RxWeather
//
//  Created by MAHIMA on 20/07/20.
//  Copyright © 2020 MAHIMA. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let temp: Double?
    let humidity: Double?
}
struct WeatherResult: Codable {
    let main: Weather?
}
