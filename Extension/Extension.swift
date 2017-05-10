/***********************************************************
 * 版权所有,2017,MeFood.
 * Copyright(C),2017,MeFood co. LTD.All rights reserved.
 * project:Li
 * Author:
 * Date:  17/02/17
 * QQ/Tel/Mail:
 * Description:对部分类做的扩展
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/

import Foundation
import UIKit
import Kingfisher

extension UIColor {
    
    //浅绿色
    class final var lightGreen:UIColor{
        return UIColor.init(red: 227 / 255.0, green: 241 / 255.0, blue: 200 / 255.0, alpha: 1)
    }
    
    //输入框边框颜色～ 使用在注册 登录 等输入性质的textfiled外边框
    class final var textInputBackground:UIColor{
        return UIColor.init(red: 182 / 255.0, green: 214 / 255.0, blue: 144 / 255.0, alpha: 1)
    }
    
    class final var lightTextInputBackground:UIColor{
        return UIColor.init(red: 182 / 255.0, green: 214 / 255.0, blue: 144 / 255.0, alpha: 0.3)
    }
    
    //app 导航条 主题色
    class final var QFNavigationBarBackground:UIColor{
        return UIColor.init(red: 131 / 255.0, green: 186 / 255.0, blue: 22 / 255.0, alpha: 1)
    }
    
    //
    class final var QFlightCellBackground:UIColor{
        return UIColor.init(red: 227 / 255.0, green: 229 / 255.0, blue: 230 / 255.0, alpha: 1)
    }
    
    //设备生效～字体颜色 ～ 深绿
    class final var QFdeviceValidText:UIColor{
        return UIColor.init(red: 64 / 255.0, green: 113 / 255.0, blue: 0 / 255.0, alpha: 1)
    }
    //主页早中晚
    class final var QFSupper:UIColor{
        return UIColor.init(hexString: "#105d95")
    }
    class final var QFLightSupper:UIColor {
        return UIColor.init(hexString: "#76abef")
    }
    class final var QFFoldSupper:UIColor {
        return UIColor.init(hexString: "#c7e0ff")
    }
    class final var QFBreakfast:UIColor{
        return UIColor.init(hexString: "#648d0b")
    }
    class final var  QFLightBreakfast:UIColor{
        return UIColor.init(hexString: "#bcdd74")
    }
    class final var QFFoldBreakfast:UIColor {
        return UIColor.init(hexString: "#ddedbc")
    }
    class final var QFLunch:UIColor{
        return UIColor.init(hexString: "#ca8619")
    }
    class final var QFLightLunch:UIColor{
        return UIColor.init(hexString: "#fbd550")
    }
    class final var QFFoldLunch:UIColor {
        return UIColor.init(hexString: "#feeeb3")
    }
    class final var QFAfternoon:UIColor{
        return UIColor.init(hexString: "#a33f3f")
    }
    class final var QFLightAfternoon:UIColor{
        return UIColor.init(hexString: "#ff8c85")
    }
    class final var QFFoldAfternoon:UIColor {
        return UIColor.init(hexString: "#ffd3d0")
    }
    class final var QFProgress:UIColor{
        return QFColor(red: 150, green: 91, blue: 18, alphe: 1)
    }
    
    class final var QFLightYellow:UIColor{
        return QFColor(red: 255, green: 208, blue: 51, alphe: 1)
    }
    
    //qf的颜色构造器
    private class func QFColor(red:CGFloat,green:CGFloat,blue:CGFloat,alphe:CGFloat)->UIColor{
        return UIColor.init(red: red / 255.0 , green: green / 255.0, blue: blue / 255.0, alpha: alphe)
    }
    
    //十六进制色系
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
}

//统一管理kingfisher ~~ 改成自己工程的风格代码
extension UIImageView {
    
    func qfSet(with url:String,completionHandler:CompletionHandler?){
        let placeholder = UIImage.init(named: "default")
        let path = URL.init(string: url)
        kf.setImage(with: path, placeholder: placeholder, options: [.transition(.fade(0.5)),.targetCache(.default)], progressBlock: nil, completionHandler: completionHandler)
        kf.indicatorType = .activity
    }
}

//
extension NSObject {
    
    /// 根据类名创建一个实体类
    ///
    /// - Parameter className: 类名称
    /// - Returns: anyclass
    class func createInstanceFromString(className:String)->AnyClass?{
        let name = "QFood." + className
        return NSClassFromString(name)
    }
}


extension Date{
    
    //eg: 2017-03-15
    var stringValue:String{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.string(from: self)
    }
    
    /*
     eg:formatter = yyyy-MM-dd 
     return 2017-03-16
     */
    func stringValue(formatter:String)->String{
        let formater = DateFormatter()
        formater.dateFormat = formatter
        return formater.string(from: self)
    }
}

extension UIView {

    //MARK:旋转动画
    func rotationAnimation(){
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = 0
        animation.toValue = M_PI * 2.0
        animation.duration = 3.0
        animation.repeatCount = MAXFLOAT
        self.layer.add(animation, forKey: nil)
    }
    
}

extension Float {
    //保留一位小数
    func kFloatFormat()->String{
        return String.init(format: "%.1f", self)
    }
    
}

