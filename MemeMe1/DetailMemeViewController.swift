//
//  DetailMemeViewController.swift
//  MemeMe1
//
//  Created by Huda  on 13/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {

    
    var memes: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        imageView.image = memes.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
}
