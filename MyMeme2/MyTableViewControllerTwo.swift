//
//  MyTableViewControllerTwo.swift
//  MemeMeVersion2.0
//
//  Created by Sean Goldsborough on 8/22/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"



class MyTableViewControllerTwo: UIViewController, UITableViewDelegate, UITableViewDataSource {
     var tableViewMemes: [Meme] = []
    
    var array = [String]()
   
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "myArrayKey") as? [String] else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tableViewMemes = appDelegate.arrayOfMemes
        array = data
        tableView.reloadData()
          
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tableViewMemes = appDelegate.arrayOfMemes
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewMemes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let memes = self.tableViewMemes[indexPath.row]
        
        cell.textLabel?.text = "\(memes.topText)" + " " + "\(memes.bottomText)"
        //cell.detailTextLabel?.text = memes.bottomText
        cell.imageView?.image = memes.memedImage
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewControler = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        
       
        detailViewControler.detailMemes = self.tableViewMemes[indexPath.row]
        detailViewControler.placeToDeleteMeme = indexPath.row

        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            detailViewControler.detailMemes = tableViewMemes[selectedRow]
            print("Did Select at \(tableViewMemes[selectedRow])")
        }
  
        navigationController!.pushViewController(detailViewControler, animated: true)
        print("Did Select at \(tableViewMemes[(indexPath as NSIndexPath).row])")
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            (UIApplication.shared.delegate as! AppDelegate).arrayOfMemes.remove(at: indexPath.row)
            tableViewMemes.remove(at: indexPath.row)
   
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}





