//
//  ZZCountdownButton.swift
//  ZTZD
//
//  Created by Lausen on 2019/4/17.
//  Copyright © 2019 yuke. All rights reserved.
//

import UIKit

/// 全局的变量,可以后期需要的时候自己更改
let getCode: String = "点击获取验证吗"
let timeout: String = "后重新获取"
let reGetCode: String = "重新获取验证码"
let radius: CGFloat = 3

typealias ClickCallBack = ((_ timer: DispatchSourceTimer) -> ())

class ZZCountdownButton: UIButton {

    /// 全局的计时器
    private(set) lazy var timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
    /// 点击的回调
    var clickCallBack: ClickCallBack?
    /// 普通状态下的背景颜色
    var normalColor: UIColor = UIColor.blue
    /// 倒计时状态下的背景颜色
    var countdownColor: UIColor = UIColor.lightGray
    /// 全局的记录倒计时的秒数
    var countdownSecond: Int = 0{
        
        willSet{
            //设置title
            let smsTitle = newValue > 0 ? "\(newValue)S\(timeout)" : reGetCode
            
            setTitle(smsTitle, for: .normal)
            
            //如果倒计时为0的时候,停止
            if newValue <= 0{
                
                //1:如果等于0的时候,让按钮可用
                isEnabled = true
                
                //2:暂停倒计时
                timer.suspend()
                
                //3:设置此时的背静颜色
                backgroundColor = normalColor
                
            }else{
                
                //倒计时过程中的背静颜色
                backgroundColor = countdownColor
            }
        }
    }
    var recordCountSecond = 0
    
    /// 代码实例化按钮的方法
    ///
    /// - Parameters:
    ///   - count: 倒计时秒数
    ///   - normalColor: 普通状态下的背景颜色
    ///   - countdownColor: 倒计时状态下的背景颜色
    ///   - isSMSBtn: 是否是短信验证码按钮
    ///   - clickCallBack: 回调
    init(count: Int,normalColor: UIColor = UIColor.gray,countdownColor : UIColor = UIColor.lightGray,clickCallBack:ClickCallBack?) {
        super.init(frame: .zero)
        
        setupCurrentBtn()
        
        countdownSecond = count
        recordCountSecond = countdownSecond
        self.normalColor = normalColor
        self.countdownColor = countdownColor
        self.clickCallBack = clickCallBack
        
        backgroundColor = normalColor
    }
    
    /// xib实例化按钮的方法
    ///
    /// - Parameter aDecoder:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCurrentBtn()
    }
}

extension ZZCountdownButton{
    
    /// 设置的当前的按钮
    func setupCurrentBtn(){
        //字体颜色统一设置为白色
        setTitleColor(UIColor.white, for: .normal)
        //fixme: - 字体大小,背景颜色透明度,等都在这儿设置就好了
        
        setTitle(getCode, for: .normal)
        layer.cornerRadius = radius
        layer.masksToBounds = true
        addTarget(self, action: #selector(smsbuttonClick(sender:)), for: .touchUpInside)
        
        //给定时器添加事件
        timer.schedule(deadline: .now(), repeating: 1, leeway: .milliseconds(1))
        timer.setEventHandler {
            self.countdownSecond -= 1
        }
    }
    
    /// 短信验证码按钮的点击事件
    @objc private func smsbuttonClick(sender: UIButton){
        
        timer.resume()
        
        //1:先设置按钮不可用
        sender.isEnabled = false
        
        //2:如果有回调,就执行回调,没有不做动作
        clickCallBack?(timer)
        
        //3:倒计时结束,按钮可用之后,重新赋值倒计时事件
        if sender.titleLabel?.text == reGetCode{
            
            countdownSecond = recordCountSecond
        }
    }
}
