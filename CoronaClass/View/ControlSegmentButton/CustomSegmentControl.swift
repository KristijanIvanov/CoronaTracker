//
//  CustomSegmentControl.swift
//  CoronaClass
//
//  Created by Kristijan Ivanov on 4/12/21.
//

import UIKit

import UIKit
protocol CustomSegmentedControlDelegate:class {
    func selectedIndex(_ index: Int)
}

class CustomSegmentedControl: UIView {
    var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    private var buttonsStackView: UIStackView!
    
    var textColor: UIColor = UIColor(hex: "3C3C3C")
    var selectorViewColor: UIColor = UIColor(hex: "5AC7AA")
    var selectorTextColor: UIColor = .white
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        if sender.tag == selectedIndex { return }
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                delegate?.selectedIndex(buttonIndex)
                selectedIndex = buttonIndex
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(self.selectorTextColor, for: .normal)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for i in 0...buttonTitles.count - 1 {
            let button = UIButton(type: .custom)
            button.setTitle(buttonTitles[i], for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.tag = i
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selectorView.layer.cornerRadius = frame.height / 2
        selectorView.layer.masksToBounds = true
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func configStackView() {
        buttonsStackView = UIStackView(arrangedSubviews: buttons)
        buttonsStackView.axis = .horizontal
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buttonsStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        buttonsStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
