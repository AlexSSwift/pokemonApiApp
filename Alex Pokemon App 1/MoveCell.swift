//
//  MoveCell.swift
//  Alex Pokemon App 1
//
//  Created by Austin Zheng on 5/22/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moveName: UILabel!
    @IBOutlet weak var moveUrl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var groupDetails: [Move.GroupDetails] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoveGroupDetailCell") as! MoveGroupDetailCell
        let cellTask = groupDetails[indexPath.row]
        
        cell.setUpCell(methodName: cellTask.moveLearnMethodName, groupDetailName: cellTask.versionGroupName, methodUrl: "\(cellTask.moveLearnmethodUrl)", groupDetailUrl: "\(cellTask.versionGroupUrl)", level: "\(cellTask.levelLearnedAt)")
        
        return cell
    }
    
    func setMoveCell(Name: String, url: String) {
        moveName.text = Name
        moveUrl.text = url
        
    }
    
    
}
