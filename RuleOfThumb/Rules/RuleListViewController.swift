//
//  RuleListViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 19/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

struct MockRule {
    var title: String
    var description: String
    var author: String
    var date: Date
    var status: String
}

class RuleListViewController: UIViewController {
    @IBOutlet weak var rulesTableView: UITableView!
    var rules = [MockRule]()
    var highlightedIndex = 0
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        rulesTableView.delegate = self
        rulesTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        rules = Array(repeating: MockRule(title: "Dar bom dia para todos os membros da casa", description: "Com o intuito de aproximar o relacionamento dos membros do AP104, todos deverão dar bom dia assim que acordar", author: "Anne", date: Date(), status: "Valendo"), count: 5)
        registerForPreviewing(with: self, sourceView: rulesTableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            guard let destination = segue.destination as? RuleDetailViewController else { return }
            let rule = sender as! MockRule
            destination.rule = rule
        } else if segue.identifier == "create" {
            guard let navigationController = segue.destination as? UINavigationController, let destination = navigationController.viewControllers.first as? RuleCreateViewController else { return }
            destination.delegate = self
        }
    }
    
    func source(forLocation location: CGPoint) -> RuleTableViewCell? {
        guard let indexPath = rulesTableView.indexPathForRow(at: location), let cell = rulesTableView.cellForRow(at: indexPath) as? RuleTableViewCell else {
            return nil
        }
        return cell
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
                return rules.count
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
        cell?.data = rules
        cell?.reloadData()
        return cell!
    }
    
    func createRuleCell(indexPath: IndexPath) -> UITableViewCell {
        var cell = rulesTableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
        if cell == nil {
            rulesTableView.register(UINib(nibName: "RuleTableViewCell", bundle: nil), forCellReuseIdentifier: "rule")
            cell = rulesTableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
        }
        let rule = rules[indexPath.row]
        cell?.rule = rule
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                performSegue(withIdentifier: "detail", sender: rules[indexPath.row])
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.tableView(tableView, heightForHeaderInSection: section)))
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.frame = headerView.frame
        switch section {
        case 0:
            titleLabel.text = "Vote opened"
            break
        case 1:
            titleLabel.text = "Lista de Regras"
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
        
        let previewRule = UIViewController()
        previewRule.preferredContentSize = peekView.frame.size
        previewRule.view = peekView
        return previewRule
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        performSegue(withIdentifier: "detail", sender: rules[highlightedIndex])
    }
}

extension RuleListViewController: RuleCreateDelegate {
    func proposedNewRule(_ rule: MockRule) {
        rules.insert(rule, at: 0)
        rulesTableView.reloadData()
    }
}
