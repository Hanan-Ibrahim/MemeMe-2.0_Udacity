//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by Hanoudi on 5/4/20.
//  Copyright © 2020 Hanoudi. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    // MARK:- Detail View Outlets & Variables
    @IBOutlet var memeDetailImage: UIImageView!
    var meme: Meme!
    
    // MARK:- Detail View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        memeDetailImage.image = meme.memeImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeDetailImage.image = meme.memeImage
        hideTabBar(bool: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(bool: false)
    }

    // MARK:- UI methods
    @IBAction func editAction(_ sender: Any) {
        let memeViewController = storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        memeViewController.memeSent = self.meme
        self.navigationController?.pushViewController(memeViewController, animated: true)
    }
    
    func hideTabBar(bool: Bool){
        self.tabBarController?.tabBar.isHidden = bool
    }
}
