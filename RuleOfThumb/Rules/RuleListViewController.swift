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
}

class RuleListViewController: UIViewController {
    @IBOutlet weak var rulesTableView: UITableView!
    var rules = [MockRule]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        rulesTableView.delegate = self
        rulesTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        rules = Array(repeating: MockRule(title: "Dar bom dia para todos os membros da casa", description: "Com o intuito de aproximar o relacionamento dos membros do AP104, todos deverão dar bom dia assim que acordar"), count: 5)
        registerForPreviewing(with: self, sourceView: rulesTableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destination = segue.destination as! RuleDetailViewController
            let rule = sender as! MockRule
            destination.ruleTitle = rule.title
            destination.ruleDate = Date(timeIntervalSinceNow: 0)
            destination.ruleDescription = rule.description
            destination.ruleStatus = "Valendo"
        }
    }
    
    func source(forLocation location: CGPoint) -> RuleTableViewCell? {
        guard let indexPath = rulesTableView.indexPathForRow(at: location), let cell = rulesTableView.cellForRow(at: indexPath) as? RuleTableViewCell else {
            return nil
        }
        return cell
    }
    
    @IBAction func proposeRule(_ sender: UIBarButtonItem) {
        
    }
}

extension RuleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "RuleTableViewCell", bundle: nil), forCellReuseIdentifier: "rule")
            cell = tableView.dequeueReusableCell(withIdentifier: "rule") as? RuleTableViewCell
        }
        let rule = rules[indexPath.row]
        cell?.titleLabel.text = rule.title
        cell?.descriptionLabel.text = rule.description
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: rules[indexPath.row])
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
        titleLabel.text = "Lista de Regras"
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lista de Regras"
    }
}

extension RuleListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let displayInfo = source(forLocation: location), let peekView = Bundle.main.loadNibNamed("RulePeekView", owner: "self", options: nil)?.first as? RulePeekView else {
            return nil
        }
        previewingContext.sourceRect = displayInfo.frame
        
        peekView.ruleTitleLabel.text = displayInfo.titleLabel.text
        peekView.dateAuthorLabel.text = "Criada por Fulano ás 18:30"
        peekView.ruleDescriptionLabel.text = displayInfo.descriptionLabel.text
        
        let previewRule = UIViewController()
        previewRule.preferredContentSize = peekView.frame.size
        previewRule.view = peekView
        return previewRule
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: nil)
    }
    
    
}
