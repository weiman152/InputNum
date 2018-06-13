//
//  GuessMoneyController.swift
//  GuessTest
//
//  Created by iOS on 2018/6/12.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

protocol GuessMoneyControllerDelegate: NSObjectProtocol {
    /// 同步更新上一页的时间
    func updateTime(time: String)
}

class GuessMoneyController: UIViewController {
    
    var delegate: GuessMoneyControllerDelegate?
    /// 高能卡的数量
    var highEnergyCardNum: Int = 2
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var numView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var showLabel: UILabel!
    
    private var labelArray = [UILabel]()
    /// 框子的个数
    private let numOfRect = 4
    /// 中间小数点的宽度
    private let pointWidth: CGFloat = 5
    /// 框框之间的间距
    private let margin: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
        // 定时器
        setupTimer()
    }
    
    private func setup() {
        
        confirmBtn.isEnabled = false
        
        inputTextField.delegate = self
        makeLabel(superView: numView)
        // 第一个label选中
        if let firstLabel = labelArray.first {
            setSelectBorder(label: firstLabel)
        }
    }
    
    private func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    class func instance() -> GuessMoneyController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GuessMoneyController") as! GuessMoneyController
        return vc
    }
}

extension GuessMoneyController {
    
    @IBAction func confirmAction(_ sender: Any) {
         showLabel.text = inputTextField.text
         //goBack()
    }
}

extension GuessMoneyController {
    
    private func makeLabel(superView: UIView) {
        
        let tempWidth: CGFloat = CGFloat(numOfRect + 1) * margin
        let width: CGFloat = (superView.bounds.size.width - 5 - tempWidth) / CGFloat(numOfRect)
        let height: CGFloat = superView.bounds.size.height
        
        for i in 0...numOfRect {
            
            if i < numOfRect / 2 {
                // 点的左边
                let frame = CGRect(x: CGFloat(i) * width + margin * CGFloat(i+1),
                                   y: 0,
                                   width: width,
                                   height: height)
                let label = createLabel(frame: frame)
                superView.addSubview(label)
                labelArray.append(label)
            } else if i == numOfRect / 2 {
                // 点
                let frame = CGRect(x: CGFloat(i) * width + margin * CGFloat(i+1),
                                   y: 0,
                                   width: pointWidth,
                                   height: height)
                let label = createLabel(frame: frame, needBorder: false)
                label.text = "."
                superView.addSubview(label)
            } else {
                // 点的右边
                let frame = CGRect(x: CGFloat(i-1) * width + pointWidth + margin * CGFloat(i+1),
                                   y: 0,
                                   width: width,
                                   height: height)
                let label = createLabel(frame: frame)
                superView.addSubview(label)
                labelArray.append(label)
            }
            
        }
    }
    
    private func createLabel(frame: CGRect, needBorder: Bool = true) -> UILabel {
        let label = UILabel()
        label.frame = frame
        label.text = ""
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        if needBorder {
            setNormalBorder(label: label)
        }
        return label
    }
    
    /// 设置选中颜色
    private func setSelectBorder(label: UILabel) {
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1
    }
    
    private func setNormalBorder(label: UILabel) {
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth = 1
    }
    
    private func setupTimer() {
        //设定定时时间
        var countTime = 30
        // 在global线程里创建一个时间源
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        // 设定这个时间源是每1s循环一次，立即开始
        timer.schedule(deadline: .now(), repeating: 1)
        // 设定时间源的触发事件
        timer.setEventHandler {
            // 每1s计时一次
            countTime -= 1
            if countTime <= 0 {
                timer.cancel()
                self.goBack()
            }
            // 返回主线程，更新UI
            DispatchQueue.main.async {
                if countTime > 9 {
                   self.timeLabel.text = "00:\(countTime)"
                } else {
                   self.timeLabel.text = "00:0\(countTime)"
                }
                self.delegate?.updateTime(time: self.timeLabel.text ?? "")
            }
        }
        //启动定时器
        timer.resume()
    }
}

extension GuessMoneyController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard range.location < labelArray.count else {
            print("输入无效")
            return false
        }
        
        for label in labelArray {
            setNormalBorder(label: label)
        }
        
        let showLabel = labelArray[range.location]
        showLabel.text = string
        
        if string.count > 0 {
            // 输入的时候
            if range.location < labelArray.count - 1 {
                let nextLabel = labelArray[range.location + 1]
                setSelectBorder(label: nextLabel)
            } else {
                setSelectBorder(label: labelArray[labelArray.count-1])
                confirmBtn.isEnabled = true
                confirmView.backgroundColor = UIColor.blue
            }
        } else {
            // 删除的时候
            confirmBtn.isEnabled = false
            confirmView.backgroundColor = UIColor.gray
            if range.location > 0 {
                let previousLabel = labelArray[range.location - 1]
                setSelectBorder(label: previousLabel)
            } else {
                setSelectBorder(label: labelArray[0])
            }
        }
        return true
    }
}



