//
//  ViewController.swift
//  Interview
//
//  Created by Przemyslaw Szurmak on 29/01/2022.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fiatCurrencyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFiatSelector()
        
//        self.tableView.dataSource = UITableViewDiffableDataSource<..., ...>(tableView: self.tableView) { tableView, indexPath, itemIdentifier in
//            (...)
//            return cell
//        }
    }
    
    fileprivate func configureFiatSelector() {
        let currenciesItems = UIMenu(title: "More", options: .displayInline, children: [
            UIAction(title: "USD", handler: { _ in print("usd") }),
            UIAction(title: "PLN", handler: { _ in print("pln") }),
            /// - Note: configure using downloaded fiat currencies
        ])
        let menu = UIMenu(title: "Fiat currencies", children: [currenciesItems])
        
        fiatCurrencyButton.menu = menu
        fiatCurrencyButton.showsMenuAsPrimaryAction = true
        fiatCurrencyButton.changesSelectionAsPrimaryAction = true
    }
}

