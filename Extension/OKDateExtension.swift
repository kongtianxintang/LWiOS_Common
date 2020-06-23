/***********************************************************
 * 版权所有,2017,MeFood.
 * Copyright(C),2017,MeFood co. LTD.All rights reserved.
 * project:Li
 * Author:
 * Date:  2020/06/23
 * QQ/Tel/Mail:
 * Description:对日期类的扩展
 * Others:
 * Modifier:
 * Reason: 系统提供部分参数
 *************************************************************/
import UIKit


protocol OKDateProtocol {
    var weeks_cn:Array<String> {get}
    var weekday_en:String {get}
    var weekday_cn:String {get}
    var weekday_en_short:String {get}
}

extension OKDateProtocol {
    
    var weeks_cn: Array<String> {
        return ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    }
}

extension Date:OKDateProtocol{
    
    var weekday_en_short: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        return  Calendar.current.shortWeekdaySymbols[weekday - 1]
    }

    var weekday_cn: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        return weeks_cn[weekday - 1]
    }

    var weekday_en: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        return Calendar.current.weekdaySymbols[weekday - 1]
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

