//
//  ZwlTestPrefix.swift
//  TableViewTest
//
//  Created by Zouwanli on 2019/3/5.
//  Copyright © 2019 Zouwanli. All rights reserved.
//

import Foundation
import UIKit

/*
 * 屏幕宽宏定义
 */
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/*
 * 颜色宏定义
 */
public func ZwlRGBA(_ R:CGFloat,_ G:CGFloat ,_ B:CGFloat,_ A:CGFloat)-> UIColor?{
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}
