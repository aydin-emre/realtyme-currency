//
//  CryptosApi.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import Foundation
import Combine

enum CryptosApi {
    static func cryptos(with currency: String) -> AnyPublisher<Cryptos, NetworkError> {
        guard let url = URL(string: String(format: CurrencyService.cryptoApiUrl, currency)) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: url)

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw NetworkError.statusCode
                }
                return response.data
            }
            .decode(type: Cryptos.self, decoder: JSONDecoder())
            .mapError { NetworkError.map($0) }
            .eraseToAnyPublisher()
    }
}
