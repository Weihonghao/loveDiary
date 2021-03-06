//
//  FBViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/18.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class FBViewController: UIViewController, FBSDKLoginButtonDelegate {
    //to have the facebook authorized login
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    let loginButton:FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    //display users' profile image loaded from facebook
    @IBOutlet weak var imageView: UIImageView!
    
    //display users' email loaded from facebook
    @IBOutlet weak var emailLabel: UILabel!
    
    //display users' first name loaded from facebook
    @IBOutlet weak var firstNameLabel: UILabel!
    
    //display users' last name loaded from facebook
    @IBOutlet weak var lastNameLabel: UILabel!
    
    
    var myFileSystem = MyFileSystem()
    var myDownload = DownloadItem()
    
    var initialFileNumber = 0
    
    // number to store and load image from file system
    var photoNumber: Int? {
        didSet{
            image = nil
            fetchImage()
        }
    }
    
    private var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
        }
    }
    
    private func fetchImage() {
        if let pNumber = photoNumber {
            let dir = "myFB/" + String(pNumber) + ".jpg"
            let imageURL = URL(fileURLWithPath: myFileSystem.getDir(dir))
            if true {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    let urlContents = try? Data(contentsOf: imageURL)
                    if let imageData = urlContents {
                        DispatchQueue.main.async {
                            self?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.center =  CGPoint(x: view.bounds.midX, y: view.bounds.maxY * 0.9)//view.center
        loginButton.delegate = self
        
        if (FBSDKAccessToken.current()) != nil {
            fetchProfile()
        }
        
        if myFileSystem.checkDirExist("mgFB") == false {
            myFileSystem.createDir("myFB")
        }
        
        initialFileNumber = myFileSystem.fileNumber("myFB")
        // Do any additional setup after loading the view.
    }
    
    // use faceboo SDK to get information
    func fetchProfile() {
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                return
            }
            
            if let userDictionary = result as? NSDictionary {
                
                self.emailLabel.text = userDictionary["email"] as? String
                self.firstNameLabel.text = userDictionary["first_name"] as? String
                self.lastNameLabel.text = userDictionary["last_name"] as? String
                if let picture = userDictionary["picture"] as? NSDictionary,
                    let data = picture["data"] as? NSDictionary,
                    let url = data["url"] as? String {
                    let webUrl = NSURL(string: url)
                    let tmpUrl = "myFB/" + String(self.myFileSystem.fileNumber("myFB")) + ".jpg"
                    let localUrl = self.myFileSystem.getDir(tmpUrl)
                    self.myDownload.load(url: webUrl as! URL, to: URL(fileURLWithPath: localUrl)) {
                        print("download succeed")
                    }
                    
                    
                    var tmpNumber = self.myFileSystem.fileNumber("myFB")
                    while tmpNumber == self.initialFileNumber {
                        sleep(UInt32(0.1))
                        tmpNumber = self.myFileSystem.fileNumber("myFB")
                    }
                    self.photoNumber = tmpNumber-1
                }
                
                
            }
        }
        
        
    }
    
    //when push login button
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("facebook login")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.emailLabel.text = nil
        self.firstNameLabel.text = nil
        self.lastNameLabel.text = nil
        self.imageView.image = nil
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //unwind segue
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        //print("try here")
        if let rootController = navigationController?.viewControllers.first as? FBViewController {
            if rootController == self {
                //print("true")
                return true
            }
        }
        //print("false")
        return false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
