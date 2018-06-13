//
//  CustomInputController.swift
//  GuessTest
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class CustomInputController: UIViewController {
    
    @IBOutlet weak var inputNumView: InputNumView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputNumView.beFirstResponder()
    }
    
    private func setup() {
        inputNumView.setup()
        inputNumView.delegate = self
    }
    
    private func goBack() {
        dismiss(animated: true, completion: nil)
    }

    class func instance() -> CustomInputController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CustomInputController") as! CustomInputController
        return vc
    }
}

extension CustomInputController {
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        print("---------  \(inputNumView.getInputText())")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        goBack()
    }
}

extension CustomInputController: InputNumViewDelegate {
    
    func inputFinish(complete: Bool) {
        if complete {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor.blue
        } else {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = UIColor.gray
        }
    }
}
