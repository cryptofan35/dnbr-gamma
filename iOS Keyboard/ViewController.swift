//
//  ViewController.swift
//  iOS Keyboard
//
//  Created by George Birch on 8/8/23.
//

import UIKit

class ViewController: UIViewController {
    
    var pasteBox: UITextField!
    
    var legalButton: UIButton!
    var educationButton: UIButton!
    var googleSignInButton: UIControl!
    var googleSignOutButton: UIButton!
    
    var signInProvider: SignInProviding!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dependencies must be retrieved from AppDelegate for initial view controllers
        // all other classes can have dependencies passed to them upon initialization
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        signInProvider = appDelegate.getGoogleSignInProvider()
//        signInProvider.setEventReceiptCallback { [weak self] eventData in
//            self?.events = eventData
//            self?.eventList.reloadData()
//        }
        
        setupUI()
    }

    private func setupUI() {
        legalButton = UIButton(type: .system)
        legalButton.setTitle("Legal", for: [])
        legalButton.backgroundColor = UIColor.lightGray
        legalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(legalButton)
        
        educationButton = UIButton(type: .system)
        educationButton.setTitle("Education", for: [])
        educationButton.backgroundColor = UIColor.lightGray
        educationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(educationButton)
        
        googleSignInButton = signInProvider.signInButton()
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleSignInButton)
        
        googleSignOutButton = UIButton(type: .system)
        signInProvider.addSignOutAction(googleSignOutButton)
        googleSignOutButton.setTitle("Sign Out", for: [])
        googleSignOutButton.backgroundColor = UIColor.lightGray
        googleSignOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleSignOutButton)
        
        pasteBox = UITextField()
        pasteBox.placeholder = "Example text box"
        pasteBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pasteBox)
        
        let constraints = [
            legalButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            legalButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            educationButton.leadingAnchor.constraint(equalTo: legalButton.trailingAnchor, constant: 10),
            educationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            googleSignInButton.leadingAnchor.constraint(equalTo: educationButton.trailingAnchor, constant: 10),
            googleSignInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            googleSignOutButton.leadingAnchor.constraint(equalTo: googleSignInButton.trailingAnchor, constant: 10),
            googleSignOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pasteBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pasteBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pasteBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
