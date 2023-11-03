//
//  KeyboardViewController.swift
//  Dunbar Keyboard Extension
//
//  Created by George Birch on 8/8/23.
//

import UIKit
import OSLog
import Dunbar_Common

class KeyboardViewController: UIInputViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // TODO: update to dependency injection pattern
    let keychainWrapper = KeychainWrapper()
    let dunbarAPI = DunbarBackendAPI()
    let assetProvider = AssetProvider()
    var userDefaultsWrapper: UserDefaultsWrapper!
    
    var eventList: UICollectionView!
    var events: [EventData]!
    
    var stackView: UIStackView!
    var sortButton: UIButton!
    var dunbarButton: UIButton!
    
    let logger = Logger(subsystem: "com.withdunbar.iOS-Keyboard", category: "KeyboardViewController")
    let commonBundle = Bundle(identifier: "com.withdunbar.Dunbar-Common")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: handle initialization error
        userDefaultsWrapper = try! UserDefaultsWrapper()
        
        events = [EventData]()
        loadEvents()
        
        setupUI()
    }
    
    private func setupUI() {
        sortButton = UIButton()
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.title = "Recently viewed"
        buttonConfig.baseForegroundColor = UIColor.black
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 3, trailing: 20)
        sortButton.configuration = buttonConfig
        
        initializeLogo()
        
        let headerStack = UIStackView()
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addArrangedSubview(sortButton)
        headerStack.addArrangedSubview(UIView()) // spacer
        headerStack.addArrangedSubview(dunbarButton)
        
        let eventListLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        eventListLayout.sectionInset = UIEdgeInsets(top: 3, left: 20, bottom: 20, right: 0)
        eventListLayout.itemSize = CGSize(width: 295, height: 128)
        eventListLayout.scrollDirection = .horizontal
        eventList = UICollectionView(frame: .zero, collectionViewLayout: eventListLayout)
        eventList.dataSource = self
        eventList.delegate = self
        eventList.register(EventListCell.self, forCellWithReuseIdentifier: "Cell")
        eventList.showsHorizontalScrollIndicator = false
        eventList.alwaysBounceHorizontal = true
        eventList.backgroundColor = assetProvider.dnbrGreen
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = assetProvider.dnbrGreen
        stackView.addArrangedSubview(headerStack)
        stackView.addArrangedSubview(eventList)
        view.addSubview(stackView)
        
        let constraints = [
            view.heightAnchor.constraint(equalToConstant: 197),
            
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sortButton.widthAnchor.constraint(equalToConstant: 171),
            sortButton.heightAnchor.constraint(equalToConstant: 47),
            sortButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            sortButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            eventList.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            eventList.heightAnchor.constraint(equalToConstant: 151),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func initializeLogo() {
        dunbarButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 20, bottom: 4, trailing: 20)
        dunbarButton.configuration = config
        let logoImage = UIImage(named: "dunbar-solid-img-white", in: commonBundle, with: nil)
        guard let logoImage = logoImage else {
            logger.notice("Failed to initialize logo UIImage")
            return
        }
        UIGraphicsBeginImageContext(CGSizeMake(25, 25))
        logoImage.draw(in: CGRectMake(0, 0, 25, 25), blendMode: .normal, alpha: 1)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        dunbarButton.setImage(newImage, for: .normal)
    }
    
    private func loadEvents() {
        guard let userID = userDefaultsWrapper.retrieveAccountID() else {
            //TODO: handle not having an account id (user is not signed in)
            return
        }
        guard let dunbarToken = try? keychainWrapper.retrieveToken(accountName: userID) else {
            //TODO: handle not being able to retrieve dunbar token from keychain AND retrieveToken() throwing
            return
        }
        Task {
            do {
                events = try await dunbarAPI.getEvents(dnbrToken: dunbarToken)
                await MainActor.run { [weak self] in
                    self?.eventList.reloadData()
                }
            } catch {
                logger.notice("Unable to get events from Dunbar API: \(error)")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = eventList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? EventListCell else { fatalError("Unable to dequeue event list cell") }
        
        cell.setup(event: events[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textDocumentProxy.insertText(events[indexPath.row].eventUrl)
    }

}
