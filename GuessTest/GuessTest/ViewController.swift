//
//  ViewController.swift
//  GuessTest
//
//  Created by iOS on 2018/6/12.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func guseeAction(_ sender: Any) {
        
        let vc = GuessMoneyController.instance()
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func secondAction(_ sender: Any) {
        let vc = CustomInputController.instance()
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController : GuessMoneyControllerDelegate {
    func updateTime(time: String) {
        print("--------- \(time)")
        timeLabel.isHidden = false
        timeLabel.text = time
    }
}

