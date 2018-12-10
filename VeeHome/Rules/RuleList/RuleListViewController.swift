//
//  RuleListViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 19/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit
import WatchConnectivity

enum ModalType {
    case ruleCreated
    case ruleApproved
    case ruleRejected
}

class RuleListViewController: UIViewController {
    @IBOutlet weak var rulesTableView: UITableView!
    var rules = [Rule]()
    var searchRules = [Rule]()
    var rulesInVoting = [Rule]()
    var highlightedIndex = 0
    let searchController = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    var allRules = [Rule]() {
        didSet {
            RulesDict.all = []

            if allRules.count > 0 {
                for r in 0..<allRules.count {
                    if allRules[r].status == Rule.Status.inForce {
                        let date = allRules[r].validFrom
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let dateString = dateFormatter.string(from: date ?? Date())

                        RulesDict.all.append([
                            "name" : allRules[r].name,
                            "description" : allRules[r].description,
                            "creator" : allRules[r].creatorName,
                            "date" : dateString
                        ])
                    }
                }
            }
            
//            sendWatchMessage()
            
        }
    }
    
    //watchkit
    var lastMessage: CFAbsoluteTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rulesTableView.delegate = self
        rulesTableView.dataSource = self
        
        configSearchController()
        
        setRefreshControl()
        rulesTableView.refreshControl = refreshControl
        refreshData(self)
        
