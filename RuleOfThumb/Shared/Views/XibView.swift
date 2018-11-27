//
//  XibView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class XibView: UIView {
    @IBOutlet var contentView: UIView!
    
    var nibName: String {
        get {
            return ""
        }
    }
    var owner: XibView {
        get {
            return self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
