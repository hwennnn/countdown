//
//  EventDetailsViewController.swift
//  countdown
//
//  Created by hwen on 31/1/21.
//

import Foundation
import UIKit

class EventDetailsViewController:UIViewController {
    
    var event:Event?
    var colourSchemeList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colourSchemeList = ["#DFC8F2", "#A0C5E8", "#AEFFBD", "#FFEAAB", "#5854D5", "#D92728"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (event != nil){
            self.view.backgroundColor = colourSchemeList[event!.colour].colorWithHexString()
        }
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
}
