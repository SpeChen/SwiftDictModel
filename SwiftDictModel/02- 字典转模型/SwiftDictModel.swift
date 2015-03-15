

//
//  SwiftDictModel.swift
//  02- 字典转模型
//
//  Created by coderCSF on 15/3/13.
//  Copyright (c) 2015年 coderCSF. All rights reserved.
//

import Foundation
/// 字典转模型自定义对象协议
@objc protocol DictModelProtocol {
    static func customClassMapping() -> [String: String]
}

class SwiftDictModel {
 
    /// 单例
    static let sharedManager = SwiftDictModel()
    
    ///  讲字典转换成模型对象
    ///  :param: dict 数据字典
    ///  :param: cls  模型类
    ///  :returns: 类对象
    func objectWithDictionary(dict: NSDictionary, cls: AnyClass) ->AnyObject?{
        
        // 1. 取出模型字典
        let dictInfo = fullModelInfo(cls)
        
        // 实例化对象
        var obj: AnyObject = cls.alloc()
        
        // 2. 遍历模型字典, 有什么属性就设置什么属性
        for (k, v) in dictInfo {
            // 取出字典中的内容
            if let value: AnyObject? = dict[k] {
                
                // 判断是否是自定义类
                if v.isEmpty && !(value === NSNull()){
                    obj.setValue(value, forKey: k)
                } else {
                    let type = "\(value!.classForCoder)"
                    println("\(type)")
                    if type == "NSDictionary" {
                        // 字典
                        /// 递归
                        if let subObj: AnyObject? = objectWithDictionary(value as! NSDictionary, cls: NSClassFromString(v)) {
                            obj.setValue(subObj, forKey: k)
                        }
                    } else if type == "NSArray"{
         
                        // 数组
                        if let subObj: AnyObject? = objectWithArray(value as! NSArray, cls: NSClassFromString(v)) {
                            obj.setValue(subObj, forKey: k)
                        }
                    }
                }
            }
        }
        
        return obj
    }
    
    ///  数组转换成模型字典
    ///
    ///  :param: array 数组的描述
    ///  :param: cls   模型类
    ///
    ///  :returns: 模型字典
    func objectWithArray(array: NSArray, cls: AnyClass) -> [AnyObject]?{
        var result = [AnyObject]()
        for value in array {
            
            println("遍历数组\(value)")
            let type = "\(value.classForCoder)"
            
            if type == "NSDictionary" {
                if let subObj: AnyObject? = objectWithDictionary(value as! NSDictionary, cls: cls) {
                    result.append(subObj!)
                } else if type == "NSArray" {
                    if let subObj:AnyObject? = objectWithArray(value as! NSArray, cls: cls) {
                        result.append(subObj!)
                    }
                }

            }
        }

        return result
    }
    
    /// 缓存字典 格式[类名: 模型字典, 类名2: 模型字典]
    var modelCache = [String: [String: String]]()
    
    ///  获取模型类的完整信息(包含父类信息)
    func fullModelInfo(cls:AnyClass) -> [String:String]{
        
        // 判断类信息是否已经被缓存
        if let cache = modelCache["\(cls)"] {
            return cache
        }
        
        // 循环查找父类
        var currentCls: AnyClass = cls
        
        // 模型字典
        var dictInfo = [String: String]()
        
        while let parent: AnyClass = currentCls.superclass() {

            // 取出并且合并字典, 最终获取自己的属性以及父类的属性
            dictInfo.merge(modelInfo(currentCls))
//            println("\(dictInfo)")
            currentCls = parent
        }
        
        // 将模型信息写入缓存
        modelCache["\(cls)"] = dictInfo
        return dictInfo
    }
    
    
    // 获取给定类的信息
    func modelInfo(cls:AnyClass) -> [String: String]{
        var mapping:[String: String]?
        
        // 判断类信息是否已经被缓存
        if let cache = modelCache["\(cls)"] {
            return cache
        }
        
        // 判断是否遵守协议, 遵守就执行方法
        if cls.respondsToSelector("customClassMapping") {
            mapping = cls.customClassMapping()
        }
        
        
        var count: UInt32 = 0
        let ivars = class_copyIvarList(cls, &count)
        
        // 定义一个类信息的字典
        var dictInfo = [String: String]()
        
        // 获取每个属性的信息: 属性的名字, 类型
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let cname = ivar_getName(ivar)
            let name = String.fromCString(cname)!
            println("\(name)")
            let type = mapping?[name] ?? ""
            dictInfo[name] = type

        }
        free(ivars)
        // 将模型信息写入缓存
        modelCache["\(cls)"] = dictInfo
        
        return dictInfo
    }
}

extension Dictionary {

    /// 合并字典
    /// mutating 表示函数操作的字典是可变类型的
    /// 泛型(随便一个类型), 封装一些函数或者方法, 更加具有弹性
    /// 任何两个 [key: value] 类型匹配字典, 都可以进行合并操作
    mutating func merge<K, V>(dict:[K: V]) {
        for (k, v) in dict {
            // 字典的分类方法中, 如果要使用 updataValue 需要明确的指定类型
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}











