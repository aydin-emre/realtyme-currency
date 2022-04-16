//
//  CurrenciesApi.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import Foundation
import Combine

enum CurrenciesApi {
    static func allCurrencies() -> AnyPublisher<CurrenciesResponse, NetworkError> {
        guard let url = URL(string: CurrencyService.allCurrenciesApiUrl) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }

        let session = URLSession(configuration: URLSessionConfiguration.default)
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
            .decode(type: CurrenciesResponse.self, decoder: JSONDecoder())
            .mapError { NetworkError.map($0) }
            .eraseToAnyPublisher()
    }
}
