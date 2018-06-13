# InputNum
swift4 每次输入一个数字的输入框。

效果图：
<br>
![Alt text](https://github.com/weiman152/InputNum/blob/master/screenShot/11.png)
<br>
![Alt text](https://github.com/weiman152/InputNum/blob/master/screenShot/22.gif)
<br>

使用方式：

默认：（四个框框，小数点在中间）
inputNumView.setup()
inputNumView.delegate = self
inputNumView.beFirstResponder()

自定义：
testInput.setup(numOfRect: 6, margin: 10, pointWidth: 5, pointLocation: 4)
testInput.delegate = self
testInput.beFirstResponder()

参数简介：
/// 创建框框
///
/// - Parameters:
///   - numOfRect: 框框个数
///   - margin: 框框之间的间距
///   - pointWidth: 中间小数点的宽度
///   - pointLocation: 小数点的位置
func setup(numOfRect: Int = 4 , margin: CGFloat = 10, pointWidth: CGFloat = 5, pointLocation: Int = 2)


实现思路：
   放一个很小的textfield，然后在指定的view上添加指定个数的label，每个label显示一个数字。中间的一个label显示小数点。

只是demo，供参考。
