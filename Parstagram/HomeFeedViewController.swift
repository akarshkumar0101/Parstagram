//
//  HomeFeedViewController.swift
//  Parstagram
//
//  Created by Akarsh Kumar on 3/9/19.
//  Copyright © 2019 Akarsh Kumar. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var showsCommentBar = false
    
    let commentBar = MessageInputBar()
    
    var selectedPost: PFObject!
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func hideKeyboard(noti: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Post")
        query.includeKeys(["author", "comments", "comments.user"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section] as! PFObject
        let comments = post["comments"] as? [PFObject] ?? []
        
        // 2 for the post cell and the add comment cell
        return comments.count + 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject] ?? []
            
        if(indexPath.row == 0){
            let user = post["author"] as! PFUser
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
            
            cell.usernameLabel.text = user.username!
            
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            
            
            return cell
        }
        else if(indexPath.row <= comments.count){
            
            let comment = comments[indexPath.row - 1]
            //let user = comment["user"] as! PFUser
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
            
            //cell.usernameLabel.text = user.username
            cell.commentLabel.text = comment["text"] as? String
            cell.usernameLabel.text = (comment["user"] as? PFUser)?.username
            
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath)
            //let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell") // as! AddCommentCell
            return cell
        }
            
    }
    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        
        PFUser.logOut()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = loginViewController
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        
        let comment = PFObject(className: "Comment")
        comment["text"] = commentBar.inputTextView.text
        comment["post"] = selectedPost
        comment["user"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")

        selectedPost.saveInBackground { (success: Bool, error: Error?) in
            if(success){
                print("saved comment to post sucessfully")
                self.tableView.reloadData()
            }
            else{
                print("error saving comment")
                print(error!.localizedDescription)
            }
            
        }
        
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject] ?? []
        
        if(indexPath.row == comments.count+1){
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
        
//        let comment = PFObject(className: "Comment")
//        comment["text"] = "Cute af"
//        comment["post"] = post
//        comment["user"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground { (success: Bool, error: Error?) in
//            if(success){
//                print("saved comment to post sucessfully")
//            }
//            else{
//                print("error saving comment")
//                print(error!.localizedDescription)
//            }
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
