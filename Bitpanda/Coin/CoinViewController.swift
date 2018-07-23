//
//  HomeViewController.swift
//  Bitpanda
//
//  Created by Apurva Kochar on 7/20/18.
//  Copyright © 2018 Bitpanda. All rights reserved.
//

import UIKit

class CoinViewController: UITableViewController {

    /*
     CellIdentifier
     */
    let reuseIdentifier  = "CoinCell"
    /*
     ViewModel
     */
    lazy var interactor = CoinInteractor()
    /*
     Search Controller
     */
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = "Bitpanda"
        initSearch()
        initInteractor()
    }
    
    // MARK: Initialization
    
    private func initSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search with name or symbol"
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.black
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func initInteractor() {
        interactor.reloadTableViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        interactor.updateIndicatorViewClosure = {[weak self] in
            DispatchQueue.main.async {
                if(self?.interactor.isLoading == true){
                    self?.tableView.activityIndicatorView.startAnimating()
                }
                else{
                    self?.tableView.activityIndicatorView.stopAnimating()
                }
            }
        }
        interactor.updateAlertViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.showDetails(title: "Bitpanda", message: "Data could not be fetched. Please try again later.")
            }
        }
        interactor.getData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRows!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CoinCell
        let cellVM = interactor.getCellVM(at: indexPath)
        cell.name.text = cellVM.name
        cell.symbol.text = cellVM.symbol
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = interactor.getCellVM(at: indexPath)
        let message = String(format: "1 %@ = %@€\n\n%@\n\n%@\n\n%@", cellVM.symbol!, cellVM.price!, cellVM.oneDayChange!, cellVM.oneWeekChange!, cellVM.lastUpdated!)
        showDetails(title: cellVM.name!, message: message)
    }

    // MARK: @IBActions
    @IBAction func refresh(_ sender: Any) {
        interactor.getData()
    }
    
    // MARK: Search Contoller
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension CoinViewController {
    private func showDetails(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CoinViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        interactor.isFiltering = isFiltering()
        interactor.filterCoins(by: searchController.searchBar.text!)
    }
}
