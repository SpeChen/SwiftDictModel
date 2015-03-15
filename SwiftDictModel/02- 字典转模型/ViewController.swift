//
//  ViewController.swift
//  02- 字典转模型
//
//  Created by coderCSF on 15/3/13.
//  Copyright (c) 2015年 coderCSF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = loadJSON()
        let obj = SwiftDictModel.sharedManager.objectWithDictionary(json, cls: SubModel.self) as! SubModel
        println("OTHER")
        for value in obj.other! {
            println(value.name)
        }
        
        println("OTHERS")
        for value in obj.others! {
            let o = value as! Info
            println(o.name)
        }
        
        println("Demo \(obj.demo!)")
        
    }

    func loadJSON() -> NSDictionary {
        let path = NSBundle.mainBundle().pathForResource("Model01.json", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        let json = NSJSONSerialization.JSONObjectWithData(data!, options: .allZeros, error: nil) as! NSDictionary
        return json
    }
    
}

