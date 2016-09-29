//
//  ScrollBarView.swift
//  ScrollTest
//
//  Created by Владимир Мельников on 27/09/2016.
//  Copyright © 2016 Владимир Мельников. All rights reserved.
//

import UIKit

protocol ScrollBarViewDelegate {
    func didSelectItem(atIndex index: Int)
}

class ScrollBarView: UIView {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    
    private var bageView: UIView!
    
    //MARK: - Public API
    @IBInspectable var scrollOffset: CGFloat = 0
    @IBInspectable var spacing: CGFloat = 8
    
    @IBInspectable var bageDelta: CGFloat = 0
    @IBInspectable var bageCornerRadius: CGFloat = 10
    @IBInspectable var bageColor = UIColor.white

    var delegate: ScrollBarViewDelegate?
    var elements = ["Add", "Some", "Elements"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
        if bageView == nil {
            for element in elements {
                let button = UIButton()
                button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
                button.setTitle(element, for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.sizeToFit()
                stackView.addArrangedSubview(button)
            }
            scrollView.contentSize = CGSize(width: stackView.frame.width, height: scrollView.frame.height)
            scrollView.contentOffset = CGPoint(x: -bageDelta/2, y: scrollView.contentOffset.y)
            scrollView.contentInset = UIEdgeInsetsMake(0, bageDelta/2, 0, bageDelta/2)
            
            let firstSubview = stackView.arrangedSubviews[0]
            let origin = CGPoint(x: firstSubview.frame.origin.x - bageDelta/2, y: firstSubview.frame.origin.y)
            bageView = UIView(frame: CGRect(origin: origin, size: CGSize(width: firstSubview.frame.width + bageDelta, height: 44)))
            bageView.backgroundColor = bageColor
            scrollView.addSubview(bageView)
            scrollView.sendSubview(toBack: bageView)
            bageView.center.y = stackView.center.y
            bageView.layer.cornerRadius = bageCornerRadius
        }
    }
    
    private func initializeSubviews() {
        let viewName = "ScrollBarView"
        let view = Bundle.main.loadNibNamed(viewName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        view.backgroundColor = backgroundColor
        stackView.spacing = spacing
    }
    
    func buttonPressed(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.bageView.frame = CGRect(origin: button.frame.origin, size: CGSize(width: button.frame.width + self.bageDelta, height: 44))
            self.bageView.center = button.center
            
            if button.frame.maxX + self.bageDelta / 2 > self.scrollView.contentOffset.x + self.scrollView.frame.maxX {
                var x = self.scrollView.contentOffset.x + button.frame.width + self.scrollOffset + self.bageDelta/2
                let maxOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width + self.bageDelta/2
                if x > maxOffset {
                    x = maxOffset
                }
                self.scrollView.contentOffset = CGPoint(x: x, y: self.scrollView.contentOffset.y)
            } else if button.frame.minX - self.bageDelta/2 < self.scrollView.contentOffset.x {
                var x = self.scrollView.contentOffset.x - button.frame.width - self.scrollOffset - self.bageDelta/2
                if x < -self.bageDelta/2 {
                    x = -self.bageDelta/2
                }
                self.scrollView.contentOffset = CGPoint(x: x, y: self.scrollView.contentOffset.y)
            }
        }
        if let d = delegate {
            let title = button.titleLabel?.text
            if let index = elements.index(of: title!) {
                d.didSelectItem(atIndex: index)
            }
        } else {
            print("Oops, seems like you forgot to add delegate!")
        }
    }
    
}
