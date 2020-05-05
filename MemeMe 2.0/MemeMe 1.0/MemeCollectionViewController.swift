//
//  MemeCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by Hanoudi on 5/3/20.
//  Copyright © 2020 Hanoudi. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{   // MARK:- Outlets & Variables
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    // MARK:- CollectionView LifeCyle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload data to stay in sync
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK:- CollectionView Delegate Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count == 0 ? displayNoMemes(true) : displayNoMemes(false)
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memeImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // present details when a cell containing a meme is selected
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
        
    // function to display no memes to inform user when none is yet made
    func displayNoMemes(_ bool: Bool) {
        if bool {
            // create a label programmatically taking into consideration screen size
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.frame.width, height: collectionView!.frame.height))
            label.numberOfLines = 4
            label.textAlignment = .center
            label.text = "No Memes were created to be stored! \nSelect '+' to create a new Meme. \nUse the tab bar below to present \neither grid view or list view."
            collectionView!.backgroundView = label

        } else {
            collectionView!.backgroundView = nil
        }
    }
    
}
