//
//  Stock.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 21.09.23.
//

import Foundation
struct Stock: Codable {
    var companyProfile: Company
    var quote: Quote
}
