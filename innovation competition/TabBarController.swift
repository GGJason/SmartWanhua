//
//  TabBarController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/11.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import UIKit
import CSV
import GoogleMaps
class TabBarController:UITabBarController{
    static var parkingGrids:[Grid] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
}
