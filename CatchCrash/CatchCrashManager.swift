/***********************************************************
 * 版权所有,2017,MeFood.
 * Copyright(C),2017,MeFood co. LTD.All rights reserved.
 * project:Li
 * Author:
 * Date:  17/10/25
 * QQ/Tel/Mail:
 * Description:crash信息获取
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/

import UIKit

/* ~~~~~~~~~~~~~~~~~~ signal ～～～～～～～～～～～～～～～ */
func registerSignalHandler(){
    
    signal(SIGABRT) { (sig) in
        signalExceptionHandler(sig)
    }
    signal(SIGSEGV) { (sig) in
        signalExceptionHandler(sig)
    }
    signal(SIGBUS) { (sig) in
        signalExceptionHandler(sig)
    }
    signal(SIGTRAP) { (sig) in//nil 越界 错误
        signalExceptionHandler(sig)
    }
    signal(SIGILL) { (sig) in
        signalExceptionHandler(sig)
    }
}

func signalExceptionHandler(_ sig:Int32){
    //处理signal
    var mstr = String();
    mstr = mstr.appendingFormat("slideAdress:0x%0x\r\n", calculate())
    for symbol in Thread.callStackSymbols {
        mstr += "\n\(symbol)"
    }
    //保存错误日志到本地
    saveCrashLog(crashInfo: mstr)
    //主线程睡眠3秒
    Thread.sleep(forTimeInterval: 1);
    //退出
    exit(sig)
}

func unregisterSignalHandler()
{
    signal(SIGINT, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
}

/*～～～～～～～～～～～NSException～～～～～～～～～～～～*/
func registerNSException(){
    NSSetUncaughtExceptionHandler { (exception:NSException) in
        uncaughtExceptionHandler(exception);
    }
}

func uncaughtExceptionHandler(_ exception:NSException){
    //MARK:处理NSException
    let arr = exception.callStackSymbols
    let reason = exception.reason
    let name = exception.name.rawValue
//    let address = "slideAdress:0x%0x\(calculate())\r\n"
    var crash = String()
    
    crash = crash.appendingFormat("slideAdress:0x%0x\r\n", calculate())
    crash += "name:\(name) \r\n reason:\(String(describing: reason)) \r\n \(arr.joined(separator: "\r\n")) \r\n\r\n"
    //MARK:保存错误日志到本地
    saveCrashLog(crashInfo: crash);
    
    Thread.sleep(forTimeInterval: 1)
    exit(4);
}

/*~~~~~~~~~~~~~~~~~~~保存错误日志~~~~~~~~~~~~~~~~~~~~~~~*/
func saveCrashLog(crashInfo:String){
    let filemanager = FileManager.default;
    if let base = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last {
        let path = base + "/Log/Crash"
        //如果不存在就去创建
        if !filemanager.fileExists(atPath: path) {
            do{
                try filemanager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                assertionFailure("创建文件失败\(error)")
                return;
            }
        }
        //文件名称
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyyMMddHHmmss"
        let date = formatter.string(from: Date());
        let crashfile = path + "/\(date).log";
        
        //写入
        do {
            try crashInfo.write(toFile: crashfile, atomically: true, encoding: .utf8);
        }catch{
            assertionFailure("文件写入本地错误\(error)")
            return;
        }
    }
}




class CatchCrashManager: NSObject {
    
    //MARK:注册信号捕捉和异常捕捉
    func installCatchException(){
        fetchCrashLog();
        deleteAllCrashLog();
        registerSignalHandler();
        registerNSException();
    }
    
    //MARK:定义or获取保存crashlog地址
    private func fetchCrashLogPath() -> String?{
        if let base = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last {
            let path = base + "/Log/Crash"
            return path;
        }
        return nil
    }
    
    
    //MARK:获取错误日志
    func fetchCrashLog(){
        let filemanager = FileManager.default;
        
        guard let path = fetchCrashLogPath() else {
            return;
        }
        
        if let files = try? filemanager.contentsOfDirectory(atPath: path) {
            var log = String();
            files.forEach({ (item) in
                do{
                    let url = path + "/\(item)"
                    let str = try String.init(contentsOfFile: url, encoding: .utf8)
                    log.append("\n \(str)");
                }catch{
                    assertionFailure("读取内容失败=\(error)")
                }
            })
            print("错误日志=\(log)")
        }
    }
    
    //MARK:删除所有日志
    func deleteAllCrashLog(){
        let manager = FileManager.default;
        guard let path = fetchCrashLogPath() else {
            return;
        }
        if let files = try? manager.contentsOfDirectory(atPath: path) {
            files.forEach({ (item) in
                let temp = path + "/\(item)"
                deleteFile(file: temp);
            })
        }
    }
    
    //MARK:删除某个文件
    func deleteFile(file:String){
        let manager = FileManager.default;
        do {
            try manager.removeItem(atPath: file)
        } catch  {
            assertionFailure("删除文件失败=\(error)")
        }
    }
}
