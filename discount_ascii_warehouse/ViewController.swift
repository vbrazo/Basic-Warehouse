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

public struct CurrentlyInStock {
    enum Type: Int {
        case SHOW = 0, HIDE
    }
    var type: Type = .SHOW
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var labelInStock: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var skip = 0
    
    var timer = NSTimer()
    var refreshControlBottom = UIRefreshControl()
    
    var stock = CurrentlyInStock()
    let globalHelper = GlobalHelper()
    
    let globalService = GlobalService(context: CoreDataStack().privateContext, coreDataStack: CoreDataStack())
    
    let warehouseService = WarehouseService(context: CoreDataStack().privateContext, coreDataStack: CoreDataStack())
    
    var updatingInfinityScroll = false
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
       
        let managedContext = CoreDataStack().mainContext
        let fetchRequest = NSFetchRequest(entityName: "Warehouses")
        let sortDescriptor = NSSortDescriptor(key: "uid", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.globalService.reset("Warehouses") { (response) in
            self.refreshData()
        }
        
        self.txtSearch.delegate = self
        
        self.refreshControlBottom.attributedTitle = NSAttributedString(string: "Refreshing")
            
        self.refreshControlBottom.triggerVerticalOffset = 100
        self.collectionView.bottomRefreshControl = self.refreshControlBottom
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.globalHelper.screenWidth/2, height: self.collectionView.frame.height/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        
        self.collectionView.collectionViewLayout = layout
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Grid", forIndexPath: indexPath) as! CollectionsGrid
        
        let record = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Warehouse
        
        cell.lblFace.text = record.face
        cell.lblPrice.text = record.price.description
        
        if (record.stock == 1) {
            cell.labelOneMoreInStock.hidden = false
        }
        
        cell.lblFace.accessibilityLabel = "lblFace\(indexPath.row)"
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.globalHelper.screenWidth-2)/3, height: self.collectionView.frame.height/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return self.globalHelper.sectionInsets
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.startRequest()
        return false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        if (endScrolling >= scrollView.contentSize.height+15 && self.updatingInfinityScroll == false) {
            
            self.updatingInfinityScroll = true
            
            if self.collectionView.frame.origin.y > 0 {
                
                self.skip = self.skip + 6
                
                self.warehouseService.refresh(self.stock, txtSearch: self.txtSearch.text!, skip: self.skip){ (finished) in
                    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        
                        if self.collectionView.frame.origin.y < 0 {
                            self.collectionView.frame.origin.y = self.collectionView.frame.origin.y + 40
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.refreshFetchedResults()
                            self.updatingInfinityScroll = false
                            if self.refreshControlBottom.refreshing {
                                self.refreshControlBottom.endRefreshing()
                            }
                        })
                        
                    }, completion: nil)
                }
                
            }
        }
        
    }
    
    func refreshData(){
        
        self.warehouseService.refresh(self.stock, txtSearch: self.txtSearch.text!, skip: self.skip) { (response) in
            
            if response == true {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(3600, target: self, selector: #selector(self.resetData), userInfo: nil, repeats: false)
                    
                    self.refreshFetchedResults()
                    
                    if self.collectionView.hidden == true {
                        self.collectionView.hidden = false
                    }
                    
                    if self.loading.isAnimating() {
                        self.loading.stopAnimating()
                    }
                    
                })
            }
            
        }
        
    }
    
    func resetData(){
        self.globalService.reset("Warehouses") { (response) in
            self.globalService.reset("Tags") { (response) in
                self.txtSearch.text = nil
                self.stock.type = .SHOW
                self.timer.invalidate()
            }
        }
    }
    
    func refreshFetchedResults(){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        self.collectionView.reloadData()
    }
    
    func startRequest(){
        self.view.endEditing(true)
        self.loading.startAnimating()
        self.collectionView.hidden = true
        self.skip = 0
        self.globalService.reset("Warehouses") { (response) in
            self.refreshData()
        }
    }
    
    @IBAction func btnCurrentlyInStock(sender: AnyObject){
        
        if (self.stock.type == .SHOW){
            self.stock.type = .HIDE
            self.labelInStock.text = "Show items currently in-stock"
        } else {
            self.stock.type = .SHOW
            self.labelInStock.text = "Show items"
        }
        
        self.startRequest()
                
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        self.startRequest()
    }

}