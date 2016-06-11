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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var timer = NSTimer()
    var refreshControl = UIRefreshControl()
    
    let globalHelper = GlobalHelper()
    let modelHelper = ModelHelper()
    var stock = CurrentlyInStock()
    let managedContext = CoreDataStack().context
    
    var updatingInfinityScroll = false
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Warehouses")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        if (endScrolling >= scrollView.contentSize.height && updatingInfinityScroll == false) {
            
            updatingInfinityScroll = true
            
            if self.collectionView.frame.origin.y > 0 {
            
                self.modelHelper.skip = self.modelHelper.skip + 6
            
                self.modelHelper.refresh_models(self.stock, txtSearch: self.txtSearch.text!){ (finished) in
                    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        if self.collectionView.frame.origin.y < 0 {
                            self.collectionView.frame.origin.y = self.collectionView.frame.origin.y + 40
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.refresh()
                            self.updatingInfinityScroll = false
                        })
                    }, completion: nil)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelHelper.resetModel("Warehouses") { (response) in
            self.refreshGrid()
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: #selector(self.refreshGrid), forControlEvents: UIControlEvents.ValueChanged)
            self.collectionView.addSubview(self.refreshControl)
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: globalHelper.screenWidth/2, height: self.collectionView.frame.height/3)
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
        
        if (record.stock == 1) {
            cell.labelOneMoreInStock.hidden = false
        }
    
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (globalHelper.screenWidth-2)/3, height: self.collectionView.frame.height/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return globalHelper.sectionInsets
    }
    
    func refreshGrid(){
        
        if !(loading.isAnimating() || self.refreshControl.refreshing) {
            self.loading.startAnimating()
            self.collectionView.hidden = true
            self.modelHelper.skip = 0
        } else {
            modelHelper.resetModel("Warehouses") { (response) in }
        }
        
        self.modelHelper.refresh_models(self.stock, txtSearch: self.txtSearch.text!) { (response) in
            dispatch_async(dispatch_get_main_queue(), {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(3600, target: self, selector: #selector(self.resetData), userInfo: nil, repeats: false)
                
                self.refresh()
                self.loading.stopAnimating()
                self.collectionView.hidden = false
                
                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
                    
            })
        }
        
    }
    
    func refresh(){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        self.collectionView.reloadData()
    }
    
    func resetData(){
        modelHelper.resetModel("Warehouses") { (response) in
            self.modelHelper.resetModel("Tags") { (response) in
                self.txtSearch.text = nil
                self.stock.type = .SHOW
                self.timer.invalidate()
            }
        }
    }
    
    @IBAction func btnCurrentlyInStock(sender: AnyObject){
        
        if (stock.type == .SHOW){
            stock.type = .HIDE
            labelInStock.text = "Show items currently in-stock"
        } else {
            stock.type = .SHOW
            labelInStock.text = "Show items"
        }
        
        modelHelper.resetModel("Warehouses") { (response) in
            self.refreshGrid()
        }
        
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        modelHelper.resetModel("Warehouses") { (response) in
            self.refreshGrid()
        }
    }
    
}