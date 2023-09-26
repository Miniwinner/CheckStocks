//
//  StockCoreDataModel+CoreDataProperties.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 22.09.23.
//
//

import Foundation
import CoreData


extension StockCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockCoreDataModel> {
        return NSFetchRequest<StockCoreDataModel>(entityName: "StockCoreDataModel")
    }

    @NSManaged public var logo: String?
    @NSManaged public var name: String?
    @NSManaged public var ticker: String?
    @NSManaged public var webUrl: String?
    @NSManaged public var marketCapitalization: Double
    @NSManaged public var country: String?
    @NSManaged public var currency: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var shareOutstanding: Double
    @NSManaged public var exchange: String?
    @NSManaged public var ipo: String?
    @NSManaged public var d: Double
    @NSManaged public var c: Double
    @NSManaged public var dp: Double
    @NSManaged public var phone: String?
    @NSManaged public var typeOfServices: String?
}

extension StockCoreDataModel : Identifiable {

}
