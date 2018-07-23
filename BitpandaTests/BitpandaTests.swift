//
//  BitpandaTests.swift
//  BitpandaTests
//
//  Created by Apurva Kochar on 7/20/18.
//  Copyright © 2018 Bitpanda. All rights reserved.
//

import XCTest
@testable import Bitpanda

class BitpandaTests: XCTestCase {
    var coinInteractor: CoinInteractor!
    var coinViewController: CoinViewController!
    
    override func setUp() {
        super.setUp()
        coinInteractor = CoinInteractor()
        coinViewController = CoinViewController()
    }
    
    override func tearDown() {
        coinInteractor = nil
        coinViewController = nil
        super.tearDown()
    }
    
    func testClosure() {
        coinViewController.interactor.isLoading = true
        coinViewController.interactor.cellVM.append(Coin(name: "Bitcoin", symbol: "BTC", price: "", oneDayChange: "", oneWeekChange: "", lastUpdated: ""))
        XCTAssertEqual(coinViewController.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
