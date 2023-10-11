//
//  UserDefaultsExtension.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 19.09.23.
//

import Foundation



@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue

        if UserDefaults.standard.object(forKey: key) == nil {
            wrappedValue = defaultValue
        }
    }

    var wrappedValue: T {
        get {
            if let val = UserDefaults.standard.object(forKey: key) as? T {
                return val
            } else {
                UserDefaults.standard.set(defaultValue, forKey: key)
                return defaultValue
            }
        }

        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @Persist(key: "defaultStock", defaultValue: ["AAPL","MSFT","AMZN","FB","JPM","JNJ","GOOGL","NFLX","ORCL","TSLA","INTC","T","V","CSCO","CVX","UNH","PFE","HD","PG","VZ","C","NVDA"])

    
    static var tickers: [String]
    
    @Persist(key: "searchedStock", defaultValue: [])
    static var searchedTickers: [String]
}
