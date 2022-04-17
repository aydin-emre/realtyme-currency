//
//  ViewController.swift
//  Interview
//
//  Created by Przemyslaw Szurmak on 29/01/2022.
//

import UIKit
import Combine

class CurrenciesViewController: UIViewController {

    typealias TableViewDataSource = UITableViewDiffableDataSource<Int, CryptoResponse>

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fiatCurrencyButton: UIButton!

    private var timer: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()
    private let selectedCurrency = CurrentValueSubject<String, Never>("USD")
    var snapshot = NSDiffableDataSourceSnapshot<Int, CryptoResponse>()
    var cryptos = Cryptos()

    private lazy var datasource: TableViewDataSource = {
        let datasource = TableViewDataSource(tableView: self.tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let `self` = self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.name
            cell.imageView?.frame = CGRect(x: 20.25, y: 12, width: 20, height: 20)

            DispatchQueue.global().async {
                ImageDownloader.download(url: itemIdentifier.image) { image in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                    }
                }
            }

            cell.detailTextLabel?.text = "\(itemIdentifier.currentPrice.formatAsPrice) \(self.selectedCurrency.value)"
            return cell
        }
        return datasource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        snapshot = datasource.snapshot()
        snapshot.appendSections([0])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureFiatSelector()
        configureCryptoSelector()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        timer?.cancel()
    }

    private func configureFiatSelector() {
        let allCurrencies = CurrenciesApi.allCurrencies()
        let supportedCurrencies = SupportedCurrenciesApi.supportedCurrencies()

        allCurrencies
            .zip(supportedCurrencies)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] currencies, supportedCurrencies in
                guard let `self` = self else { return }
                var actions: [UIAction] = []
                currencies.data.filter { currency in
                    return supportedCurrencies.contains { supportedCurrency in
                        return supportedCurrency == currency.id.lowercased()
                    }
                }.forEach({ currency in
                    let action = UIAction(title: currency.name, handler: { [unowned self] _ in
                        self.selectedCurrency.send(currency.id)
                    })
                    action.state = currency.id == self.selectedCurrency.value ? .on : .off
                    actions.append(action)
                })
                self.setCurrenciesMenu(with: actions)
            }
            .store(in: &subscriptions)
    }

    private func configureCryptoSelector() {
        selectedCurrency
            .sink(receiveValue: { value in
                cryptos(with: value)
            })
            .store(in: &subscriptions)

        timer = Timer.publish(every: 10, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let `self` = self else { return }
                cryptos(with: self.selectedCurrency.value)
            }

        func cryptos(with currency: String) {
            CryptosApi.cryptos(with: selectedCurrency.value) { cryptos, error in
                guard let cryptos = cryptos else {
                    print("Error: \(String(describing: error))")
                    return
                }

                self.cryptos = cryptos
                self.snapshot.deleteItems(self.snapshot.itemIdentifiers)
                self.snapshot.appendItems(cryptos, toSection: 0)
                self.datasource.apply(self.snapshot)
            }
        }
    }

    private func setCurrenciesMenu(with actions: [UIAction]) {
        let currenciesItems = UIMenu(title: "Fiat currencies", options: .displayInline, children: actions)
        fiatCurrencyButton.menu = currenciesItems
        fiatCurrencyButton.showsMenuAsPrimaryAction = true
        fiatCurrencyButton.changesSelectionAsPrimaryAction = true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCurrencyDetailVC" {
            if let viewController = segue.destination as? CurrencyDetailViewController,
               let row = tableView.indexPathForSelectedRow?.row {
                viewController.crypto = cryptos[row]
                viewController.currency = selectedCurrency.value
            }
        }
    }

}
