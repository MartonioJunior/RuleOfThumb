//
//  UIFont.swift
//  RuleOfThumb
//
//  Created by Paulo José on 30/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

extension UIFont {
    
    class var promptStyle: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 22.0)!
    }
    
    class var itemTitle: UIFont {
        return UIFont(name: "Nunito-Regular", size: 17.0)!
    }
    
    class var terciaryText: UIFont {
        return UIFont(name: "Lato-Light", size: 14.0)!
    }
    
    class var secondaryText: UIFont {
        return UIFont(name: "Lato-Regular", size: 15.0)!
    }
    
    class var actionText: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 17.0)!
    }
    
    class var sectionText: UIFont {
        return UIFont(name: "Nunito-ExtraBold", size: 20.0)!
    }
    
    class var primaryText: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 17.0)!
    }
    
    class var detailsHeader: UIFont {
        return UIFont(name: "Nunito-Bold", size: 22.0)!
    }
    
    class var largeActionText: UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: .bold)
    }
    
    class var primaryTextCentralized: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 17.0)!
    }
    
    class var terciaryTextCentralized: UIFont {
        return UIFont(name: "Lato-Light", size: 14.0)!
    }
    
    class var secondaryTextCentralized: UIFont {
        return UIFont(name: "Lato-Regular", size: 15.0)!
    }
    
}
