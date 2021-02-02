//
//  EventTableViewCell.swift
//  countdown
//
//  Created by hwen on 30/1/21.
//

import Foundation
import UIKit

// Customise table view cell for the event table.
class EventTableViewCell:UITableViewCell {
    
    @IBOutlet weak var colourLine: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var remainingDesc: UILabel!
    
}
