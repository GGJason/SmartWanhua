//
//  HomeTableViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/11.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import UIKit
class HomeTableViewController:UITableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            print(cell.accessibilityIdentifier)
            switch(cell.reuseIdentifier){
                
            case "reserveParking":
                print("reserve")
                break
            default:
                break
            }
        }
    }
}
