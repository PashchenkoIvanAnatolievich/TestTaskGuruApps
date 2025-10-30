//
//  AdaptiveService.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import Foundation
import UIKit

class AdaptiveService {
    static func getAdaptiveWidth(_ width: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let designWidth: CGFloat = 375
        
        let ratio = screenWidth / designWidth
        
        return width * ratio
    }
    
    static func getAdaptiveHeight(_ height: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let designHeight: CGFloat = 812
        
        let ratio = screenHeight / designHeight
        
        return height * ratio
    }
}
