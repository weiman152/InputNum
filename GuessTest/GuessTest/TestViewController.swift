//
//  TestViewController.swift
//  GuessTest
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var testInput: InputNumView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testInput.setup(numOfRect: 6, margin: 10, pointWidth: 5, pointLocation: 4)
        testInput.delegate = self
        testInput.beFirstResponder()
    }
    
    @IBAction func OK(_ sender: Any) {
        print(testInput.getInputText())
    }
    
    class func instance() -> TestViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        return vc
    }
    
}

extension TestViewController : InputNumViewDelegate {
    
    func inputFinish(complete: Bool) {
        
    }
}
