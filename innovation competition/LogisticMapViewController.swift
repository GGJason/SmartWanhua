//
//  FirstViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/11.
//  Copyright © 2018 GGJason. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class LogisticMapViewController: UIViewController,GMSMapViewDelegate {
    static var currentStoreName:String = ""
    static var currentSelectMarker:GMSMarker!
    var placesClient: GMSPlacesClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()

        loadView()
        findShop()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 25.028911, longitude: 121.496251, zoom: 14)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
       view = mapView
        mapView.delegate = self
        
//         Creates a marker in the center of the map.
        for grid in TabBarController.parkingGrids{
            if(grid.id == 545427){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: grid.latitude, longitude: grid.longitude)
                marker.icon = GMSMarker.markerImage(with: UIColor.blue)
                marker.map = mapView
                marker.snippet = "車格編號：545427\n您已預訂 17:50 - 18:10"
                marker.zIndex = 10000
                
            }
            else if(grid.type == 1 ){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: grid.latitude, longitude: grid.longitude)
                marker.icon = GMSMarker.markerImage(with: UIColor.green)
                marker.map = mapView
                marker.snippet = "車格編號：\(grid.id)\n可停車"
            }
            else if(grid.type == 7 ){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: grid.latitude, longitude: grid.longitude)
                marker.icon = GMSMarker.markerImage(with: UIColor.green)
                marker.map = mapView
                marker.snippet = "\(grid.id)"
            }
        }
        let marker = GMSMarker()
        marker.zIndex=100001
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    func findShop(){
        if let mapView = view as? GMSMapView{
            // A hotel in Saigon with an attribution.
            let placeID = "ChIJhxJ_IaipQjQRoUtwYDbbDeU"
            
            placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details for \(placeID)")
                    return
                }
                
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
                let marker = GMSMarker()
                marker.position = place.coordinate
                marker.title = LogisticMapViewController.currentStoreName
                marker.map = mapView
                marker.snippet = "預計送貨時間： 11/12 18:00"
                marker.zIndex=100001
                
                mapView.selectedMarker = marker
                mapView.camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 20)
            })
        }
      
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        LogisticMapViewController.currentSelectMarker = marker
        if let logisticMapSearchView = self.parent as? LogisticMapSearchViewController{
            logisticMapSearchView.reservationView.isHidden = false
        }
        
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    }
}

