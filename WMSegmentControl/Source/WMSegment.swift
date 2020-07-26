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
    var buttons = [WMSegmentView]()
    var selector: UIView!
    public var selectedSegmentIndex: Int = 0

    public var type: SegmentType = .normal {
        didSet {
            updateView()
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'selectorType' instead.")
    @IBInspectable var typeNum: Int = 0 {
        willSet {
            // Ensure user enters a valid value
            // Ignore input if not valid.
            if let newType = SegmentType(rawValue: newValue) {
                type = newType
            }
        }
    }

    public var selectorType: SelectorType = .normal {
        didSet {
            updateView()
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'selectorType' instead.")
    @IBInspectable var selectorTypeNum: Int = 0 {
        willSet {
            // Ensure user enters a valid value
            // Ignore input if not valid.
            if let newSelectorType = SelectorType(rawValue: newValue) {
                selectorType = newSelectorType
            }
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
    public var buttonSelectedImages: String = ""{
        didSet {
            updateView()
        }
    }

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
                if roundedRadius == 0 {
                    layer.cornerRadius = frame.height/2
                }
                else {
                    layer.cornerRadius = roundedRadius
                }
            }
            updateView()
        }
    }

    @IBInspectable
    public var roundedRadius: CGFloat = 0 { // default 0 gir full bue
        didSet {
            if self.isRounded == true {
                if roundedRadius == 0 {
                    layer.cornerRadius = frame.height/2
                }
                else {
                    layer.cornerRadius = roundedRadius
                }
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
    let bundle = Bundle(for: WMSegment.self)  // for making images show in interface uilder

    func updateView() {

        self.clipsToBounds = true
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})

        if self.type == .normal {
            buttons = getButtonsForNormalSegment()
        }  else if self.type == .imageOnTop {
            buttons = getButtonsForNormalSegment(true)
        } else if self.type == .onlyImage {
            buttons = getButtonsForOnlyImageSegment()
        }

        if selectedSegmentIndex < buttons.count {
            if buttonSelectedImages.count == 0 {
                buttons[selectedSegmentIndex].setTint(selectorTextColor)
            }
            buttons[selectedSegmentIndex].setTitleColor(selectorTextColor)
            buttons[selectedSegmentIndex].setTitleFont(SelectedFont)
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

        selector.backgroundColor = selectorColor
    }

    //MARK : Get Button as per segment type
    func getButtonsForNormalSegment(_ isImageTop: Bool = false) -> [WMSegmentView] {
        var btn = [WMSegmentView]()
        let titles = buttonTitles.components(separatedBy: ",")
        let images = buttonImages.components(separatedBy: ",")
        for (index, buttonTitle) in titles.enumerated() {
            let segmentView = WMSegmentView()//UIButton(type: .system)
            segmentView.setTitle(buttonTitle)
            segmentView.btnTitle.tag = index
            if buttonSelectedImages.count == 0 {
                segmentView.setTint(textColor)
            }
            segmentView.setTitleColor(textColor)
            segmentView.setTitleFont(normalFont)
            segmentView.btnTitle.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            btn.append(segmentView)
            if index < images.count {
                if images[index] != ""{
                    segmentView.setImage(UIImage(named: images[index], in: bundle, compatibleWith: nil))
                    if buttonSelectedImages.count != 0 {
                        segmentView.setImage(UIImage(named: images[index], in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal))
                    }
                    if isImageTop == false {
                        segmentView.btnTitle.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                    } else {
                        segmentView.makeImageCenter()
                    }
                }
            }
        }

        return btn
    }

    func getButtonsForOnlyImageSegment() -> [WMSegmentView] {
        var btn = [WMSegmentView]()
        let images = buttonImages.components(separatedBy: ",")
        for (index, buttonImage) in images.enumerated() {
            let segmentView = WMSegmentView()//UIButton(type: .system)
            segmentView.setImage(UIImage(named: buttonImage, in: bundle, compatibleWith: nil))
            if buttonSelectedImages.count != 0 {
                segmentView.setImage(UIImage(named: buttonImage, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal))
            }
            segmentView.btnTitle.tag = index
            if buttonSelectedImages.count == 0 {
                segmentView.setTint(textColor)
            }
            segmentView.btnTitle.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            btn.append(segmentView)

        }
        return btn
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
        let _animated = self.animate
        self.animate = false
        setSelectedIndex(self.selectedSegmentIndex)
        self.animate = _animated
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let images = buttonImages.components(separatedBy: ",")
        let selectedImages = buttonSelectedImages.components(separatedBy: ",")
        for (buttonIndex, viewSegment) in buttons.enumerated() {
            if buttonSelectedImages.count == 0 {
                viewSegment.setTint(textColor)
            }
            viewSegment.setTitleColor(textColor)
            viewSegment.setTitleFont(normalFont)
            
            if viewSegment.btnTitle == sender {
                selectedSegmentIndex = buttonIndex
                let startPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                if self.animate {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        self.selector.frame.origin.x = startPosition
                    }, completion: nil)
                }else{
                    self.selector.frame.origin.x = startPosition
                }
                viewSegment.setTitleFont(SelectedFont)
                
                if buttonSelectedImages.count == 0 {
                    viewSegment.setTint(selectorTextColor)
                }
                viewSegment.setTitleColor(selectorTextColor)
                
            }
            if buttonIndex < images.count && images[buttonIndex] != ""{
                viewSegment.setImage(UIImage(named: images[buttonIndex], in: bundle, compatibleWith: nil))
                if buttonSelectedImages.count != 0 {
                    viewSegment.setImage(UIImage(named: images[buttonIndex], in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal))
                }
            }
        }

        if selectedSegmentIndex < selectedImages.count && selectedImages[selectedSegmentIndex] != "" {
            let img = UIImage(named: selectedImages[selectedSegmentIndex], in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
            buttons[selectedSegmentIndex].setImage(img)
        }
        onValueChanged?(selectedSegmentIndex)
        sendActions(for: .valueChanged)
    }
    //MARK: set Selected Index
    open func setSelectedIndex(_ index: Int) {
        for (buttonIndex, viewSegment) in buttons.enumerated() {
            if buttonSelectedImages.count == 0 {
                viewSegment.setTint(textColor)
            }
            viewSegment.setTitleColor(textColor)

            if viewSegment.tag == index {
                selectedSegmentIndex = buttonIndex
                let startPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                if self.animate {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        self.selector.frame.origin.x = startPosition
                    }, completion: nil)
                }else{
                    self.selector.frame.origin.x = startPosition
                }
                if buttonSelectedImages.count == 0 {
                    viewSegment.setTint(selectorTextColor)
                }
                viewSegment.setTitleColor(selectorTextColor)
            }
        }
        let selectedImages = buttonSelectedImages.components(separatedBy: ",")
        if selectedSegmentIndex < selectedImages.count && selectedImages[selectedSegmentIndex] != "" {
            let img = UIImage(named: selectedImages[selectedSegmentIndex], in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
            buttons[selectedSegmentIndex].setImage(img)
        }
    }

    //MARK: chage Selector Color
    open func changeSelectedColor(_ color: UIColor) {
        self.selector.backgroundColor = color
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateView()
    }

}

//MARK: UIButton Extension
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

//MARK: Enums
public enum SegmentType: Int {
    case normal = 0, imageOnTop, onlyImage
}

public enum SelectorType: Int {
    case normal = 0, bottomBar
}
