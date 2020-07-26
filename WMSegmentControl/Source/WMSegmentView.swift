//
//  WMSegmentView.swift
//  WMSegmentControl
//
//  Created by Wasim on 24/06/20.
//  Copyright © 2020 Wasim Malek. All rights reserved.
//

import UIKit

class WMSegmentView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnTitle: UIButton!
    var selector: UIView!
    
    //MARK: Initialization
       override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       private func commonInit() {
           Bundle.main.loadNibNamed("WMSegmentView", owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
           contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
           btnTitle.titleLabel?.textAlignment = .center
       }
    
    func setTitleColor(_ color: UIColor) {
        btnTitle.setTitleColor(color, for: .normal)
    }
    func setTitleFont(_ font: UIFont) {
        btnTitle.titleLabel?.font = font
    }
    func setTitle(_ title: String) {
        btnTitle.setTitle(title, for: .normal)
    }
    
    func setImage(_ image: UIImage?) {
        btnTitle.setImage(image, for: .normal)
    }
    func setTint(_ color: UIColor) {
        btnTitle.tintColor = color
    }
    
    func makeImageCenter() {
        btnTitle.centerImageAndButton(5, imageOnTop: true)
    }
    
    /*func setupSelector(_ title:String, image: String, type: SelectorType, bg: UIColor) {
        let titles = title.components(separatedBy: ",")
        let images = image.components(separatedBy: ",")
    var selectorWidth = frame.width / CGFloat(titles.count)
        if type == .onlyImage {
            selectorWidth = frame.width / CGFloat(images.count)
        }

        if type == .normal {
            selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
            if isRounded {
                if roundedRadius == 0 {
                    selector.layer.cornerRadius = frame.height / 2
                }
                else {
                    selector.layer.cornerRadius = roundedRadius
                }
            } else {
                selector.layer.cornerRadius = 0
            }
        } else if selectorType == .bottomBar {
            selector = UIView(frame: CGRect(x: 0, y: frame.height - bottomBarHeight, width: selectorWidth, height: bottomBarHeight))
            selector.layer.cornerRadius = 0
        }

        selector.backgroundColor = bg
        addSubview(selector)
    }*/

}
