//
//  NetworkData.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//

import Foundation

let apiKey = "ck42eopr01qhukcdu5cgck42eopr01qhukcdu5d0"
//https://finnhub.io/api/v1/stock/profile2?symbol=AAPL&token=ck42eopr01qhukcdu5cgck42eopr01qhukcdu5d0
let popa = "AMZN"

class NetworkService {
    var timeframe = "D"
    
        func fetchStock(for ticker: String, complitions: @escaping (Stock) -> Void) {
            guard let urlCompany = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(ticker)&token=\(apiKey)") else { return }
            guard let urlQuote = URL(string:"https://finnhub.io/api/v1/quote?symbol=\(ticker)&token=\(apiKey)") else { return }
    
            let requestCompany = URLRequest(url: urlCompany)
            let requestQuote = URLRequest(url: urlQuote)
    
            URLSession.shared.dataTask(with: requestCompany) { data, respone, error in
                guard let data = data else {
                    if let error = error{
                        print(error.localizedDescription)
                        
                    }
                    return
                }
                guard let company = self.parseJson(type: Company.self, data: data) else { return }
    
                DispatchQueue.main.async {
                    URLSession.shared.dataTask(with: requestQuote) { data, response, error in
                        guard let data = data else {
                            if let error = error{
                                print(error.localizedDescription)
                                
                            }
                            return
                        }
                        guard let quote = self.parseJson(type: Quote.self, data: data) else { return }
    
                        let stock = Stock(companyProfile: company, quote: quote)
                        complitions(stock)
                    }.resume()
                }
            }.resume()
        }
    
    func fetchCompany(for ticker: String, complitions: @escaping (Company) -> Void) {
        guard let urlCompany = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(ticker)&token=\(apiKey)") else { return }
        
        let requestCompany = URLRequest(url: urlCompany)
        
        URLSession.shared.dataTask(with: requestCompany) { data, respone, error in
            guard let data = data else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let company = self.parseJson(type: Company.self, data: data) else { return }
            complitions(company)
        }.resume()
    }
    
    func fetchQuote(for ticker: String, complitions: @escaping (Quote) -> Void) {
        guard let urlQuote = URL(string: "https://finnhub.io/api/v1/quote?symbol=\(ticker)&token=\(apiKey)") else { return }
        
        let requestQuote = URLRequest(url: urlQuote)
        
        URLSession.shared.dataTask(with: requestQuote) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let quote = self.parseJson(type: Quote.self, data: data) else { return }
            complitions(quote)
        }.resume()
    }
    

    func parseJson<T: Codable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(T.self, from: data)
        return model
    }

}
