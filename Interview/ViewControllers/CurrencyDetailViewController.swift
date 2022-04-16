//
//  CurrencyDetailViewController.swift
//  Interview
//
//  Created by Przemyslaw Szurmak on 29/01/2022.
//

import UIKit

class CurrencyDetailViewController: UIViewController {

    var crypto: CryptoResponse?
    var currency: String?

    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var highestPriceLabel: UILabel!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var lastUpdateTimeLabel: UILabel!

    private let dateFormatterGet = DateFormatter()
    private let dateFormatterPrint = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.XXX'Z'"
        dateFormatterPrint.dateFormat = "HH:mm:ss dd.MM.yyyy"

        setupViews()
    }

    private func setupViews() {
        guard let currency = currency,
              let crypto = crypto else { return }
        ImageDownloader.download(url: crypto.image) { [unowned self] image in
            guard let image = image else { return }
            DispatchQueue.main.async { [self] in
                currencyImageView.image = image
            }
        }
        self.title = crypto.name
        symbolLabel.text = crypto.name
        highestPriceLabel.text = "\(crypto.high24H.formatAsPrice) \(currency)"
        lowestPriceLabel.text = "\(crypto.low24H.formatAsPrice) \(currency)"
        if let date = dateFormatterGet.date(from: crypto.lastUpdated) {
            lastUpdateTimeLabel.text = dateFormatterPrint.string(from: date)
        }
    }

}
