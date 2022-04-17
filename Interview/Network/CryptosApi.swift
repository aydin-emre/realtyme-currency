//
//  CryptosApi.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import Foundation
import Combine

enum CryptosApi {
    static func cryptos(with currency: String, completion: @escaping (Cryptos?, NetworkError?) -> Void) {
        guard let url = URL(string: String(format: CurrencyService.cryptoApiUrl, currency)) else {
            completion(nil, NetworkError.invalidURL)
            return
        }

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: url)

        session.dataTask(with: urlRequest) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let decodedResponse = try? JSONDecoder().decode(Cryptos.self, from: data)
            else {
                completion(nil, NetworkError.statusCode)
                return
            }

            completion(decodedResponse, nil)
        }.resume()
    }
}
