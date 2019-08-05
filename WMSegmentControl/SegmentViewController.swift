//
//  ViewController.swift
//  WMSegmentControl
//
//  Created by Wasim Malek on 27/05/19.
//  Copyright © 2019 Wasim Malek. All rights reserved.
//

import UIKit

class SegmentViewController: UITableViewController {
    
    @IBOutlet weak var sgTextOnly: WMSegment!
    @IBOutlet weak var sgTextImage: WMSegment!
    @IBOutlet weak var sgTextImageRound: WMSegment!
    @IBOutlet weak var sgImageOnly: WMSegment!
    @IBOutlet weak var sgTextOnlyBar: WMSegment!
    @IBOutlet weak var sgImageOnlyBar: WMSegment!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom Segment"
        sgImageOnly.type = .onlyImage
        sgImageOnlyBar.type = .onlyImage
        sgImageOnlyBar.selectorType = .bottomBar
        sgTextOnlyBar.selectorType = .bottomBar
        sgTextOnlyBar.SelectedFont = UIFont(name: "ChalkboardSE-Bold", size: 15)!
        sgTextOnlyBar.normalFont = UIFont(name: "ChalkboardSE-Regular", size: 15)!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("first item")
        case 1:
            print("second item")
        case 2:
            print("Third item")
        default:
            print("default item")
        }
    }
    
}

