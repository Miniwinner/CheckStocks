//
//  CoreDataService.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 21.09.23.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    func fetchOneElement(name: String) -> StockCoreDataModel? {
        // Создаем запрос в базу данных, который возвращает все элементы
        let request: NSFetchRequest<StockCoreDataModel> = StockCoreDataModel.fetchRequest()
        // Добавляем параметр для запроса, чтобы получить определенный элемент
        request.predicate = NSPredicate(format: "ticker == %@", name)
        
        do {
            let model = try context.fetch(request)
            
            guard !model.isEmpty else {
                return nil
            }
            return model[0]
        } catch {
            print(error.localizedDescription)
            return nil
        }
        }
    
    func update(with stock: Stock) {
        let request: NSFetchRequest<StockCoreDataModel> = StockCoreDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "ticker == %@", stock.companyProfile.ticker)
        
        do {
            let models = try context.fetch(request)
            
            if let existingModel = models.first {
                // Если модель существует, обновите ее свойства
                //MARK: -  ПРОВЕРКИ!!!//
                existingModel.ticker = stock.companyProfile.ticker
                existingModel.name = stock.companyProfile.name
                existingModel.logo = stock.companyProfile.logo
                existingModel.c = stock.quote.c
                existingModel.d = stock.quote.d
                existingModel.dp = stock.quote.dp
                existingModel.country = stock.companyProfile.country
                existingModel.currency = stock.companyProfile.currency
                existingModel.exchange = stock.companyProfile.exchange
                existingModel.ipo = stock.companyProfile.ipo
                existingModel.marketCapitalization = stock.companyProfile.marketCapitalization
                existingModel.phone = stock.companyProfile.phone
                existingModel.typeOfServices = stock.companyProfile.finnhubIndustry
                existingModel.webUrl = stock.companyProfile.weburl
                existingModel.shareOutstanding = stock.companyProfile.shareOutstanding

                try context.save()
                print("\(stock.companyProfile.ticker) update ✅✅✅")
            } else {
                // Если модель не существует, добавьте новую
                addStock(stock: stock)
            }
        } catch {
            print("Error updating stock: \(error.localizedDescription)")
        }
    }

    
    func fetchStock() -> [StockCoreDataModel]? {
        let fetchRequest: NSFetchRequest<StockCoreDataModel> = StockCoreDataModel.fetchRequest()
        
        do {
            let models = try context.fetch(fetchRequest)
            return models
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addStock(stock: Stock) {
        let entity = NSEntityDescription.entity(forEntityName: "StockCoreDataModel", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! StockCoreDataModel
        
        taskObject.name = stock.companyProfile.name
        taskObject.ticker = stock.companyProfile.ticker
        taskObject.logo = stock.companyProfile.logo
        taskObject.c = stock.quote.c
        taskObject.d = stock.quote.d
        taskObject.dp = stock.quote.dp
        taskObject.country = stock.companyProfile.country
        taskObject.currency = stock.companyProfile.currency
        taskObject.exchange = stock.companyProfile.exchange
        taskObject.ipo = stock.companyProfile.ipo
        taskObject.marketCapitalization = stock.companyProfile.marketCapitalization
        taskObject.phone = stock.companyProfile.phone
        taskObject.typeOfServices = stock.companyProfile.finnhubIndustry
        taskObject.webUrl = stock.companyProfile.weburl
        
        do {
            try context.save()
            print("\(stock.companyProfile.ticker) add ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteStock(_ ticker: String) {
           let fetchRequest: NSFetchRequest<StockCoreDataModel> = StockCoreDataModel.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "ticker == %@", ticker)
           
           do {
               let result = try context.fetch(fetchRequest)
               guard !result.isEmpty else { return }
               guard let tickerModel = result.first else { return}
               tickerModel.isFavourite = false
               context.delete(result[0])
               try context.save()
           } catch {
               print(error.localizedDescription)
           }
       }
    
    func changeToFavorite(tickerString: String, isFavorite: Bool) {
        
        let fetchRequest: NSFetchRequest<StockCoreDataModel> = StockCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ticker == %@",  tickerString)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let tickerModel = result.first else { return}
            tickerModel.isFavourite = isFavorite
            if tickerModel.isFavourite == false {
                deleteStock(tickerModel.ticker!)
            }
            try context.save()
            print(isFavorite ? "\(tickerString) save ✅✅✅" : "\(tickerString) delete ❌❌❌")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkToFavorite(from ticker: String) -> Bool {
        
        let fetchRequest: NSFetchRequest<StockCoreDataModel> = StockCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ticker == %@",  ticker)
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                return result.isFavourite
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
