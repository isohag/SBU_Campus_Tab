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

class DailyLifeVC: UIViewController,  UISearchBarDelegate {
    
    //  MARK:-  Variables
    var locations = [GMSMarker]()
    var filteredLocations = [GMSMarker]()
    
    //let searchController = UISearchController(searchResultsController: nil)
    
    var locationSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefersStatusBarHidden()
        let camera = GMSCameraPosition.cameraWithLatitude(40.914468,
            longitude: -73.123646, zoom: 17)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsetsMake(0, 0, bottomLayoutGuide.length + 60, 0)
        loadMarkers(mapView)
        self.view = mapView
        
        //  Search 
        configSearchBar()
        self.view.addSubview(locationSearchController.searchBar)
    }
    
    private func configSearchBar() {
        // Configure LocationSearchController
        self.locationSearchController = ({
            // Setup Two: Alternative - This presents the results in a sepearate tableView
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let alternateController:MapSearchTVC = storyBoard.instantiateViewControllerWithIdentifier("searchTVC") as! MapSearchTVC
            let controller = UISearchController(searchResultsController: alternateController)
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchResultsUpdater = alternateController
            controller.definesPresentationContext = false
            controller.searchBar.sizeToFit()
            
            return controller
        })()
    }

    //  Hide status bar
    override func prefersStatusBarHidden() -> Bool {return true}
    
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

