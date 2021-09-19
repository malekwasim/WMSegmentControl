//
//  WMSegment.swift
//  WMSegmentControl
//
//  Created by Wasim Malek on 27/05/19.
//  Copyright © 2019 Wasim Malek. All rights reserved.
//

import UIKit
@IBDesignable
open class WMSegment: UIControl {
    public var onValueChanged: ((_ index: Int)->())?
    var buttons = [UIButton]()
    var selector: UIView!
    public var selectedSegmentIndex: Int = 0
    
    public var type: SegementType = .normal {
        didSet {
            updateView()
        }
    }
    
    public var selectorType: SelectorType = .normal {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable
    public var buttonTitles: String = ""{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    public var buttonImages: String = ""{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    public var buttonImagesSelected: String = ""
    
    @IBInspectable
    public var textColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    public var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    public var selectorColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    public var isRounded: Bool = false {
        didSet {
            if self.isRounded == true {
                layer.cornerRadius = frame.height/2
            }
            updateView()
        }
    }
    
    @IBInspectable
    public var bottomBarHeight : CGFloat = 5.0 {
        didSet {
            updateView()
        }
    }
    
    public var normalFont : UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            updateView()
        }
    }
    
    public var SelectedFont : UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            updateView()
        }
    }
    
    public var animate: Bool = true
    
    private var isFrameAreSet = false
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        updateView()
    }
    
    open func updateView() {
        self.clipsToBounds = true
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        NotificationCenter.default.removeObserver("DeviceRotated")
        NotificationCenter.default.addObserver(self, selector: #selector(setViewLayout), name: NSNotification.Name(rawValue: "DeviceRotated"), object: nil)
        if self.type == .normal {
            buttons = getButtonsForNormalSegment()
        }  else if self.type == .imageOnTop {
            buttons = getButtonsForNormalSegment(true)
        } else if self.type == .onlyImage {
            buttons = getButtonsForOnlyImageSegment()
        }
        
        if selectedSegmentIndex < buttons.count {
            buttons[selectedSegmentIndex].tintColor = selectorTextColor
            buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
            buttons[selectedSegmentIndex].titleLabel?.font = SelectedFont
        }
        setupSelector()
        addSubview(selector)
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually//.fillProportionally
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func setupSelector() {
        
        let titles = buttonTitles.components(separatedBy: ",")
        let images = buttonImages.components(separatedBy: ",")
        var selectorWidth = frame.width / CGFloat(titles.count)
        if self.type == .onlyImage {
            selectorWidth = frame.width / CGFloat(images.count)
        }
        
        
        if selectorType == .normal {
            selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
            if isRounded {
                selector.layer.cornerRadius = frame.height / 2
            } else {
                selector.layer.cornerRadius = 0
            }
        } else if selectorType == .bottomBar {
            selector = UIView(frame: CGRect(x: 0, y: frame.height - bottomBarHeight, width: selectorWidth, height: bottomBarHeight))
            selector.layer.cornerRadius = 0
        }
        
        selector.backgroundColor = selectorColor
    }
    
    //MARK : Get Button as per segment type
    func getButtonsForNormalSegment(_ isImageTop: Bool = false) -> [UIButton] {
        var btn = [UIButton]()
        let titles = buttonTitles.components(separatedBy: ",")
        let images = buttonImages.components(separatedBy: ",")
        for (index, buttonTitle) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.tag = index
            button.tintColor = textColor
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = normalFont
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            btn.append(button)
            if index < images.count {
                if images[index] != ""{
                    button.setImage(UIImage(named: images[index]), for: .normal)
                    if isImageTop == false {
                        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                    } else {
                        button.centerImageAndButton(5, imageOnTop: true)
                    }
                }
                
                
            }
        }
        
        return btn
    }
    
    func getButtonsForOnlyImageSegment() -> [UIButton] {
        var btn = [UIButton]()
        let images = buttonImages.components(separatedBy: ",")
        for (index, buttonImage) in images.enumerated() {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: buttonImage), for: .normal)
            button.tag = index
            button.tintColor = textColor
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            btn.append(button)
            
        }
        return btn
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isFrameAreSet == false {
            setViewLayout()
        }
    }
    
    @objc open func setViewLayout() {
        layoutIfNeeded()
        updateView()
        let _animated = self.animate
        self.animate = false
        setSelectedIndex(self.selectedSegmentIndex)
        self.animate = _animated
        isFrameAreSet = true
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let images = self.buttonImages.components(separatedBy: ",")
        let imagesSelected = self.buttonImagesSelected.components(separatedBy: ",")

        for (buttonIndex, btn) in buttons.enumerated() {
            btn.tintColor = textColor
            btn.setTitleColor(textColor, for: .normal)
            btn.titleLabel?.font = normalFont
            
            if let image = images[safe: buttonIndex] {
                btn.setImage(UIImage(named: image), for: .normal)
            }
            
            if btn == sender {
                if let imageSelected = imagesSelected[safe: buttonIndex], !imageSelected.isEmpty {
                    btn.setImage(UIImage(named: imageSelected), for: .normal)
                }
                selectedSegmentIndex = buttonIndex
                let startPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                if self.animate {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        self.selector.frame.origin.x = startPosition
                    }, completion: nil)
                }else{
                    self.selector.frame.origin.x = startPosition
                }
                btn.titleLabel?.font = SelectedFont
                btn.tintColor = selectorTextColor
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        onValueChanged?(selectedSegmentIndex)
        sendActions(for: .valueChanged)
    }
    //MARK: set Selected Index
    open func setSelectedIndex(_ index: Int) {
        let images = self.buttonImages.components(separatedBy: ",")
        let imagesSelected = self.buttonImagesSelected.components(separatedBy: ",")
        
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.tintColor = textColor
            btn.setTitleColor(textColor, for: .normal)
            if let image = images[safe: buttonIndex] {
                btn.setImage(UIImage(named: image), for: .normal)
            }
            
            if btn.tag == index {
                if let imageSelected = imagesSelected[safe: buttonIndex], !imageSelected.isEmpty {
                    btn.setImage(UIImage(named: imageSelected), for: .normal)
                }
                selectedSegmentIndex = buttonIndex
                let startPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                if self.animate {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        self.selector.frame.origin.x = startPosition
                    }, completion: nil)
                }else{
                    self.selector.frame.origin.x = startPosition
                }
                
                btn.tintColor = selectorTextColor
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    
    //MARK: chage Selector Color
    open func changeSelectedColor(_ color: UIColor) {
        self.selector.backgroundColor = color
    }
    
}
//MARK: UIbutton Extesion
extension UIButton {
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.currentImage,
            let titleLabel = self.titleLabel?.text else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        self.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
}

extension Array {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//MARK: Enums
public enum SegementType: Int {
    case normal = 0, imageOnTop, onlyImage
}

public enum SelectorType: Int {
    case normal = 0, bottomBar
}

