//
//  SearchConfigurator.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 11.10.23.
//

import Foundation
import UIKit

class SearchScreenConfigurator {
    static func config() -> UIViewController {
        let vc = SearchViewController()
        let presenter = SearchPresenter()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
}
