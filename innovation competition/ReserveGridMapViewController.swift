//
//  ReserveGridMapViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/11.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CSV
class ReserveGridMapViewController:UIViewController,GMSMapViewDelegate{
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        if let url = Bundle.main.url(forResource: "road_parking", withExtension: "csv"){
            if let stream = InputStream(url:url)
            {
                if let csv = try? CSVReader(stream:stream,hasHeaderRow:true){
                    while csv.next() != nil{
                        if let id = Int(csv["KEYID"] as! String),let longitude = Double(csv["x_cen_84"] as! String),let latitude = Double(csv["y_cen_84"] as! String),let type = Int(csv["PKTYPE"] as! String){
                            var grid = Grid();
                            grid.id = id
                            grid.latitude = latitude
                            grid.longitude = longitude
                            grid.type = type
                            TabBarController.parkingGrids.append(grid)
                        }
                        
                    }
                }
            }
        }
        
        
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
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: grid.latitude, longitude: grid.longitude)
            marker.icon = GMSMarker.markerImage(with: UIColor.green)
            marker.map = mapView
            marker.snippet = "車格編號：\(grid.id)\n可停車"
            
        }
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
                marker.title = "健台大藥局"
                marker.map = mapView
                marker.snippet = "預計送貨時間： 11/12 18:00"
                marker.zIndex=100001
                
                //mapView.selectedMarker = marker
                mapView.camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 20)
            })
        }
        
    }
    var infoView = UIView()
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        infoView = UIView()
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 100 )))
        label.text = marker.snippet
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 310), size: CGSize(width: 200, height: 50 )))
        button.titleLabel!.text = "預約"
        view.addSubview(label)
        view.addSubview(button)
        return view
    }
}
