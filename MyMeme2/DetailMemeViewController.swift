//
//  DetailMemeViewController.swift
//  MemeMeVersion2.0
//
//  Created by Sean Goldsborough on 8/22/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    var detailMemes: Meme!
    
    var memesArray = [Meme]()
    
    var placeToDeleteMeme: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(DetailMemeViewController.myRightSideBarButtonItemTapped(_:)))
        
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        detailImageView.image = detailMemes.memedImage
        detailImageView.contentMode = .scaleAspectFit
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memesArray = appDelegate.arrayOfMemes
       
    }

    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
//        
//        let detailViewControler = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        
        
        
        (UIApplication.shared.delegate as! AppDelegate).arrayOfMemes.remove(at: placeToDeleteMeme)
        print("myRightSideBarButtonItemTapped")
        navigationController!.popViewController(animated: true)
        
        
    }
    
}
