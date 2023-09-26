//
//  DataStructure.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//

import Foundation




struct Company: Codable {
    let country: String
    let currency: String
    let exchange: String
    let ipo: String
    let logo: String
    let estimateCurrency: String
    let finnhubIndustry: String
    let marketCapitalization: Double
    let name: String
    let phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
}
