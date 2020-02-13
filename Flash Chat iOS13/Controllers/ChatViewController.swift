//
//  ChatViewController.swift
//  Flash Chat iOS13
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = Constants.appName
        
        //Registering the Nib
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        //Calling the below method
        loadMessages()
        
    }
    
    //This functions loads up previous messages in the firestore before the view loads up.
    func loadMessages(){
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField) // This method allows to sort the retreived data from the db in date order.
            .addSnapshotListener { (querySnapshot, error) in // This method listens for every changes or addition that takes place to add item to populate the table view again with new data(That is needed when we are online and send a message, it saves to database but is not retrieved back and shown to the user in realtime unless we again launch the app.)
                
                //.getDocuments --> to get data once while loading app.
                //.addSnapshotListener--> This will be triggered every time a new data is added to the documents.
                
                
            if let err = error{
                print("There was an error retrieving data from Firestore.\(err)")
            }else{
                
                self.messages = []
                //querySnapshot basically is the class containing properties for all documents stored in it.
                //querySnapshot here refers to calling all the documents present in the class storing the documents in it.
                
                if let snapshotDocuments = querySnapshot?.documents{
                    
                    //looping through documents to get every single data
                    for doc in snapshotDocuments{
                        let data = doc.data() // data is the property of queryDocumentSnapShot which is used to extract data if it exists in firestore documents in the form of a dictionary
                        
                    //Next step is to divide the recieved data() dictionary to separate elements as to create the message struct and populate the table view after.
                        if let messageSender = data[Constants.FStore.senderField] as? String , let messageBody = data[Constants.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)//paasing it to initialize message Struct.
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email{
            db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.senderField:messageSender,Constants.FStore.bodyField:messageBody, Constants.FStore.dateField:Date().timeIntervalSince1970]) { (error) in
                if let err = error{
                    print("There was an error saving data to firestore \(err)")
                }else{
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
        
    }
    
// When the user presses Logout Button
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
    navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
    }
}

//MARK:- Populating the tableView with data from above.
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        
        //This will be triggered if the message is from current user.
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        }else{
            
            //This will be triggered if the message is not from current user.
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        return cell

    }
    
    
}