        registerForPreviewing(with: self, sourceView: rulesTableView)
        
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.setBarTintColorWithGradient(colors: [UIColor.lightSalmon, UIColor.pale], size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
        
        rulesTableView.backgroundColor = UIColor.clear
        
        searchBarInterfaceSetup()
        
        //Connect with apple watch
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBarTintColorWithGradient(colors: [UIColor.lightSalmon, UIColor.pale], size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
    }
    
    func configSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.pastelRed90
        searchController.searchBar.barTintColor = UIColor.blue
        definesPresentationContext = true
        searchController.searchBar.setBackgroundImage(UIImage().imageWithGradient(startColor : UIColor.red, endColor: UIColor.red, size: view.layer.bounds.size), for: .any, barMetrics: .default)
        
        var searchTextField: UITextField? = searchController.searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor.white]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributeDict)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            guard let destination = segue.destination as? RuleDetailViewController else { return }
            let rule = sender as! Rule
            destination.rule = rule
            destination.delegate = self
            destination.delegate = self
        } else if segue.identifier == "create" {
            guard let navigationController = segue.destination as? UINavigationController, let destination = navigationController.viewControllers.first as? RuleCreateViewController else { return }
            destination.delegate = self
        } else if segue.identifier == "modal" {
            guard let destination = segue.destination as? SugestionViewController, let modalType = sender as? ModalType else { return }
            switch modalType {
                case .ruleCreated:
                    destination.modalImage = UIImage(named: "voting-feedback-illustration")!
                    destination.modalTitle = "Your rule has been proposed!"
                    destination.modalDescription = "Now all members of your house will vote for or against your rule. See in your board the status of the proposed rule."
                    destination.firstButtonIsHidden = true
                    destination.secondButtonTitle = "Alright"
                    break
                case .ruleApproved:
                    destination.modalImage = UIImage(named: "approved-feedback-illustration")!
                    destination.modalTitle = "The rule has been approved!"
                    destination.modalDescription = "The rule got the majority of votes and now everyone must follow it"
                    destination.firstButtonIsHidden = true
                    destination.secondButtonTitle = "Alright"
                    break
                case .ruleRejected:
                    destination.modalImage = UIImage(named: "notification-feedback-illustration")!
                    destination.modalTitle = "The rule has been rejected!"
                    destination.modalDescription = "Sorry, but the house doesn't agree with the rule. Talk to the other members to know what's going on."
                    destination.firstButtonIsHidden = true
                    destination.secondButtonTitle = "Alright"
                    break
            }
        }
    }
    
    func source(forLocation location: CGPoint) -> RuleTableViewCell? {
        guard let indexPath = rulesTableView.indexPathForRow(at: location), let cell = rulesTableView.cellForRow(at: indexPath) as? RuleTableViewCell else {
            return nil
        }
        return cell
    }
    
    func setRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.pastelRed90
        refreshControl.attributedTitle = NSAttributedString(string: "Searching new rules...")
    }
    
    @objc func refreshData(_ sender: Any) {
        AppDelegate.repository.currentHouse { (house) in
            // FIXME: Tratar isso é uma boa.
            guard let house = house else {
                print("*ERROR* Could not find currentHouse in refreshData of RuleListViewController\n")
                return
            }
            
            print("-OK- Refreshing data from RuleListViewController\n")
            AppDelegate.repository.fetchAllRules(from: house, then: { (allRules) in
                self.allRules = allRules
                DispatchQueue.main.async {
                    self.updateRuleList()
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    func updateRuleList() {
        self.rules = self.allRules.filter {
            return $0.status == Rule.Status.inForce
        }
        self.rulesInVoting = self.allRules.filter {
            return $0.status == Rule.Status.voting
        }
        self.searchRules = self.rules
        DispatchQueue.main.async {
            self.rulesTableView.reloadSections(IndexSet(integersIn: 0...1), with: .fade)
        }
    }
    
    private func searchBarInterfaceSetup() {
        if #available(iOS 11.0, *) {
            let scb = searchController.searchBar
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.almostWhite
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.05)
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
        }
    }
    
    
    

}

// - MARK: TableView Delegate & Data Source
extension RuleListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return searchRules.count > 0 ? searchRules.count : 1
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return createOpenVotesCollection()
        case 1:
            return createRuleCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func createOpenVotesCollection() -> UITableViewCell {
        var cell = rulesTableView.dequeueReusableCell(withIdentifier: "allVotations") as? OpenVotesTableViewCell
        if cell == nil {
            rulesTableView.register(UINib(nibName: "OpenVotesTableViewCell", bundle: nil), forCellReuseIdentifier: "allVotations")
            cell = rulesTableView.dequeueReusableCell(withIdentifier: "allVotations") as? OpenVotesTableViewCell
        }
        cell?.data = rulesInVoting
        cell?.delegate = self
        cell?.reloadData()
        registerForPreviewing(with: cell!, sourceView: cell!.votesView)
        return cell!
    }
    
    func createRuleCell(indexPath: IndexPath) -> UITableViewCell {
        
        if searchRules.count > 0 {
            var cell = rulesTableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
            if cell == nil {
                rulesTableView.register(UINib(nibName: "RuleTableViewCell", bundle: nil), forCellReuseIdentifier: "rule")
                cell = rulesTableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            let rule = searchRules[indexPath.row]
            cell?.rule = rule
            return cell!
        } else {
            var cell = rulesTableView.dequeueReusableCell(withIdentifier: "emptyRule") as? RuleEmptyTableViewCell
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if cell == nil {
                rulesTableView.register(UINib(nibName: "RuleEmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyRule")
                cell = rulesTableView.dequeueReusableCell(withIdentifier: "emptyRule") as? RuleEmptyTableViewCell
            }
            
            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                var cell = rulesTableView.cellForRow(at: indexPath) as? RuleTableViewCell
                
//                UIView.animate(withDuration: 0.3, animations: {
//                    cell?.cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                }, completion: nil)
                
                if indexPath.row < searchRules.count {
                    performSegue(withIdentifier: "detail", sender: searchRules[indexPath.row])
                }
                break
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        case 1:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        highlightedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { //Vote opened
          return 134
        } else if indexPath.section == 1 { //Rule list
            return 145
        } else { // ?
            return 145
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = rulesTableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderCell
        
        if headerCell == nil {
            rulesTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
            headerCell = rulesTableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderCell
        }

        switch section {
        case 0:
             headerCell?.headerTitleLabel.text = "Vote opened"
            break
        case 1:
             headerCell?.headerTitleLabel.text = "Rule List"
            break
        default:
            break
            
        }
        
        return headerCell?.contentView
    }
    

}

// - MARK: Peek and Pop
extension RuleListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let displayInfo = source(forLocation: location) else {
            return nil
        }
        previewingContext.sourceRect = displayInfo.frame
        
        let peekView = RulePeekView()
        peekView.rule = displayInfo.rule
        
        let previewRule = ActionlessRuleDetailViewController()
        previewRule.view.addSubview(peekView)
        
        previewRule.preferredContentSize = CGSize(width: 0, height:  peekView.mainView.frame.height/2)
        
        return previewRule
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        performSegue(withIdentifier: "detail", sender: rules[highlightedIndex])
    }
    
    
}

// -- MARK: Rule Creation Delegate
extension RuleListViewController: RuleCreateDelegate {
    func proposedNewRule(_ rule: Rule) {
        allRules.insert(rule, at: 0)
        updateRuleList()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "modal", sender: ModalType.ruleCreated)
        }
    }
}

// -- MARK: Search Bar Delegate
extension RuleListViewController: UISearchBarDelegate {
    func search(argument: String?) {
        guard let argument = argument else {
            self.searchRules = self.rules
            return
        }
        self.searchRules = self.rules.filter({
            return $0.name.lowercased().contains(argument.lowercased())
        }).sorted(by: { (r1, r2) -> Bool in
            return r2.name.lowercased().hasPrefix(argument.lowercased())
        })
        rulesTableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
        searchBar.text = nil
        self.search(argument: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.search(argument: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search(argument: searchText)
    }
}

// --MARK: Rule List View Controller Delegate
extension RuleListViewController: RuleListDelegate {
    func replaceRule(rule: Rule) {
        guard let index = allRules.firstIndex(where: {
            return $0.recordName == rule.recordName
        }) else {
            return
        }
        allRules[index] = rule
        updateRuleList()
    }
    
    func removeRule(rule: Rule) {
        guard let index = allRules.firstIndex(where: {
            return $0.recordName == rule.recordName
        }) else {
            return
        }
        allRules.remove(at: index)
        updateRuleList()
    }
    
    func ruleVoting(rule: Rule) {
        replaceRule(rule: rule)
    }
    
    func ruleInForce(rule: Rule) {
        replaceRule(rule: rule)
        DispatchQueue.main.sync {
            self.performSegue(withIdentifier: "modal", sender: ModalType.ruleApproved)
        }
    }
    
    func ruleRevoked(rule: Rule) {
        replaceRule(rule: rule)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "modal", sender: ModalType.ruleRejected)
        }
    }
}

// --MARK: Rule Archivation Delegate
extension RuleListViewController: RuleDetailDelegate {
    func ruleArchived(rule: Rule) {
        rule.status = .revoked
        removeRule(rule: rule)
        
        AppDelegate.repository.save(rule: rule) { (rule) in
            
        }
        
        
    }
}

extension RuleListViewController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        self.sendWatchMessage()
    }
    
    func sendWatchMessage() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        if (WCSession.default.isReachable) {
            let message = ["message": RulesDict.all]
            WCSession.default.sendMessage(message, replyHandler: nil)
        } else {
            print("Apple Watch not reachable.")
        }
        
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
}
