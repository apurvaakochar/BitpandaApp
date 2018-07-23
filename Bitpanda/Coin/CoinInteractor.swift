//
//  CoinInteractor.swift
//  Bitpanda
//
//  Created by Apurva Kochar on 7/20/18.
//  Copyright © 2018 Bitpanda. All rights reserved.
//

import UIKit

protocol CoinBusinessLogic {
    var isLoading: Bool {get}
    var reloadTableViewClosure: (()->())? {get set}
    var updateIndicatorViewClosure: (()->())? {get set}
    func getData()
}

protocol CoinCellLogic {
    var numberOfRows: Int? {get}
    func getCellVM(at index: IndexPath) -> Coin
}

protocol CoinSearchLogic {
    var searchController: UISearchController? {get set}
    var isFiltering: Bool {get set}
    func filterCoins(by searchText: String)
}

class CoinInteractor: CoinBusinessLogic, CoinCellLogic, CoinSearchLogic {

    var cellVM = [Coin]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    private var filteredCellVM = [Coin]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    // MARK: CoinCellLogic
    func getCellVM(at index: IndexPath) -> Coin {
        if(isFiltering){
            return filteredCellVM[index.row]
        }
        else{
            return cellVM[index.row]
        }
    }
    
    var numberOfRows: Int? {
        if(isFiltering){
            return filteredCellVM.count
        }
        else{
            return cellVM.count
        }
    }
    
    // MARK: CoinBusinessLogic
    
    var reloadTableViewClosure: (()->())?
    var updateIndicatorViewClosure: (()->())?
    var updateAlertViewClosure: (()->())?
    
    var isLoading = false {
        didSet{
            self.updateIndicatorViewClosure?()
        }
    }
    
    func getData() {
        isLoading = true
        ServerRequest().getRequest("?convert=EUR"){
            (result, error) in
            if(error == ""){
                if let data = result["data"] as? [String : [String:Any]] {
                    var coin = [Coin]()
                    for (_, value) in data {
                        let name = value["name"] as! String
                        let symbol = value["symbol"] as! String
                        let quotes = value["quotes"] as! [String : [String:Double]]
                        let eur = quotes["EUR"]!
                        let price = eur["price"]
                        let oneDayChange = eur["percent_change_24h"]
                        let oneWeekChange = eur["percent_change_7d"]
                        let lastUpdated = value["last_updated"] as! Double
                        coin.append(self.getFormattedValues(name: name, symbol: symbol, price: price, oneDayChange: oneDayChange, oneWeekChange: oneWeekChange, lastUpdated: lastUpdated))
                }
                    self.isLoading = false
                    self.cellVM = coin
            }
        }
            else{
                self.isLoading = false
                self.updateAlertViewClosure?()
            }
    }
}
    // MARK: CoinSearchLogic
    
    var searchController: UISearchController?
    var isFiltering = false
    
    func filterCoins(by searchText: String){
        filteredCellVM = cellVM.filter{
            $0.name!.lowercased().contains(searchText.lowercased()) ||
                $0.symbol!.lowercased().contains(searchText.lowercased())
        }
        
    }
}

extension CoinInteractor {
    // MARK: Get Formatted Data
    
    private func getFormattedValues(name: String, symbol: String, price: Double?, oneDayChange: Double?,
                                    oneWeekChange: Double?, lastUpdated: Double?) -> Coin{
        let dayChange = getFormattedDayChange(oneDayChange: oneDayChange!)
        let weekChange = getFormattedWeekChange(oneWeekChange: oneWeekChange!)
        let price = String(format: "%0.2f",price!)
        let lastUpdated = String(format: "Last updated: %@", getDate(from: lastUpdated!))
        return(Coin(name: name, symbol: symbol, price: price, oneDayChange: dayChange, oneWeekChange: weekChange, lastUpdated: lastUpdated))
    }
    
    private func getFormattedDayChange(oneDayChange: Double) -> String{
        if(oneDayChange < 0){
            return String(format: "Last 24 hours: %0.2f ⬇️", oneDayChange * (-1))
        }
        else{
            return String(format: "Last 24 hours: %0.2f ⬆️", oneDayChange)
        }
    }
    
    private func getFormattedWeekChange(oneWeekChange: Double) -> String{
        if(oneWeekChange < 0){
            return String(format: "Last 7 days: %0.2f ⬇️", oneWeekChange * (-1))
        }
        else{
            return String(format: "Last 7 days: %0.2f ⬆️", oneWeekChange)
        }
        
    }
    
    private func getDate(from timeInterval: Double) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY, HH:mm"
        let date = Date(timeIntervalSince1970: timeInterval)
        return formatter.string(from: date)
    }
}
