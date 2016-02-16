//
//  MapSearchTVC.swift
//  SBU_Campus_Tab
//
//  Created by Rashedul on 2/8/16.
//  Copyright © 2016 Rashedul. All rights reserved.
//

import UIKit
import GoogleMaps

class MapSearchTVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchDisplayDelegate, UISearchControllerDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var locations = [GMSMarker]()
    var locationTitles = [String]()
    var filteredTitles = [String]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMarkers()
        //configSearchBar()
        getTitles()
    }
    
    private func configSearchBar() {
        //  Search
        //searchController.searchResultsUpdater = MapSearchTVC
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Building Name"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func getTitles() {
    for loc in locations {
            locationTitles.append(loc.title)
        }
    }
    
    //  Protocol Function
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //  Call custom function to resopond live
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTitles = locationTitles.filter { title in
            return title.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    //  MARK: - SearchBar Delegate
    
    internal func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // called when text starts editing
    }
    
    internal func searchBarSearchButtonClicked(searchBar: UISearchBar){
        // called when keyboard search button pressed
        searchBar.showsCancelButton = true
        
    }
    
    //  MARK: - TableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredTitles.count
        }
        return locationTitles.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MVCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath) 
        if searchController.active {searching = true}
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = locationTitles[indexPath.row]
        } else {
            cell.textLabel?.text = filteredTitles[indexPath.row]
        }

        return cell
    }

    
    //  Load Markers
    func loadMarkers() {
        //  SAC
        let SACLoc = GMSMarker()
        SACLoc.position = CLLocationCoordinate2DMake(40.914299, -73.123715)
        SACLoc.title = "SAC"
        SACLoc.snippet = "Stony Brook University"
        locations.append(SACLoc)
        
        //  Melvile library
        let melville = GMSMarker()
        melville.position = CLLocationCoordinate2DMake(40.915380, -73.122799)
        melville.title = "Melville Library"
        melville.snippet = "Stony Brook Univeristy"
        locations.append(melville)
        
        //  Light Engineering
        let lightEngr = GMSMarker()
        lightEngr.position = CLLocationCoordinate2DMake(40.913529, -73.125473)
        lightEngr.title = "Light Engineering"
        lightEngr.snippet = "Stony Brook Univeristy"
        locations.append(lightEngr)
        
        //  Javits Center
        let javits = GMSMarker()
        javits.position = CLLocationCoordinate2DMake(40.912929, -73.122083)
        javits.title = "Javits Lecture Hall"
        javits.snippet = "Stony Brook Univeristy"
        locations.append(javits)
        
        //  Harriman Hall
        let hariman = GMSMarker()
        hariman.position = CLLocationCoordinate2DMake(40.915648, -73.125347)
        hariman.title = "Harriman Hall"
        hariman.snippet = "Stony Brook Univeristy"
        locations.append(hariman)
        
        //  Frey Hall
        let frey = GMSMarker()
        frey.position = CLLocationCoordinate2DMake(40.915652, -73.123913)
        frey.title = "Frey Hall"
        frey.snippet = "Stony Brook Univeristy"
        locations.append(frey)
        
        //  Chemistry
        let chem = GMSMarker()
        chem.position = CLLocationCoordinate2DMake(40.916329, -73.123752)
        chem.title = "Chemistry Building"
        chem.snippet = "Stony Brook Univeristy"
        locations.append(chem)
        
        //  Psychology
        let psych = GMSMarker()
        psych.position = CLLocationCoordinate2DMake(40.914383, -73.122473)
        psych.title = "Psychology A"
        psych.snippet = "Stony Brook Univeristy"
        locations.append(psych)
        
        //  New Computer Science
        let newCompSci = GMSMarker()
        newCompSci.position = CLLocationCoordinate2DMake(40.912905, -73.123629)
        newCompSci.title = "New Computer Science"
        newCompSci.snippet = "Stony Brook Univeristy"
        locations.append(newCompSci)
        
        // Old Computer Science
        let oldCompSci = GMSMarker()
        oldCompSci.position = CLLocationCoordinate2DMake(40.912510, -73.122879)
        oldCompSci.title = "Old Computer Science"
        oldCompSci.snippet = "Stony Brook Univeristy"
        locations.append(oldCompSci)
        
        //  Humanities
        let humanities = GMSMarker()
        humanities.position = CLLocationCoordinate2DMake(40.913922, -73.121040)
        humanities.title = "Humanities"
        humanities.snippet = "Stony Brook Univeristy"
        locations.append(humanities)
    }
}
/*
extension MapSearchTVC: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //  Call custom function to resopond live
        filterContentForSearchText(searchController.searchBar.text!)
    }
}*/