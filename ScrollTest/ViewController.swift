//
//  ViewController.swift
//  ScrollTest
//
//  Created by Владимир Мельников on 26/09/2016.
//  Copyright © 2016 Владимир Мельников. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollBarView: ScrollBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let elements = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve"]
        print("LOAD")
        scrollBarView.elements = elements
        scrollBarView.delegate = self
    }
    
}

extension ViewController: ScrollBarViewDelegate {
    
    func didSelectItem(atIndex index: Int) {
        print(index)
    }
    
}
