//
//  AbilityCell.swift
//  Alex Pokemon App 1
//
//  Created by Austin Zheng on 5/22/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class AbilityCell: UITableViewCell {

    @IBOutlet weak var abilityName: UILabel!
    @IBOutlet weak var abilityUrl: UILabel!
    @IBOutlet weak var abilityHidden: UILabel!
    @IBOutlet weak var abilitySlot: UILabel!
  
    func setAbilityCell(name: String, url: String, hidden: String, slot: String) {
        abilityName.text = name
        abilityUrl.text = url
        abilityHidden.text = hidden
        abilitySlot.text = slot
    }
}
