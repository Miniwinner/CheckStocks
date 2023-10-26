//
//  SearchPresenter.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 11.10.23.
//

import Foundation

protocol SearchPresenterProtocol{
    
    func filterContentForSearchText(_ searchText: String)
    
    func changeIsFavorite(bool: Bool, ticker: String)
    
    func didLoad()
    
    func loadSearchTickers()
   
   // func clearSearchHistory()
    
   // func openDetailedVC(for index: Int)
    
    func detectRepeated(text: String)
    
    var filteredRows: [PropertyRowStockModel] { get set }
    
    var rowModels: [PropertyRowStockModel] { get set }
    
    var searchHistory: [String] { get set }
    
}


class SearchPresenter:SearchPresenterProtocol{
   
    weak var view:SearchViewProtocol?
    
    private var networkService = NetworkService()
    private var coreDataService = CoreDataService()
    
    private var searchedTickers = UserDefaults.searchedTickers
    private var tickers: [String] {
        return UserDefaults.tickers
    }
    
    private var dispatchGroup = DispatchGroup()
    
    var filteredRows: [PropertyRowStockModel] = []
    var rowModels: [PropertyRowStockModel] = []
    var searchHistory: [String] = []
    
    private var text: String?

    //MARK: LOAD TICKERS
    
    func didLoad() {
        loadAllTickers()
        loadSearchTickers()
    }
    
    private func loadAllTickers() {
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
        guard let dataModels = coreDataService.fetchStock() else { return }
        rowModels = dataModels.compactMap ({ model in
            return PropertyRowStockModel(
                tickerName: model.ticker ?? "",
                name: model.name ?? "",
                image: model.logo ?? "",
                deltaPrice: model.d,
                currentPrice: model.c,
                deltaProcent: model.dp,
                isFavourite: model.isFavourite
            )
        })
        
        view?.reloadData()
    }
    
    //MARK: SEARCH TEXT
    
    func filterContentForSearchText(_ searchText: String) {
        self.text = searchText
        didTapOnSearch()
        self.networkService.fetchStock(for: searchText.lowercased()) { [weak self]  stock in
            let model = PropertyRowStockModel(
                tickerName: stock.companyProfile.ticker,
                name: stock.companyProfile.name,
                image: stock.companyProfile.logo,
                deltaPrice: stock.quote.d,
                currentPrice: stock.quote.c,
                deltaProcent: stock.quote.dp,
                isFavourite: false
            )
            guard let self = self else { return }
            self.deleteRepeated(text: searchText, stock: stock, model: model)
            self.view?.reloadData()
        }
        self.view?.reloadData()
    }
    
   
    
    func loadSearchTickers() {
        for ticker in searchedTickers {
            searchHistory.append(ticker)
        }
    }
    
   //MARK: UI SEARCH HANDLERS
    
    private func addTickerInHistory(bool: Bool, text: String) {
        if bool == false && searchHistory.contains(text) {
            return
        } else if bool == true && !searchHistory.contains(text)  {
            UserDefaults.searchedTickers.append(text)
            self.searchHistory.append(text)
        }
    }
    
    func detectRepeated(text: String) {
        if searchHistory.contains(text) {
            return
        } else {
            UserDefaults.searchedTickers.append(text)
            self.searchHistory.append(text)
        }
    }
    
    private func deleteRepeated(text: String, stock: Stock, model: PropertyRowStockModel) {
        if self.rowModels.contains(where: { $0.tickerName.lowercased() == text.lowercased() }) {
            return
        } else {
            //self.addStock(at: stock)
            self.filteredRows.append(model)
        }
    }
    
    private func didTapOnSearch() {
        update()
        filteredRows = rowModels.filter { model -> Bool in
            return model.tickerName.lowercased().contains(self.text?.lowercased() ?? "")
        }
        view?.reloadData()
    }
    
    //MARK: FAVOURITE
    
    func changeIsFavorite(bool: Bool, ticker: String) {
        coreDataService.changeToFavorite(tickerString: ticker, isFavorite: bool)
        addTickerInHistory(bool: bool, text: ticker)
        didTapOnSearch()
    }
}
