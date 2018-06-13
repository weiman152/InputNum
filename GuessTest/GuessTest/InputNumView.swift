//
//  InputNumView.swift
//  GuessTest
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

protocol InputNumViewDelegate: NSObjectProtocol {
    /// 输入是否完成
    func inputFinish(complete: Bool)
}

class InputNumView: UIView {
    
    var delegate: InputNumViewDelegate?
    
    lazy var textField: UITextField = {
        return $0
    }( UITextField() )
    
    private var labelArray = [UILabel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        addSubview(textField)
        textField.keyboardType = .numberPad
        textField.delegate = self
    }
    
    private func setupLayout() {
        textField.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }

}

extension InputNumView {
    
     func setup(numOfRect: Int = 4 ,
                           margin: CGFloat = 10,
                           pointWidth: CGFloat = 5) {
        
        let tempWidth: CGFloat = CGFloat(numOfRect + 1) * margin
        let width: CGFloat = (bounds.size.width - 5 - tempWidth) / CGFloat(numOfRect)
        let height: CGFloat = bounds.size.height
        
        for i in 0...numOfRect {
            
            if i < numOfRect / 2 {
                // 点的左边
                let frame = CGRect(x: CGFloat(i) * width + margin * CGFloat(i+1),
                                   y: 0,
                                   width: width,
                                   height: height)
                let label = createLabel(frame: frame)
                addSubview(label)
                labelArray.append(label)
            } else if i == numOfRect / 2 {
                // 点
                let frame = CGRect(x: CGFloat(i) * width + margin * CGFloat(i+1),
                                   y: 0,
                                   width: pointWidth,
                                   height: height)
                let label = createLabel(frame: frame, needBorder: false)
                label.text = "."
                addSubview(label)
            } else {
                // 点的右边
                let frame = CGRect(x: CGFloat(i-1) * width + pointWidth + margin * CGFloat(i+1),
                                   y: 0,
                                   width: width,
                                   height: height)
                let label = createLabel(frame: frame)
                addSubview(label)
                labelArray.append(label)
            }
        }
        // 第一个框变成选中状态
        if let firstLabel = labelArray.first {
            setSelectBorder(label: firstLabel)
        }
    }
    
    func beFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    func getInputText() -> String {
        return textField.text ?? ""
    }
    
}

extension InputNumView {
    
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
    
}

extension InputNumView: UITextFieldDelegate {
    
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
                delegate?.inputFinish(complete: true)
            }
        } else {
            // 删除的时候
            delegate?.inputFinish(complete: false)
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