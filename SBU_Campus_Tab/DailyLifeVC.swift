//  Daily Life
//
//  FirstViewController.swift
//  SBU_Campus_Tab
//
//  Created by Rashedul on 11/9/15.
//  Copyright © 2015 Rashedul. All rights reserved.
//

import UIKit
import GoogleMaps

class DailyLifeVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    //  MARK:-  Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bottomTableHeight: NSLayoutConstraint!
    

    //  MARK:-  Variables
    // Location data
    var locations = [CustomGMSMarker]() //original
    var selectedLocations = [CustomGMSMarker]() // filtered
    var categories = [String]() // corresponding categories(not assigned='Default')
    var categorySet: Set<String> = []
    var selectedCategorySet: Set<String> = []
    
    //  Searching Date
    var filteredLocations = [CustomGMSMarker]()
    var locationTitles = [String]()
    var filteredTitles = [String]()
    
    //  MARK:-  ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.hidden = true // hide table
        configMap()
        loadMarkers(viewMap)
        getTitles()
        getCategories()
        
        //  Delegates
        searchBar.delegate = self
        table.dataSource = self
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func getTitles() {
        for loc in locations {
            locationTitles.append(loc.title)
        }
    }
    
    private func getCategories() {
        for loc in locations {
            categories.append(loc.category)
            categorySet.insert(loc.category)
            selectedCategorySet.insert(loc.category)
        }
    }
    
    private func configMap() {
        let camera = GMSCameraPosition.cameraWithLatitude(40.914468,
            longitude: -73.123646, zoom: 17)
        viewMap.camera = camera
        viewMap.myLocationEnabled = true
        viewMap.settings.myLocationButton = true
        viewMap.padding = UIEdgeInsetsMake(0, 0, bottomLayoutGuide.length + 60, 0)
    }

    //  MARK: - Search
    
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text changes (including clear)
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTitles = locationTitles.filter { title in
            return title.lowercaseString.containsString(searchText.lowercaseString)
        }
        table.reloadData()
    }
    
    internal func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // called when text starts editing
        print("Begin editing")
        searchBar.showsCancelButton = true
        table.updateConstraints()
        table.hidden = false
    }
    
    internal func searchBarSearchButtonClicked(searchBar: UISearchBar){
        // called when keyboard search button pressed
        searchBar.showsCancelButton = true
        print("Pressed Enter!!!\n")
    }
    
    internal func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // called when cancel button pressed
        viewMap.clear()
        for loc in locations {
            loc.map = viewMap
        }
        configMap() // reset camera
        table.hidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Here")
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                bottomTableHeight.constant = keyboardSize.height
                //view.setNeedsLayout()   // Autolayout update value
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        //bottomTableHeight.constant = 44.0
        //bottomTableHeight.constant = 559
        //view.setNeedsLayout()
    }
    
    //  MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //  Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text == "" { print("locations \(locationTitles.count)")
            return locationTitles.count
        } else { print("filtered locations \(filteredTitles.count)")
            return filteredTitles.count
        }
    }
    //  Labels for cell.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MyCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath)
        if searchBar.text == "" {
            cell.textLabel?.text = locationTitles[indexPath.row]
        } else {
            cell.textLabel?.text = filteredTitles[indexPath.row]
        }
        
        return cell
    }
    //  Selected cell.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        let loc = locations[indexPath.row]
        viewMap.clear()
        loc.map = viewMap
        let camera = GMSCameraPosition.cameraWithLatitude(loc.position.latitude,
            longitude: loc.position.longitude, zoom: 18)
        viewMap.camera = camera

        table.hidden = true

    }
    
    //  MARK: - Navigation
    
    //  Pass Unique Categories to CatagoryTableVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print (segue.identifier!)
        if (segue.identifier! == "categorySegue") {
            print(segue.destinationViewController)
            if let nav = segue.destinationViewController as? UINavigationController {
                if let destination = nav.topViewController as? CatagoryTableVC {
                destination.selectedPath = selectedCategorySet
                for cat in categorySet.sort(){
                    destination.catagories.append(cat)
                    }
                }
            }
        }
    }
    

    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        print("unwindToMapView")
        if let sourceViewController = sender.sourceViewController as? CatagoryTableVC {
            selectedCategorySet = sourceViewController.selectedPath
        }
        
        //  Clear map and add new elements
        viewMap.clear()
        for loc in locations {
            if selectedCategorySet.contains(loc.category) {
                loc.map = viewMap
            }
        }
    }

    //  Load Markers
    private func loadMarkers(mapView: GMSMapView) {
        //  SAC
        let SACLoc = CustomGMSMarker()
        SACLoc.position = CLLocationCoordinate2DMake(40.914299, -73.123715)
        SACLoc.title = "SAC"
        SACLoc.snippet = "Stony Brook University"
        SACLoc.category = "Cafeteria"
        SACLoc.map = mapView
        locations.append(SACLoc)
        
        //  Melvile library
        let melville = CustomGMSMarker()
        melville.position = CLLocationCoordinate2DMake(40.915380, -73.122799)
        melville.title = "Melville Library"
        melville.snippet = "Stony Brook Univeristy"
        melville.category = "Library"
        melville.map = mapView
        locations.append(melville)
        
        //  Light Engineering
        let lightEngr = CustomGMSMarker()
        lightEngr.position = CLLocationCoordinate2DMake(40.913529, -73.125473)
        lightEngr.title = "Light Engineering"
        lightEngr.snippet = "Stony Brook Univeristy"
        lightEngr.category = "Lecture"
        lightEngr.map = mapView
        locations.append(lightEngr)
        
        //  Javits Center
        let javits = CustomGMSMarker()
        javits.position = CLLocationCoordinate2DMake(40.912929, -73.122083)
        javits.title = "Javits Lecture Hall"
        javits.snippet = "Stony Brook Univeristy"
        javits.category = "Lecture"
        javits.map = mapView
        locations.append(javits)
        
        //  Harriman Hall
        let hariman = CustomGMSMarker()
        hariman.position = CLLocationCoordinate2DMake(40.915648, -73.125347)
        hariman.title = "Harriman Hall"
        hariman.snippet = "Stony Brook Univeristy"
        hariman.category = "Lecture"
        hariman.map = mapView
        locations.append(hariman)
        
        //  Frey Hall
        let frey = CustomGMSMarker()
        frey.position = CLLocationCoordinate2DMake(40.915652, -73.123913)
        frey.title = "Frey Hall"
        frey.snippet = "Stony Brook Univeristy"
        frey.map = mapView
        locations.append(frey)
        
        //  Chemistry
        let chem = CustomGMSMarker()
        chem.position = CLLocationCoordinate2DMake(40.916329, -73.123752)
        chem.title = "Chemistry Building"
        chem.snippet = "Stony Brook Univeristy"
        chem.map = mapView
        locations.append(chem)
        
        //  Psychology
        let psych = CustomGMSMarker()
        psych.position = CLLocationCoordinate2DMake(40.914383, -73.122473)
        psych.title = "Psychology A"
        psych.snippet = "Stony Brook Univeristy"
        psych.map = mapView
        locations.append(psych)
        
        //  New Computer Science
        let newCompSci = CustomGMSMarker()
        newCompSci.position = CLLocationCoordinate2DMake(40.912905, -73.123629)
        newCompSci.title = "New Computer Science"
        newCompSci.snippet = "Stony Brook Univeristy"
        newCompSci.map = mapView
        locations.append(newCompSci)
        
        // Old Computer Science
        let oldCompSci = CustomGMSMarker()
        oldCompSci.position = CLLocationCoordinate2DMake(40.912510, -73.122879)
        oldCompSci.title = "Old Computer Science"
        oldCompSci.snippet = "Stony Brook Univeristy"
        oldCompSci.map = mapView
        locations.append(oldCompSci)
        
        //  Humanities
        let humanities = CustomGMSMarker()
        humanities.position = CLLocationCoordinate2DMake(40.913922, -73.121040)
        humanities.title = "Humanities"
        humanities.snippet = "Stony Brook Univeristy"
        humanities.map = mapView
        locations.append(humanities)
    }
}


