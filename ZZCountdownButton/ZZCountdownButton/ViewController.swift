//
//  ViewController.swift
//  ZZCountdownButton
//
//  Created by Lausen on 2019/4/25.
//  Copyright © 2019 yuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sourceTimer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countdownBtn = ZZCountdownButton(count: 60) { [weak self](_ timer: DispatchSourceTimer) in
            
            self?.sourceTimer = timer
            
            print("发送网络请求")
        }
        
        countdownBtn.sizeToFit()
        countdownBtn.center = view.center
        
        view.addSubview(countdownBtn)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.sourceTimer?.cancel()
    }
    
    deinit {
        print("控制器出栈了")
    }
}

