//
//  WallpaperModel.swift
//  Wallpaper
//
//  Created by TrungNV (Macbook) on 28/06/2023.
//

import UIKit
import SwiftyJSON

protocol JSONable{
    init?(parameter:JSON)
}

class WallpaperModel: JSONable {
    var imageUrl:String = ""
    required init(parameter :JSON) {
        imageUrl = parameter["paths"].stringValue
    }
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(parameter: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}
