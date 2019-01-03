/***********************************************************
 * 版权所有 liwei
 * Copyright(C),2018,Chiting co. LTD.All rights reserved.
 * project:蓝牙手柄
 * Author:
 * Date:  2019/01/02
 * QQ/Tel/Mail:
 * Description:游戏杆
 * Others:todo:
 * Modifier:
 * Reason:
 *************************************************************/

import UIKit

struct JoystickOffset {
    var xOffset:Int = 0
    var yOffset:Int = 0
}

protocol JoystickViewDelegate: NSObjectProtocol {
    func move(_ offset:JoystickOffset)
    func end(_ arg:Bool)
}

class JoystickView: UIView {
    
    private let bigCircle: CGFloat = 120
    private let smallCircle: CGFloat = 50
    
    private lazy var indicatorView = UIView()
    private lazy var bg = UIView()
    
    weak var delegate: JoystickViewDelegate? = nil
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customView()
    }
    
    private func customView(){
        let subs:[UIView] = [bg,indicatorView]
        subs.forEach { (item) in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        layoutBgView()
        layoutIndicatorView()
    }
    
    private func layoutBgView(){
        let centerX = bg.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        let centerY = bg.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        let width = bg.widthAnchor.constraint(equalToConstant: bigCircle)
        let height = bg.heightAnchor.constraint(equalToConstant: bigCircle)
        addConstraints([centerY,centerX])
        bg.addConstraints([width,height])
        bg.layer.cornerRadius = bigCircle / 2
        bg.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    private func layoutIndicatorView(){
        let centerX = indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        let centerY = indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        let width = indicatorView.widthAnchor.constraint(equalToConstant: smallCircle)
        let height = indicatorView.heightAnchor.constraint(equalToConstant: smallCircle)
        addConstraints([centerX,centerY])
        indicatorView.addConstraints([width,height])
        indicatorView.layer.cornerRadius = smallCircle / 2
        indicatorView.backgroundColor = UIColor.red
    }
    //回到原点
    private func resetCenter(){
        UIView.animate(withDuration: 0.2, animations: {
            let size = self.bounds.size
            let point = CGPoint.init(x:size.width / 2 , y: size.height / 2)
            self.indicatorView.center = point
        }) { (flag) in
            print("动画完成:\(flag)")
        }
        delegate?.end(true)
    }
    //处理移动点
    private func handleTouches(_ touches: Set<UITouch>){
        if let point = touches.first?.location(in: self) {
            let size = self.bounds.size
            let cX = size.width / 2
            let cY = size.height / 2
            //中心点
            let center = CGPoint.init(x: cX, y: cY)
            //当前
            let end = point
            //计算半径 三角函数 计算出半径
            let AB = abs(end.x - center.x)
            let BC = abs(end.y - center.y)
            let AC = sqrt(AB * AB + BC * BC)
            let radius = bigCircle / 2
            var current: CGPoint
            //出边界了
            if AC >= radius {
                let angle = self.calculateAngle(center, end: end)
                let currentX = cX + radius * cos(angle)
                let currentY = cY - radius * sin(angle)
                current = CGPoint.init(x: currentX, y: currentY)
            }else {
                current = point
            }
            self.indicatorView.center = current
            //计算偏移了多少 x,y
            /*-x表示向左偏移
             *-y表示向下偏移
             *+x向右
             *+y向上
             */
            let offsetx = end.x - center.x
            let offsety = center.y - end.y
            var joyoffset = JoystickOffset()
            joyoffset.xOffset = Int(offsetx / radius * 100)
            joyoffset.yOffset = Int(offsety / radius * 100)
            delegate?.move(joyoffset)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        handleTouches(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        resetCenter()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        handleTouches(touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        resetCenter()
    }
    
    //计算角度
    private func calculateAngle(_ strat: CGPoint,end: CGPoint)-> CGFloat {
        var angle: CGFloat = 0
        let AB = abs(end.x - strat.x)
        let BC = abs(end.y - strat.y)
        let AC = sqrt(AB * AB + BC * BC)
        if AC == 0 {
            angle = -1
        }
        if AB == 0 {
            angle = CGFloat(end.y > strat.y ? .pi * ( 3.0 / 2.0):.pi / 2)
        }else if BC == 0 {
            angle = end.x > strat.x ? 0:.pi
        }else {
            let arg = (AB * AB + AC * AC - BC * BC) / (2 * AC * AB)
            angle = acos(arg)
            if (end.x > strat.x && end.y < strat.y){
                angle += 0
            }else if (end.x < strat.x && end.y < strat.y){
                angle = .pi - angle
            }else if (end.x < strat.x && end.y > strat.y){
                angle += .pi
            }else {
                angle = .pi * 2 - angle
            }
        }
        
        
        return angle
    }
}
