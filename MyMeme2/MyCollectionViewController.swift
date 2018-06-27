//
//  MyCollectionViewController.swift
//  MemeMeVersion2.0
//
//  Created by Sean Goldsborough on 8/22/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//


import UIKit

private let reuseIdentifier = "Item"

class MyCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes = [Meme]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 4.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.arrayOfMemes
        collectionView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! MyCollectionViewCell

        let memes = self.memes[indexPath.row]
        
        item.memeImageView?.image = memes.memedImage
        return item

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewControler = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        
        detailViewControler.detailMemes = self.memes[indexPath.row]
        detailViewControler.placeToDeleteMeme = indexPath.row

        navigationController!.pushViewController(detailViewControler, animated: true)
        print("Did Select at \(memes[indexPath.row])")
        
    }      
}
