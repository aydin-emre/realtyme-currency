//
//  ImageDownloader.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import UIKit

enum ImageDownloader {
    static func download(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
