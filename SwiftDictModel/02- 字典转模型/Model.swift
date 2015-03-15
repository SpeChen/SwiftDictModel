//
//  Model.swift
//  02- 字典转模型
//
//  Created by coderCSF on 15/3/13.
//  Copyright (c) 2015年 coderCSF. All rights reserved.
//

import Foundation
class Model: NSObject, DictModelProtocol {
    var str1: String?
    var str2: NSString?
    var b: Bool = false
    var i: Int = 0
    var f: Float = 0
    var d: Double = 0
    
    var demo: NSArray?
    var num: NSNumber?
    var info: Info?
    var other: [Info]?
    var others: NSArray?
    
    static func customClassMapping() -> [String : String] {
        return ["info": "\(Info.self)","other": "\(Info.self)","others": "\(Info.self)" ]
    }
    
}

class Info: NSObject {
    var name: String?
}



class SubModel: Model {
    var boy: String?
}