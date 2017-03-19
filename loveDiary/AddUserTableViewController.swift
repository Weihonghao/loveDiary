//
//  AddUserTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/13.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Contacts
import ContactsUI
//methods when we try to add users to Core Data and contact books
class AddUserTableViewController: UITableViewController, UNUserNotificationCenterDelegate,CNContactPickerDelegate, UITextFieldDelegate {
    
    
    
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    //for contactkit usage
    var contactStore = CNContactStore()
    var selectedContact: CNContact = CNContact()
    
    
    func handleAlert(first titleInput: String, second messageInput: String) {
        let alert = UIAlertController(
            title: titleInput,
            message: messageInput,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil))
        //alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
    }
    
    //Input and display users' name
    @IBOutlet weak var userNameLabel: UITextField!
    //Input and display users' tweet screenName
    @IBOutlet weak var tweetNameLabel: UITextField!
    //Input and display users' phone number
    @IBOutlet weak var PhoneNumberLabel: UITextField!
    //Input and display users' email address
    @IBOutlet weak var EmailLabel: UITextField!
    
    //use contact picker here
    @IBAction func showAllContact(_ sender: UIButton) {
        let controller = CNContactPickerViewController()
        controller.delegate = self
        navigationController?.present(controller,animated: true, completion: nil)
        
    }
    
    
    //different from showing all users from contact picker, we highlight the search results in the contact books
    @IBAction func enabelSelect(_ sender: UIButton) {
        
        let controller = CNContactPickerViewController()
        controller.delegate = self
        let formatString = "givenName BEGINSWITH '" + (userNameLabel.text ?? "") + "'"
        controller.predicateForEnablingContact =
            NSPredicate(format:
                formatString,
                        argumentArray: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        self.selectedContact = contact
    }
    
    //save the current user into contact book
    @IBAction func SaveContact(_ sender: UIButton) {
        let userAdded = CNMutableContact()
        //user's given name
        userAdded.givenName = userNameLabel.text!
        //user's home phone number
        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: PhoneNumberLabel.text!))
        userAdded.phoneNumbers = [homePhone]
        //user's hone email address
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: EmailLabel.text! as NSString)
        userAdded.emailAddresses = [homeEmail]
        // In my iphone bought in China, insert tweet account is forbidden
        // On simulator, it works fine
        /*let twitterProfile = CNLabeledValue(label: "Twitter", value:CNSocialProfile(urlString: nil, username: (tweetNameLabel.text! as NSString) as String, userIdentifier: nil, service: CNSocialProfileServiceTwitter))
         fooBar.socialProfiles = [twitterProfile]*/
        userAdded.note  = "Love you"
        let request = CNSaveRequest()
        request.add(userAdded, toContainerWithIdentifier: nil)
        do{
            //create a local notification telling users that one entry in contact book has been created
            try contactStore.execute(request)
            print("Successfully stored the contact")
            
            let content = UNMutableNotificationContent()
            content.title = "Contact kit application"
            content.body = "You just add" + userNameLabel.text! + " to your Iphone contact list"
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "reminder"
            // Deliver the notification in five seconds.
            //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: nil)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
        } catch let err{
            print("Failed to save the contact. \(err)")
        }
        
    }
    
    
    
    //search whether user in contact book and return the results in alert
    @IBAction func SearchContact(_ sender: UIButton) {
        
        /*contactStore.requestAccess(for: .contacts){succeeded, err in
         guard err == nil && succeeded else{
         return
         }*/
        
        let predicate = CNContact.predicateForContacts(matchingName: self.userNameLabel.text!)
        let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
        //let toFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        //OperationQueue().addOperation{[unowned contactStore] in
        do{
            let contacts = try self.contactStore.unifiedContacts(
                matching: predicate, keysToFetch: toFetch as [CNKeyDescriptor])
            
            /*for contact in contacts{
             print("contact here")
             print(contact.givenName)
             print(contact.familyName)
             print(contact.identifier)
             }*/
            
            if contacts.count > 0 {
                //tweetNameLabel.text = contacts[0].socialProfiles.first?.value.username
                //tweetNameLabel.text = contacts.first?.phoneNumbers.first?.value(forKey: "digits") as! String
                //let MobNumVar = ((contacts.first?.phoneNumbers[0].value)! as CNPhoneNumber).value(forKey: "digits") as! String
                //print(MobNumVar)
                
                //print(CNContactFormatter.string(from: contacts.first!, style: .fullName))
                /*for contact in contacts {
                 for email in contact.emailAddresses {
                 let _ = email.value as String
                 }
                 }*/
                self.handleAlert(first: "User Found", second: "You find this user in your contact book")
            } else {
                self.handleAlert(first: "User Not Found", second: "No such user in your contact book")
            }
            
        } catch let err{
            print(err)
        }
        //}
        
    }
    
    
    @IBAction func updateContact(_ sender: UIButton) {
        let predicate = CNContact.predicateForContacts(matchingName: userNameLabel.text!)
        let toFetch = [CNContactEmailAddressesKey]
        
        do{
            let contact = try contactStore.unifiedContacts(matching: predicate,
                                                           keysToFetch: toFetch as [CNKeyDescriptor])
            let userAdded = contact.first?.mutableCopy() as! CNMutableContact
            //fooBar.givenName = userNameLabel.text!
            let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: PhoneNumberLabel.text!))
            userAdded.phoneNumbers = [homePhone]
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: EmailLabel.text! as NSString)
            userAdded.emailAddresses = [homeEmail]
            let twitterProfile = CNLabeledValue(label: "Twitter", value:CNSocialProfile(urlString: nil, username: (tweetNameLabel.text! as NSString) as String, userIdentifier: nil, service: CNSocialProfileServiceTwitter))
            userAdded.socialProfiles = [twitterProfile]
            userAdded.note  = "Update you, still love you"
            let request = CNSaveRequest()
            request.add(userAdded, toContainerWithIdentifier: nil)
            do{
                try contactStore.execute(request)
                print("Successfully stored the contact")
                
                let content = UNMutableNotificationContent()
                content.title = "Contact kit application"
                content.body = "You just update" + userNameLabel.text! + " to your Iphone contact list"
                content.sound = UNNotificationSound.default()
                content.categoryIdentifier = "reminder"
                // Deliver the notification in five seconds.
                //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: nil)
                
                let center = UNUserNotificationCenter.current()
                center.add(request)
                
            } catch let err{
                print("Failed to update first the contact. \(err)")
            }
            
        }
        catch let err{
            print("Failed to update the contact. \(err)")
        }
    }
    
    //delete the user in contact books
    @IBAction func deleteContact(_ sender: UIButton) {
        OperationQueue().addOperation{[unowned contactStore] in
            let predicate = CNContact.predicateForContacts(matchingName: self.userNameLabel.text!)
            let toFetch = [CNContactEmailAddressesKey]
            
            do{
                
                let contacts = try contactStore.unifiedContacts(matching: predicate,
                                                                keysToFetch: toFetch as [CNKeyDescriptor])
                
                guard contacts.count > 0 else{
                    print("No contacts found")
                    return
                }
                
                //only do this to the first contact matching our criteria
                guard let contact = contacts.first else{
                    return
                }
                
                let req = CNSaveRequest()
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                req.delete(mutableContact)
                
                do{
                    //create a notification telling user that deletion succeeds
                    try contactStore.execute(req)
                    DispatchQueue.main.async {
                        self.handleAlert(first: "delete users", second: "Successfully deleted the user")
                    }
                    print("Successfully deleted the user")
                    
                } catch let e{
                    DispatchQueue.main.async {
                        self.handleAlert(first: "delete users", second: "Error = \(e)")
                    }
                    print("Error = \(e)")
                }
                
            } catch let err{
                print(err)
            }
        }
    }
    
    //for notification, when user create a new user for core data
    @IBAction func submitRegister(_ sender: UIButton) {
        updateUser()
        print("notification notification")
        let content = UNMutableNotificationContent()
        content.title = "New User"
        content.body = "You just add a new user"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "reminder"
        // Deliver the notification in five seconds.
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: nil)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EmailLabel.delegate = self
        self.userNameLabel.delegate = self
        self.tweetNameLabel.delegate = self
        self.PhoneNumberLabel.delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            print("authorized hahaha")
        case .notDetermined:
            contactStore.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
                print("notdetermined")
            }
        default:
            print("Not handled")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    private func updateUser() {
        let userName = userNameLabel.text  as NSString?
        let tweetName = tweetNameLabel.text as NSString?
        
        
        let userDict : NSDictionary = NSDictionary(objects: [userName, tweetName] as [NSString?], forKeys: ["screen_name", "tweet_name"] as [NSString])
        if userNameLabel.text != Optional("") {
            updateDatabase(with: User(data: userDict)!, for: userName!)
        }
        
    }
    
    
    
    private func updateDatabase(with user: User, for query: NSString) {
        container?.performBackgroundTask { [weak self] context in
            let _ = try? UserData.findOrCreateUser(matching: user, in: context, recent: query as String)
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    
    //print information to see whther CoreData updated successfully
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                
                if let userCount = try? context.count(for: UserData.fetchRequest()) {
                    print("\(userCount) users")
                }
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //updateUser()
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //go back to the search page when trigger hashtag and userMentioned
        if let _ = destinationViewController as? AddDataTableViewController, let _ = sender as? UITableViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "backToNewDiary" {
                print("prepare success")
                //searchViewController.nameLabel.text = currentCell.userNameLabel.text
            }
        }
    }
    
}
