//
//  ViewController.swift
//  Liking
//
//  Created by Marco Sun on 16/6/7.
//  Copyright © 2016年 Marco Sun. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let aa = ["phone": 18621345565]
//        let array:[String] = ["988736676","testCcmsIam500QiangA","1465296939"]
//        let b =  array.sort(<)
//        let str:String = b[0] + b[1] + b[2]
////        let str = "1465296812462638229testCcmsIam500QiangA"
//        print(str)
//        // 6cd3e077a8b8fbc1159ac28c6c1ea3d14f3d3064
//        let aaa = str.sha1()
//        print(aaa)
//        
//        print(b)
        
        NetWorker.request(.POST, urlStr: URL.TimeStamp, params: nil, success: { (dataObj) in
            print("----")
            }, failed: { (error) in
                print(error)
                
            }) { (statusCode, message) in
        }
        
        
    }

}
