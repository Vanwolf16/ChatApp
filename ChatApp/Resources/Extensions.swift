//
//  Extensions.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    public var width:CGFloat{
        return self.frame.size.width
    }
    
    public var height:CGFloat{
        return self.frame.size.height
    }
    
    public var top:CGFloat{
        return self.frame.origin.y
    }
    
    public var bottom:CGFloat{
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left:CGFloat{
        return self.frame.origin.x
    }
    
    public var right:CGFloat{
        return self.width + self.frame.origin.y
    }
    
}
