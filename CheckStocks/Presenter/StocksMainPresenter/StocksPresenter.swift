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
    
    var favoriteModels: [PropertyRowStockModel] { get set }

    func openSearchVC()
    
    func didLoadStocks()
  
    func changeIsFavorite(bool: Bool, ticker: String)
    
    func refreshFavoriteMenu()
    
    func changeMenu(index: Int)
    
    func didTapFavoriteMenuItem()
}


class StocksPresenter: StocksMainPresenterProtocol {
    
    
    weak var view: StocksMainViewProtocol?
    
    private var quote: Quote?
    private var company: Company?
    
    private var currentIndex: Int = 0

    
    private let networkService = NetworkService()
    private var coreDataService = CoreDataService()
    
    var rowModels: [PropertyRowStockModel] = []
    var currentList: [PropertyRowStockModel] = []
    var favoriteModels: [PropertyRowStockModel] = []
    let dispatchGroup = DispatchGroup()
    private var tickers: [String] { return UserDefaults.tickers }
    
    //MARK: OPEN VC SEARCH
    
    func openSearchVC() {
        let vc = SearchScreenConfigurator.config()
        view?.openSearchVC(vc: vc)
    }
    
    //MARK: LOAD TICKERS
    
    func didLoadStocks(){
        
        loadAllTickers()
        
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
                }
            }
            dispatchGroup.leave()

        }

        dispatchGroup.notify(queue: .global()) {
            self.update()
        }
//        self.update()
    }
    



    
    private func update() {
        guard let dataModels = coreDataService.fetchStock() else { return }
        rowModels = dataModels.compactMap ({ model in
            return PropertyRowStockModel(
                tickerName: model.ticker ?? "N/A",
                name: model.name ?? "N/A",
                image: model.logo ?? "N/A",
                deltaPrice: model.d,
                currentPrice: model.c,
                deltaProcent: model.dp,
                isFavourite: model.isFavourite
            ) 
        })
        
        currentList = rowModels
//        print(currentList)
        view?.reloadData()
    }
    
    //MARK: GUARD DATA
    
  

    
    //MARK: FAVOURITE MENU
    
    func refreshFavoriteMenu() {
        dispatchGroup.enter()
        loadAllTickers()
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            self.favoriteModels = []
            self.didTapFavoriteMenuItem()
        }
    }
    
    private func detectingCurrentIndex(index: Int) {
        if index == 0 {
            self.update()
        } else {
            favoriteModels = []
            didTapFavoriteMenuItem()
        }
    }
    
    func didTapFavoriteMenuItem() {
        for model in currentList {
            let ticker = model.tickerName
            if coreDataService.checkToFavorite(from: ticker) {
                favoriteModels.append(model)
            }
        }
        currentList = favoriteModels
        view?.reloadData()
    }
    
    func changeIsFavorite(bool: Bool, ticker: String) {
        coreDataService.changeToFavorite(tickerString: ticker, isFavorite: bool)
        detectingCurrentIndex(index: currentIndex)
    }

    func changeMenu(index: Int) {
        switch index {
        case 0:
            loadAllTickers()
            favoriteModels = []
            currentIndex = index
        case 1:
            loadAllTickers()
            favoriteModels = []
            didTapFavoriteMenuItem()
            currentIndex = index
        default:
            return
        }
    }
}
