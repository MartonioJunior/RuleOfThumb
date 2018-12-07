//
//  SugestionViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 27/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class SugestionViewController: UIViewController, SugestionModalViewDelegate {
    @IBOutlet weak var modalView: SugestionModalView!
    var modalImage: UIImage = UIImage()
    var modalTitle: String = ""
    var modalDescription: String = ""
    var firstButtonTitle: String = ""
    var secondButtonTitle: String = ""
    var firstButtonIsHidden: Bool = false
    var secondButtonIsHidden: Bool = false
    var leftAction: (()->Void)?
    var rightAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let modalView = modalView else { return }
        modalView.setModalImageView(modalImage)
        modalView.setTitleLabel(text: modalTitle)
        modalView.setDescriptionLabel(text: modalDescription)
        modalView.setFirstButtonTitle(text: firstButtonTitle)
        modalView.setSecondButtonTitle(text: secondButtonTitle)
        modalView.setFirstButtonHidden(hidden: firstButtonIsHidden)
        modalView.setSecondButtonHidden(hidden: secondButtonIsHidden)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        modalView.setDelegate(self)
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.layer.zPosition = -0
    }

    func pressedLeftButton() {
        popModalView(completion: leftAction)
    }
    
    func pressedRightButton() {
        popModalView(completion: rightAction)
    }
    
    func popModalView(completion: (()->Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
}
