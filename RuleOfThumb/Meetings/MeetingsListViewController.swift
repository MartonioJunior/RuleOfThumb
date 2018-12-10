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
    
    var refreshControl = UIRefreshControl()
    var repository = AppDelegate.repository
    var allMettings = [Meeting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.refreshControl.tintColor = UIColor.pastelRed90
        self.refreshControl.attributedTitle = NSAttributedString(string: "Searching new meetings... ")
        
        meetingsListTableView.delegate = self
        meetingsListTableView.dataSource = self
        meetingsListTableView.refreshControl = refreshControl
        meetingsListTableView.register(
            UINib(nibName: "MeetingsListTableViewCell", bundle: nil), forCellReuseIdentifier: "meetingsListCell")
        
        self.refreshData(self)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBarTintColorWithGradient(colors: [UIColor.lightSalmon, UIColor.pale], size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))

    }
    
    @objc func refreshData(_ sender: Any) {
        self.repository.currentHouse { (house) in
            guard let house = house else {
                print("*ERROR* Could not find currentHouse in refreshData of MeetingsListViewController\n")
                return
            }
            
            print("-OK- Refreshing data from MeetingsListViewController\n")
            self.repository.fetchAllMeetings(from: house) { (meetings) in
                self.allMettings = meetings
                
                DispatchQueue.main.async {
                    self.meetingsListTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "create" {
            guard let navigationController = segue.destination as? UINavigationController,
                let destination = navigationController.viewControllers.first as? MeetingsCreateViewController else { return }
            destination.delegate = self
        } else if segue.identifier == "modal" {
            guard let destination = segue.destination as? SugestionViewController else { return }
            
            destination.modalImage = UIImage(named: "notification-feedback-illustration")!
            destination.modalTitle = "Your meeting was created!"
            destination.modalDescription = "We will now notify the other members of the house so that they are aware of the meeting."
            destination.firstButtonIsHidden = true
            destination.secondButtonTitle = "Yes, I'm sure"
        } else if segue.identifier == "details" {
            guard let destination = segue.destination as? MeetingsDetailViewController else { return }
            
            let meeting = sender as! Meeting
            destination.meeting = meeting
        }
    }
    
}

// - MARK: UITableViewDelegate, UITableViewDataSource protocols implementation.
extension MeetingsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMettings.count > 0 ? self.allMettings.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        guard self.allMettings.count > 0 else {
            let emptyCell = self.emptyCell()
            
            return emptyCell
        }
        
        let cell = self.meetingsListTableView.dequeueReusableCell(withIdentifier: "meetingsListCell") as? MeetingsListTableViewCell
        
        cell?.setupCell(with: allMettings[indexPath.row])
        
        return cell!
    }
    
    private func emptyCell() -> UITableViewCell {
        var cell = meetingsListTableView.dequeueReusableCell(withIdentifier: "emptyCell") as? MeetingsListEmptyTableViewCell
        
        if cell == nil {
            meetingsListTableView.register(UINib(nibName: "MeetingsListEmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCell")
            cell = meetingsListTableView.dequeueReusableCell(withIdentifier: "emptyCell") as? MeetingsListEmptyTableViewCell
        }
        
        cell?.statusLabel.text = "You don't have meetings today"
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self.allMettings[indexPath.row])
    }
}

// - MARK: MeetingsCreateDelegate protocol implementation.
extension MeetingsListViewController: MeetingsCreateDelegate {
    
    func proposedNewMeeting(_ meeting: Meeting) {
        self.allMettings.insert(meeting, at: 0)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "modal", sender: self)
        }
    }
    
}
