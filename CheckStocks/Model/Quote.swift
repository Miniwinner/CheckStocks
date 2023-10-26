//
//  Quote.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 22.09.23.
//

import Foundation
struct Quote: Codable {
    var c: Double // current price
    var d: Double // change
    var dp: Double // percent change
    var l: Double
    var o: Double
    var pc: Double
    var t: Double
}
