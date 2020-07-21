//
//  URLRequest+Extension.swift
//  RxWeather
//
//  Created by MAHIMA on 20/07/20.
//  Copyright © 2020 MAHIMA. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct Resource<T: Decodable> {
    let url: URL
}

protocol NetworkProtocol {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

struct NetworkResource: NetworkProtocol {
    
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url).flatMap { url -> Observable<Data> in
            let request = URLRequest(url: url)
            return URLSession.shared.rx.data(request: request)
        }.map { data -> T in
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
