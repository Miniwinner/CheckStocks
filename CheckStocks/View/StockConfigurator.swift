//
//  StockConfigurator.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 22.09.23.
//

import Foundation
import UIKit

class MainScreenConfigurator {
    static func config() -> UIViewController {
        let vc = ViewController()
        let presenter = StocksPresenter()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
}
