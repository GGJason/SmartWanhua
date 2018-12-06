//
//  ParkingGridReservationViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/30.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import UIKit
class ParkingGridReservationViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    var reservation:[ParkReservation] = [ParkReservation("健台大藥局" ,"544549" , 15, .Upcoming),
         ParkReservation("健台大藥局" ,"544549" , 21, .Used),
         ParkReservation("健台大藥局" ,"544549" , 17, .Used),
         ParkReservation("健台大藥局" ,"544549" , 32, .Used)]
    @IBOutlet weak var reservationTable: UITableView!

    
    @IBAction func reservePark(_ sender: Any) {
        reservation.insert(ParkReservation("健台大藥局", "544549", Int.random(in: 5 ... 25), .Reserved),at:0)
        if reservationTable != nil{
            reservationTable.reloadData()
        }
    }
    override func viewDidLoad() {
        reservationTable.delegate = self
        reservationTable.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return reservation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if var cell = tableView.dequeueReusableCell(withIdentifier: "parkingGrid"){
            var currentStore = reservation[indexPath.row]
            cell.textLabel!.text = "\(currentStore.store) (\(currentStore.grid))"
            cell.detailTextLabel!.text = "\(currentStore.time)"
            switch (currentStore.status){
            case .Reserved:
                cell.detailTextLabel?.textColor = UIColor.black
                break
            case .Upcoming:
                cell.detailTextLabel?.textColor = UIColor.green
                break
            case .Used:
                cell.detailTextLabel?.textColor = UIColor.gray
                break
            case .Using:
                cell.detailTextLabel?.textColor = UIColor.blue
                break
            }
            return  cell
        }
        
        return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNavigationSegue", sender: self)
    }
}
class ParkReservation{
    var store:String = ""
    var grid:String = ""
    var time:Int = 15
    var status:ReservationStatus = .Used
    init(_ store:String,_ grid:String,_ time:Int,_ status:ReservationStatus) {
        self.store = store
        self.grid = grid
        self.time = time
        self.status = status
    }
}
enum ReservationStatus{
    case Reserved
    case Upcoming
    case Using
    case Used
}
