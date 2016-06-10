//
//  ViewController.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/1/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

struct CurrentlyInStock {
    enum Type : Int {
        case SHOW = 0, HIDE
    }
    var type : Type = .SHOW
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var labelInStock: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var timer = NSTimer()
    var refreshControl = UIRefreshControl()
    
    let global = Global()
    var stock = CurrentlyInStock()
    let managedContext = CoreDataStack().context
    
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Warehouses")
        let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshGrid()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: #selector(self.refreshGrid), forControlEvents: UIControlEvents.ValueChanged)
            self.collectionView.addSubview(self.refreshControl)
        })
        
    }
    
    func resetData(){
        global.resetModel("Warehouses") { (response) in
            self.global.resetModel("Tags") { (response) in
                self.txtSearch.text = nil
                self.stock.type = .SHOW
                self.timer.invalidate()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: global.screenWidth/2, height: global.screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
    
        self.collectionView.collectionViewLayout = layout
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Grid", forIndexPath: indexPath) as! CollectionsGrid
        
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Warehouse
        
        cell.lblFace.text = record.face
        cell.lblPrice.text = record.price.description
    
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (global.screenWidth-2)/3, height: (global.screenWidth-2)/3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return global.sectionInsets
    }
    
    func refreshGrid(){
        global.refresh_models(stock, txtSearch: txtSearch.text!) { (response) in
            dispatch_async(dispatch_get_main_queue(), {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(3600, target: self, selector: #selector(self.resetData), userInfo: nil, repeats: false)
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("\(fetchError), \(fetchError.userInfo)")
                }
                self.collectionView.reloadData()
                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    @IBAction func btnCurrentlyInStock(sender: AnyObject){
        
        if (stock.type == .SHOW){
            stock.type = .HIDE
            labelInStock.text = "Show items currently in-stock"
        } else {
            stock.type = .SHOW
            labelInStock.text = "Only Show items currently in-stock"
        }
        
        refreshGrid()
        
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        refreshGrid()
    }
    
}