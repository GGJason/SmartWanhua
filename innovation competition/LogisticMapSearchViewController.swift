//
//  LogisticMapSearchViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/28.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import UIKit
class LogisticMapSearchViewController:UIViewController{
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var reservationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.text = LogisticMapViewController.currentStoreName
    }
}
