//
//  TableViewController.swift
//  TableView With Confirmation
//
//  Created by Noah Wilder on 2018-02-27.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class Delete {
    var isTrue = false
    var expansion : SwipeExpansionStyle = .fill
    static let tapped = Delete()
}
class TableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let theme = UIColor.randomFlat
    /*
     Flat Colours:
     #FFCC02 *** Yellow
     #8EAF21
     #9A58B5
     #F47CC4
     #D35400
     #3498DB
     #D35B9D
     #2ECC70 * Mint
     #BF382A
     #8D43AD
     #745EC4
     #D85458
     #A6C63B *** Green

     
     
     
     
 */

    let deleteRed = #colorLiteral(red: 0.9914426208, green: 0.2377755642, blue: 0.1868577898, alpha: 1)
    var numberOfRows = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.00
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(theme.hexValue())
        title = "Delete Confirmation"
        
        
        let colour : UIColor = theme
        
        updateNavBar(with: colour)
        tableView.backgroundColor = colour
    }

    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(with colour: UIColor) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        
        let navBarColour = colour
        let contrastColour : UIColor = ContrastColorOf(colour, returnFlat: true)
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = contrastColour
        
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : contrastColour]
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : contrastColour]
        
        if navBar.tintColor.hexValue() == "#262626" {
           
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
    }

   
    @IBAction func addButtonPressed(_ sender: Any) {
        numberOfRows += 1
        self.tableView.reloadData()
    }
    
    
    
//MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.backgroundColor = theme.darken(byPercentage: CGFloat((Double(1) / Double(numberOfRows)) * Double(indexPath.row + 1)))
        cell.delegate = self
        
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//MARK: - Swipe Cell Datasource Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
       
        guard orientation == .right else { return nil }
        
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            self.confirmation { deleteTapped in
                if deleteTapped {
                    self.numberOfRows -= 1
                    action.fulfill(with: .delete)
                    
                    self.tableView.reloadData()
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    self.tableView.reloadData()
                    action.fulfill(with: .reset)
                }
            }
            
            // handle action by updating model with deletion
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "deleteIcon")
        deleteAction.backgroundColor = deleteRed
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .fill
   
        options.transitionStyle = .border
        return options
    }
    
    
    func confirmation(completion: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete the contents of the textfield?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
            alert.dismiss(animated: true, completion: nil)
            let deleteTapped = true
            completion(deleteTapped)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
            let deleteTapped = false
            completion(deleteTapped)
        }
        
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    
    
} // END OF CLASS

extension Int {
    func double() -> Double {
        return Double(self)
    }
}




