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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var table: UITableView!
    
    //  MARK:-  Variables
    
    var locations = [GMSMarker]()
    var filteredLocations = [GMSMarker]()
    var locationTitles = [String]()
    var filteredTitles = [String]()
    
    //  MARK:-  ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.hidden = true // hide table
        configMap()
        loadMarkers(viewMap)
        getTitles()
        //  Delegates
        searchBar.delegate = self
        table.dataSource = self
        table.delegate = self
    }
    
    private func getTitles() {
        for loc in locations {
            locationTitles.append(loc.title)
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
    
    private func configSearchBar() {
        /*
        // Configure LocationSearchController
        self.searchController = ({
            // Setup Two: Alternative - This presents the results in a sepearate tableView
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let alternateController:MapSearchTVC = storyBoard.instantiateViewControllerWithIdentifier("searchTVC") as! MapSearchTVC
            let controller = UISearchController(searchResultsController: alternateController)
            //controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchResultsUpdater = alternateController
            controller.definesPresentationContext = false
            controller.searchBar.sizeToFit()
            searchBar.delegate = self
            //controller.delegate = alternateController
            return controller
        })()*/
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

    //  Load Markers
    func loadMarkers(mapView: GMSMapView) {
        //  SAC
        let SACLoc = GMSMarker()
        SACLoc.position = CLLocationCoordinate2DMake(40.914299, -73.123715)
        SACLoc.title = "SAC"
        SACLoc.snippet = "Stony Brook University"
        SACLoc.map = mapView
        locations.append(SACLoc)
        
        //  Melvile library
        let melville = GMSMarker()
        melville.position = CLLocationCoordinate2DMake(40.915380, -73.122799)
        melville.title = "Melville Library"
        melville.snippet = "Stony Brook Univeristy"
        melville.map = mapView
        locations.append(melville)
        
        //  Light Engineering
        let lightEngr = GMSMarker()
        lightEngr.position = CLLocationCoordinate2DMake(40.913529, -73.125473)
        lightEngr.title = "Light Engineering"
        lightEngr.snippet = "Stony Brook Univeristy"
        lightEngr.map = mapView
        locations.append(lightEngr)
        
        //  Javits Center
        let javits = GMSMarker()
        javits.position = CLLocationCoordinate2DMake(40.912929, -73.122083)
        javits.title = "Javits Lecture Hall"
        javits.snippet = "Stony Brook Univeristy"
        javits.map = mapView
        locations.append(javits)
        
        //  Harriman Hall
        let hariman = GMSMarker()
        hariman.position = CLLocationCoordinate2DMake(40.915648, -73.125347)
        hariman.title = "Harriman Hall"
        hariman.snippet = "Stony Brook Univeristy"
        hariman.map = mapView
        locations.append(hariman)
        
        //  Frey Hall
        let frey = GMSMarker()
        frey.position = CLLocationCoordinate2DMake(40.915652, -73.123913)
        frey.title = "Frey Hall"
        frey.snippet = "Stony Brook Univeristy"
        frey.map = mapView
        locations.append(frey)
        
        //  Chemistry
        let chem = GMSMarker()
        chem.position = CLLocationCoordinate2DMake(40.916329, -73.123752)
        chem.title = "Chemistry Building"
        chem.snippet = "Stony Brook Univeristy"
        chem.map = mapView
        locations.append(chem)
        
        //  Psychology
        let psych = GMSMarker()
        psych.position = CLLocationCoordinate2DMake(40.914383, -73.122473)
        psych.title = "Psychology A"
        psych.snippet = "Stony Brook Univeristy"
        psych.map = mapView
        locations.append(psych)
        
        //  New Computer Science
        let newCompSci = GMSMarker()
        newCompSci.position = CLLocationCoordinate2DMake(40.912905, -73.123629)
        newCompSci.title = "New Computer Science"
        newCompSci.snippet = "Stony Brook Univeristy"
        newCompSci.map = mapView
        locations.append(newCompSci)
        
        // Old Computer Science
        let oldCompSci = GMSMarker()
        oldCompSci.position = CLLocationCoordinate2DMake(40.912510, -73.122879)
        oldCompSci.title = "Old Computer Science"
        oldCompSci.snippet = "Stony Brook Univeristy"
        oldCompSci.map = mapView
        locations.append(oldCompSci)
        
        //  Humanities
        let humanities = GMSMarker()
        humanities.position = CLLocationCoordinate2DMake(40.913922, -73.121040)
        humanities.title = "Humanities"
        humanities.snippet = "Stony Brook Univeristy"
        humanities.map = mapView
        locations.append(humanities)
    }
}