//
//  RuleListViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 19/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        rulesTableView.delegate = self
        rulesTableView.dataSource = self
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        setRefreshControl()
        rulesTableView.refreshControl = refreshControl
        refreshData(self)
        registerForPreviewing(with: self, sourceView: rulesTableView)
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
                    destination.modalTitle = "Your rule has been proposed!"
                    destination.modalDescription = "Now all members of your house will vote for or against your rule. See in your board the status of the proposed rule."
                    destination.firstButtonIsHidden = true
                    destination.secondButtonTitle = "Alright"
                    break
                case .ruleApproved:
                    destination.modalTitle = "The rule has been approved!"
                    destination.modalDescription = "The rule got the majority of votes and now everyone must follow it"
                    destination.firstButtonIsHidden = true
                    destination.secondButtonTitle = "Alright"
                    break
                case .ruleRejected:
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
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Searching new rules...")
    }
    
    @objc func refreshData(_ sender: Any) {
        AppDelegate.repository.currentHouse { (house) in
            AppDelegate.repository.fetchAllRules(from: house, then: { (allRules) in
                DispatchQueue.main.async {
                    self.rules = allRules.filter {
                        return $0.status == Rule.Status.inForce
                    }
                    self.rulesInVoting = allRules.filter {
                        return $0.status == Rule.Status.voting
                    }
                    self.searchRules = self.rules
                    self.rulesTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
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
                return searchRules.count
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
        var cell = rulesTableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
        if cell == nil {
            rulesTableView.register(UINib(nibName: "RuleTableViewCell", bundle: nil), forCellReuseIdentifier: "rule")
            cell = rulesTableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
        }
        let rule = searchRules[indexPath.row]
        cell?.rule = rule
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                performSegue(withIdentifier: "detail", sender: searchRules[indexPath.row])
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
          return 130
        } else if indexPath.section == 1 { //Rule list
            return 100
        } else { // ?
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: (self.tableView(tableView, heightForHeaderInSection: section))) )
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.frame = headerView.frame
        switch section {
        case 0:
            titleLabel.text = "Vote opened"
            break
        case 1:
            titleLabel.text = "Rule List"
            break
        default:
            break
        }
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
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
        
        previewRule.preferredContentSize = CGSize(width: 0, height:  peekView.mainView.frame.height*3)
        
        return previewRule
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        performSegue(withIdentifier: "detail", sender: rules[highlightedIndex])
    }
    
    
}

// -- MARK: Rule Creation Delegate
extension RuleListViewController: RuleCreateDelegate {
    func proposedNewRule(_ rule: Rule) {
        rulesInVoting.insert(rule, at: 0)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "modal", sender: ModalType.ruleCreated)
            self.rulesTableView.reloadSections(IndexSet(integer: 0), with: .fade)
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
extension RuleListViewController: OpenVotesDelegate {
    func ruleUpvoted(rule: Rule) {
        rules.append(rule)
        searchRules.append(rule)
        rulesInVoting = rulesInVoting.filter {
            return $0.status == Rule.Status.voting
        }
        rulesTableView.reloadSections(IndexSet(integersIn: 0...1), with: .fade)
        performSegue(withIdentifier: "modal", sender: ModalType.ruleApproved)
    }
    
    func ruleDownvoted(rule: Rule) {
        rulesInVoting = rulesInVoting.filter {
            return $0.status == Rule.Status.voting
        }
        rulesTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        performSegue(withIdentifier: "modal", sender: ModalType.ruleRejected)
    }
}

// --MARK: Rule Archivation Delegate
extension RuleListViewController: RuleDetailDelegate {
    func ruleArchived(rule: Rule) {
        rule.status = .revoked
        AppDelegate.repository.save(rule: rule) { (rule) in
            DispatchQueue.main.async {
                self.rules = self.rules.filter {
                    return $0.status == Rule.Status.inForce
                }
                self.rulesInVoting = self.rulesInVoting.filter {
                    return $0.status == Rule.Status.voting
                }
                self.searchRules = self.rules
                self.rulesTableView.reloadSections(IndexSet(integersIn: 0...1), with: .fade)
            }
        }
    }
}
