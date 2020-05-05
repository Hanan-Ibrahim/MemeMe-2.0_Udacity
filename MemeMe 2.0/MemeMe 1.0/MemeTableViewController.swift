//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by Hanoudi on 5/3/20.
//  Copyright © 2020 Hanoudi. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController{
    // MARK:- Variables
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK:- TableView Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // to ensure data is updated everytime the view appears
        tableView.reloadData()
    }
    
    // to fix row height
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 110
    }
    
    
    // MARK:- Table methods
    // We need only one section for all sent memes.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // function to display no memes to show when none is yet made
    func displayNoMemes(_ bool: Bool) {
        if bool {
            // create a label programmatically taking into consideration screen size
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            label.numberOfLines = 4
            label.textAlignment = .center
            label.text = "No Memes were created to be stored! \nSelect '+' to create a new Meme. \nUse the tab bar below to present \neither grid view or list view."
            tableView.separatorStyle = .none
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    // For every meme, we need a row, count array items.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count == 0 ? displayNoMemes(true) : displayNoMemes(false)
        return memes.count
    }
    
    // Contents to display in table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeTableImage.image = meme.memeImage
        cell.memeTableLabel.text = ("Top: " + meme.topText + ", Bottom: " + meme.bottomText)
        return cell
    }
    
    // When a meme is selected in any row - > Details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeView = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeView.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeView, animated: true)
    }    
}
