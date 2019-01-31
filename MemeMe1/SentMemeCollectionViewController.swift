//
//  SentMemeCollectionViewController.swift
//  MemeMe1
//
//  Created by Huda  on 13/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
  
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.item]
        
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewMeme = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        viewMeme.memes = self.memes[indexPath.item]
        self.navigationController!.pushViewController(viewMeme, animated: true)
    }

}
