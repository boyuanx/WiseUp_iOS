//
//  StocksViewController.swift
//  QuickFin
//
//  Created by Tianjian Xu on 1/31/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit


protocol StocksViewDelegate: class {
    func fetchData()
}

class StocksViewController: StoreViewController, ItemsViewDelegate {

    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stocks".localized()
        
        segmentedControl.isHidden = true
        
        tableView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.top.equalTo(view.snp.topMargin).offset(5)
            this.bottom.equalTo(view.snp.bottomMargin)
            this.trailing.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let innerVC = StoreItemDetailsViewController()
        innerVC.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.fetchData()
    }
    
    func didConsume() {
        fetchData()
    }
    
    override func fetchData() {
        stockItems.removeAll()
        FirebaseService.shared.getStock { (stocks, error) in
            for stock in stocks! {
                var sItem = StoreItem()
                sItem.name = stock.name
                sItem.details = "Current Price: \(stock.currentPrice) \t Buy In Price:  \(stock.buyInPrice) \n \(stock.details)"
                sItem.imageName = stock.imageName
                sItem.cost = stock.numOfShare
                sItem.type = "stock"
                self.stockItems.append(sItem)
            }
            
            self.storeItems = self.stockItems
            self.tableView.reloadData()
        }

        /*
        // First Get Pre-Cached Chapters (or empty if nothing cached)
        storeItems = CacheService.shared.getCachedStore()
        
        consumableItems = []
        
        for sItem in storeItems {
            if sItem.type == "consumable" {
                if UserShared.shared.itemsOwned.contains(sItem.name) {
                    consumableItems.append(sItem)
                }
            }
        }
        
        storeItems = consumableItems
        self.tableView.reloadData()
        
        // Second, asynchronously check for updates to chapters and download them if needed
        CacheService.shared.getStore { [unowned self] (store) in
            self.storeItems = store
            
            self.consumableItems = []
            
            for sItem in self.storeItems {
                if sItem.type == "consumable" {
                    if UserShared.shared.itemsOwned.contains(sItem.name) {
                        self.consumableItems.append(sItem)
                    }
                }
            }
            
            self.storeItems = self.consumableItems
            
            self.tableView.reloadData()
        }
        */
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = StoreItemDetailsViewController()
        detailsVC.item = storeItems[indexPath.row]
        detailsVC.showSell = true
        detailsVC.itemsViewDelegate = self
        detailsVC.delegate = self
        present(detailsVC, animated: true) {}
    }
    
    

}

