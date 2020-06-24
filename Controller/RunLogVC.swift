//
//  SecondViewController.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/22/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class RunLogVC: UIViewController {

    @IBOutlet weak var runLogTableView: UITableView!
    
    var runs = Run.getAllRuns()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        runs = Run.getAllRuns()
        runLogTableView.reloadData()
    }


}

extension RunLogVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return runs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RunLogCell", for: indexPath) as? RunLogCell else { return UITableViewCell()}
        
        guard let run = runs?[indexPath.row] else {return UITableViewCell()}
        
        cell.customizeCell(run: run)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            if let delrun = self.runs?[indexPath.row]{
                Run.deleteRun(run: delrun)
                tableView.reloadData()
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
}
