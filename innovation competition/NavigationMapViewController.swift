//
//  NavigationMapViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/11.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CSV
class NavigationMapViewController:UIViewController,CLLocationManagerDelegate{
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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
        setNavigation()
        initPositionCircle()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 25.028911, longitude: 121.496251, zoom: 14)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        //         Creates a marker in the center of the map.
        for grid in TabBarController.parkingGrids{
            if(grid.id == 545427){
                continue
            }
            else if(grid.id == 544549){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: grid.latitude, longitude: grid.longitude)
                marker.icon = GMSMarker.markerImage(with: UIColor.red)
                marker.map = mapView
                marker.zIndex = 100001
                marker.snippet = "車格編號：\(grid.id)\n您已預約"
            }
            else if(grid.type == 1 ){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: grid.latitude, longitude: grid.longitude)
                marker.icon = GMSMarker.markerImage(with: UIColor.green)
                marker.map = mapView
                marker.snippet = "車格編號：\(grid.id)\n可停車"
            }
            
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
                //marker.map = mapView
                marker.snippet = "預計送貨時間： 11/12 18:00"
                marker.zIndex=100001
                
                //mapView.selectedMarker = marker
                mapView.camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 20)
                
            })
        }
        
    }
    func setNavigation(){
        
        var json = """
        {
            \"geocoded_waypoints\": [
            {
              \"geocoder_status\": \"OK\",
              \"place_id\": \"ChIJMYrqiaipQjQR8wy4PiK9Rn8\",
              \"types\": [
                \"street_address\"
              ]
            },
            {
              \"geocoder_status\": \"OK\",
              \"place_id\": \"ChIJn3BhJKipQjQRcQCzHb8VbrM\",
              \"types\": [
                \"street_address\"
              ]
            }
          ],
          \"routes\": [
            {
              \"bounds\": {
                \"northeast\": {
                  \"lat\": 25.0408612,
                  \"lng\": 121.5020682
                },
                \"southwest\": {
                  \"lat\": 25.0383658,
                  \"lng\": 121.5009354
                }
              },
              \"copyrights\": \"Map data ©2018 Google\",
              \"legs\": [
                {
                  \"distance\": {
                    \"text\": \"0.4 km\",
                    \"value\": 364
                  },
                  \"duration\": {
                    \"text\": \"2 mins\",
                    \"value\": 108
                  },
                  \"end_address\": \"No. 160, Section 2, Changsha St, Wanhua District, Taipei City, Taiwan 108\",
                  \"end_location\": {
                    \"lat\": 25.0408612,
                    \"lng\": 121.5009354
                  },
                  \"start_address\": \"No. 214, Kangding Road, Wanhua District, Taipei City, Taiwan 108\",
                  \"start_location\": {
                    \"lat\": 25.0383658,
                    \"lng\": 121.5017731
                  },
                  \"steps\": [
                    {
                      \"distance\": {
                        \"text\": \"0.2 km\",
                        \"value\": 240
                      },
                      \"duration\": {
                        \"text\": \"1 min\",
                        \"value\": 63
                      },
                      \"end_location\": {
                        \"lat\": 25.040505,
                        \"lng\": 121.5020682
                      },
                      \"html_instructions\": \"Head <b>north</b> on <b>康定路</b> toward <b>康定路188巷</b>\",
                      \"polyline\": {
                        \"points\": \"yhywCayqdVyBQy@E{@GUAkAIy@I]E\"
                      },
                      \"start_location\": {
                        \"lat\": 25.0383658,
                        \"lng\": 121.5017731
                      },
                      \"travel_mode\": \"DRIVING\"
                    },
                    {
                      \"distance\": {
                        \"text\": \"28 m\",
                        \"value\": 28
                      },
                      \"duration\": {
                        \"text\": \"1 min\",
                        \"value\": 13
                      },
                      \"end_location\": {
                        \"lat\": 25.0404945,
                        \"lng\": 121.501794
                      },
                      \"html_instructions\": \"Turn <b>left</b> onto <b>長沙街二段</b>\",
                      \"maneuver\": \"turn-left\",
                      \"polyline\": {
                        \"points\": \"cvywC}zqdVAT?H@F@N\"
                      },
                      \"start_location\": {
                        \"lat\": 25.040505,
                        \"lng\": 121.5020682
                      },
                      \"travel_mode\": \"DRIVING\"
                    },
                    {
                      \"distance\": {
                        \"text\": \"0.1 km\",
                        \"value\": 96
                      },
                      \"duration\": {
                        \"text\": \"1 min\",
                        \"value\": 32
                      },
                      \"end_location\": {
                        \"lat\": 25.0408612,
                        \"lng\": 121.5009354
                      },
                      \"html_instructions\": \"Slight <b>right</b> to stay on <b>長沙街二段</b><div style=\\"font-size:0.9em\\">Destination will be on the right</div>\",
                      \"maneuver\": \"turn-slight-right\",
                      \"polyline\": {
                        \"points\": \"avywCeyqdVIP_@fACJ[bA\"
                      },
                      \"start_location\": {
                        \"lat\": 25.0404945,
                        \"lng\": 121.501794
                      },
                      \"travel_mode\": \"DRIVING\"
                    }
                  ],
                  \"traffic_speed_entry\": [],
                  \"via_waypoint\": []
                }
              ],
              \"overview_polyline\": {
                \"points\": \"yhywCayqdVeGa@eCS]EAT@P@NIPc@rA[bA\"
              },
              \"summary\": \"康定路 and 長沙街二段\",
              \"warnings\": [],
              \"waypoint_order\": []
            }
          ],
          \"status\": \"OK\"
        }
        """
        print("json")
        if let mapView = view as? GMSMapView{
            print("mapView")
            let welcome = try? JSONDecoder().decode(Welcome.self, from: json.data(using: .utf8)!)
            if let legs = welcome?.routes.first?.legs{
                
                print("leg")
                for var point in legs{
                    print("point")
                    for var step in point.steps{
                        print("step")
                        let path: GMSPath = GMSPath(fromEncodedPath: step.polyline.points)!
                        var routePolyline = GMSPolyline(path: path)
                        routePolyline.map = mapView
                        print("all")
                    }
                }
            }
        }
        
    }
    var positionCircle = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        print ("newHeading")
    }
    func initPositionCircle(){
        
        if let mapView = view as? GMSMapView{
            
            let view = UIView()
            view.backgroundColor = UIColor.black
            view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 35, height: 35 ))
            view.layer.cornerRadius = 17.5
            let subview = UIView()
            subview.backgroundColor = UIColor.init(red:0.529 , green: 0.808, blue:  0.98, alpha: 1)
            subview.frame = CGRect(origin: CGPoint(x: 2.5, y: 2.5), size: CGSize(width: 30, height: 30 ))
            subview.layer.cornerRadius = 15
            view.addSubview(subview)
        positionCircle.iconView = view
        positionCircle.zIndex = 1000000
            positionCircle.map = mapView}
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("locationManager")
        if let mapView = view as? GMSMapView{
            
            let location = locations.last
            
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 20.0)
            
            mapView.animate(to: camera)
            positionCircle.position = (location?.coordinate)!
            //Finally stop updating location otherwise it will come again and again in this delegate
        }
    }
}
