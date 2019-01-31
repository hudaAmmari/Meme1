//
//  SentMemeTableViewController.swift
//  MemeMe1
//
//  Created by Huda  on 13/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController:  UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.imgView?.image = meme.memedImage
        cell.labelText?.text = meme.topText + " ... " + meme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewMeme = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        viewMeme.memes = self.memes[indexPath.row]
        self.navigationController?.pushViewController(viewMeme, animated: true)
    }

}
