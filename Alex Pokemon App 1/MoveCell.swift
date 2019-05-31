//
//  MoveCell.swift
//  Alex Pokemon App 1
//
//  Created by Austin Zheng on 5/22/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {

    @IBOutlet weak var moveName: UILabel!
    @IBOutlet weak var levelLearnedAtNumber: UILabel!
    @IBOutlet weak var moveUrl: UILabel!
    @IBOutlet weak var learnMethodName: UILabel!
    @IBOutlet weak var learnMethodUrl: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupUrl: UILabel!
    
    func setMoveCell(Name: String, level: String, url: String, methodName: String, methodUrl: String, groupname: String, groupurl: String) {
        moveName.text = Name
        levelLearnedAtNumber.text = level
        moveUrl.text = url
        learnMethodName.text = methodName
        learnMethodUrl.text = methodUrl
        groupName.text = groupname
        groupUrl.text = groupurl
        
    }
    
    
}
