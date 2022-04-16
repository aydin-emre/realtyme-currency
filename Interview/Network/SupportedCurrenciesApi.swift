//
//  SupportedCurrenciesApi.swift
//  Interview
//
//  Created by Emre AYDIN on 17.04.2022.
//

import Foundation
import Combine

enum SupportedCurrenciesApi {
    static func supportedCurrencies() -> AnyPublisher<[String], NetworkError> {
        guard let url = URL(string: CurrencyService.cryptoSupportedCurrenciesApiUrl) else {
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
            .decode(type: [String].self, decoder: JSONDecoder())
            .mapError { NetworkError.map($0) }
            .eraseToAnyPublisher()
    }
}
