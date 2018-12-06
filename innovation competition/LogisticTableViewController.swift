//
//  LogisticTableViewController.swift
//  innovation competition
//
//  Created by 吳軒竹 on 2018/11/27.
//  Copyright © 2018 GGJason. All rights reserved.
//

import Foundation
import UIKit
class LogisticTableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
    }
    let shops:[String] = ["健臺大藥局",
                          "迦豐企業有限公司",
        "寶島手路菜有限公司",
        "永明國際商品貿易股份有限公司",
        "肉倉有限公司",
        "竑倢企業有限公司",
        "華旗順有限公司",
        "西門町鴨肉扁有限公司",
        "蔣師美容有限公司",
        "森玉企業有限公司",
        "弘偉有限公司",
        "奇爾士國際有限公司",
        "信鍊餐飲文化有限公司",
        "宏稻實業有限公司",
        "專品醫療器材有限公司",
        "美霖精品有限公司",
        "伯維特科技有限公司",
        "映華國際娛樂股份有限公司",
        "佳明半導體股份有限公司",
        "光泰宏通訊有限公司"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if var cell = tableView.dequeueReusableCell(withIdentifier: "logisticCell"){
            let spaceCount = Int.random(in: 0 ... 5)
            cell.detailTextLabel?.text = "\(spaceCount)"
            cell.detailTextLabel?.textColor = spaceCount < 2 ? UIColor.red:UIColor.darkText;
            cell.textLabel?.text = shops[indexPath.row]
            return cell
        }
        return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LogisticMapViewController.currentStoreName = tableView.cellForRow(at: indexPath)?.textLabel?.text! ?? ""
        performSegue(withIdentifier: "LogisticShowMapSegue", sender: self)
    }
    
}
