//
//  MeetingsViewController.swift
//  RuleOfThumb
//
//  Created by Paulo José on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class MeetingsListViewController: UIViewController {
    
    @IBOutlet weak var meetingsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingsListTableView.delegate = self
        meetingsListTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBarTintColorWithGradient(colors: [UIColor.lightSalmon, UIColor.pale], size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))

        // Do any additional setup after loading the view.
    }
    
}

extension MeetingsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = meetingsListTableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderMeetingsTableViewCell
        
        if headerCell == nil {
            meetingsListTableView.register(UINib(nibName: "HeaderMeetingsTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
            headerCell = meetingsListTableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderMeetingsTableViewCell
        }
        
        headerCell?.titleLabel.text = "Today"
        
        return headerCell?.contentView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = meetingsListTableView.dequeueReusableCell(withIdentifier: "emptyCell") as? MeetingsListEmptyTableViewCell
        
        if cell == nil {
            meetingsListTableView.register(UINib(nibName: "MeetingsListEmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCell")
            cell = meetingsListTableView.dequeueReusableCell(withIdentifier: "emptyCell") as? MeetingsListEmptyTableViewCell
        }
        
        cell?.statusLabel.text = "You don't have meetings today"
        
        return cell!
    }
    
}
