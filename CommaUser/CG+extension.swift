//
//  CG+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 17/1/20.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit


func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize.init(width: width, height: height)
}

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect.init(x: x, y: y, width: width, height: height)
}

func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint.init(x: x, y: y)
}


let MaxTranslucentAlpha: CGFloat = 0.998

extension CGFloat {
    
    var reH: CGFloat {
        return Layout.ScreenHeight / Layout.height_4_7_inch * self
    }
    
    var reW: CGFloat {
        return Layout.ScreenWidth / Layout.width_4_7_inch * self
    }
    
    var reH_less_4_7: CGFloat {
        if Layout.ScreenHeight >= Layout.height_4_7_inch {
            return self
        }
        return Layout.ScreenHeight / Layout.height_4_7_inch * self
    }
    
    var reW_less_4_7: CGFloat {
        if Layout.ScreenWidth >= Layout.width_4_7_inch {
            return self
        }
        return Layout.ScreenWidth / Layout.width_4_7_inch * self
    }
    
    // 非按照比例，而是放大1.5倍
    var reH_over_4_7: CGFloat {
        return Layout.ScreenHeight <= Layout.height_4_7_inch ? self : Layout.ScreenHeight / Layout.height_4_7_inch * self * 1.5
    }
    
    // 非按照比例，而是放大1.5倍
    var reW_over_4_7: CGFloat {
       return Layout.ScreenWidth <= Layout.width_4_7_inch ? self : Layout.ScreenWidth / Layout.width_4_7_inch * self * 1.5
    }
}

extension Double {
    
    var reH: CGFloat {
        return Layout.ScreenHeight / Layout.height_4_7_inch * CGFloat(self)
    }
    
    var reW: CGFloat {
        return Layout.ScreenWidth / Layout.width_4_7_inch * CGFloat(self)
    }
    
    var reH_less_4_7: CGFloat {
        if Layout.ScreenHeight >= Layout.height_4_7_inch {
            return CGFloat(self)
        }
        return Layout.ScreenHeight / Layout.height_4_7_inch * CGFloat(self)
    }
    
    var reW_less_4_7: CGFloat {
        if Layout.ScreenWidth >= Layout.width_4_7_inch {
            return CGFloat(self)
        }
        return Layout.ScreenWidth / Layout.width_4_7_inch * CGFloat(self)
    }
    
    // 非按照比例，而是放大1.5倍
    var reH_over_4_7: CGFloat {
        return Layout.ScreenHeight <= Layout.height_4_7_inch ? CGFloat(self) : Layout.ScreenHeight / Layout.height_4_7_inch * CGFloat(self) * 1.5
    }
    
    // 非按照比例，而是放大1.5倍
    var reW_over_4_7: CGFloat {
        return Layout.ScreenWidth <= Layout.width_4_7_inch ? CGFloat(self) : Layout.ScreenWidth / Layout.width_4_7_inch * CGFloat(self) * 1.5
    }
}

extension Int {
    
    var reH: CGFloat {
        return Layout.ScreenHeight / Layout.height_4_7_inch * CGFloat(self)
    }
    
    var reW: CGFloat {
        return Layout.ScreenWidth / Layout.width_4_7_inch * CGFloat(self)
    }
    
    var reH_less_4_7: CGFloat {
        if Layout.ScreenHeight >= Layout.height_4_7_inch {
            return CGFloat(self)
        }
        return Layout.ScreenHeight / Layout.height_4_7_inch * CGFloat(self)
    }
    
    var reW_less_4_7: CGFloat {
        if Layout.ScreenWidth >= Layout.width_4_7_inch {
            return CGFloat(self)
        }
        return Layout.ScreenWidth / Layout.width_4_7_inch * CGFloat(self)
    }
    
    // 非按照比例，而是放大1.5倍
    var reH_over_4_7: CGFloat {
        return Layout.ScreenHeight <= Layout.height_4_7_inch ? CGFloat(self) : Layout.ScreenHeight / Layout.height_4_7_inch * CGFloat(self) * 1.5
    }
    
    // 非按照比例，而是放大1.5倍
    var reW_over_4_7: CGFloat {
        return Layout.ScreenWidth <= Layout.width_4_7_inch ? CGFloat(self) : Layout.ScreenWidth / Layout.width_4_7_inch * CGFloat(self) * 1.5
    }
}
