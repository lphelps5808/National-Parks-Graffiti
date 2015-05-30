//
//  PostsTableViewController.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/23/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import UIKit
import Kingfisher

private let __postsCellIdentifer = "customTableViewCellIdentifer"

class PostsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var lulz = false
    
    var dataSource = [GPost]()
    @IBOutlet weak var postPhotoView: UIImageView!
    @IBOutlet weak var PostLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if lulz == false {
            lulz = !lulz
            
            CameraHelper.presentCameraOnController(controller: self, delegate: self)
        }
        
    }
    
    func procurePosts() {
        APIManager.sharedInstance.procurePosts { (posts, error) -> () in
            if let posts = posts where error == nil {
                self.dataSource.extend(posts)
                self.tableView.reloadData()
            } else {
                println("Error!")
                // display UIAlertViewController
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    // what does the reuse Identifier do?
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(__postsCellIdentifer, forIndexPath: indexPath) as! CustomTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    func configureCell(cell: CustomTableViewCell, indexPath: NSIndexPath) {
        let post = dataSource[indexPath.row]
        cell.customCellLocationLabel.text = "\(post.coordinate.latitude), \(post.coordinate.longitude)"
        cell.customCellDateLabel.text = 
    }
    
    //MARK: - UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let start = CFAbsoluteTimeGetCurrent()
        
        let scaledImage = image.downsampledImage()
        AmazonHelper.sharedInstance.uploadImage(scaledImage, completion: { (success, error, fileName) -> () in
            if let fileName = fileName, location = LocationManager.sharedInstanceLM.myCurrentLocation where success == true {
                let post = GPost(coordinate: location.coordinate, imageString: AmazonHelper.urlStringForFileName(fileName), userID: "test", userName: "test", park: "test")
                APIManager.sharedInstance.submitPost(post, completion: { (success, error) -> () in
                    if success == true {
                        
                        // reload our table
                        self.procurePosts()
                        
                        println("this worked")
                    } else {
                        println("some fails")
                    }
                })
            } else {
                println("something bad happned")
            }
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
