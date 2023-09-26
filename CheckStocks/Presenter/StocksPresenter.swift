//
//  ViewModel.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//



import Foundation
protocol StocksMainPresenterProtocol {
    var rowModels: [PropertyRowStockModel] { get set }
    var currentList: [PropertyRowStockModel] { get set }
    
    func didLoadStocks()
}

class StocksPresenter: StocksMainPresenterProtocol {
    weak var view: StocksMainViewProtocol?
    
    private var quote: Quote?
    private var company: Company?
    
    private let networkService = NetworkService()
    private var coreDataService = CoreDataService()
    
    var rowModels: [PropertyRowStockModel] = []
    var currentList: [PropertyRowStockModel] = []
    
    private var tickers: [String] { return UserDefaults.tickers }
    

    
    func didLoadStocks() {
        loadAllTickers()
        print("load")
    }
    
    private func loadAllTickers() {
        print("1")
        let dispatchGroup = DispatchGroup()

        for ticker in tickers {
            dispatchGroup.enter()
            networkService.fetchCompany(for: ticker) { [weak self] company  in
                guard let self = self else { return }
                self.networkService.fetchQuote(for: ticker) { [weak self] quote in
                    guard let self = self else { return }
                    let stock = Stock(companyProfile: company, quote: quote)
                    self.coreDataService.update(with: stock)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .global()) {
            self.update()
        }
        self.update()
    }

    private func update() {
        print("update")
        guard let dataModels = coreDataService.fetchStock() else { return }
        rowModels = dataModels.compactMap ({ model in
            return PropertyRowStockModel(
                tickerName: model.ticker ?? "",
                name: model.name ?? "",
                image: model.logo ?? "",
                deltaPrice: model.d,
                currentPrice: model.c,
                deltaProcent: model.dp,
                isFavorite: model.isFavourite
            )
        })
        
        currentList = rowModels
        print(currentList)
        view?.reloadData()
    }
    
    
}
