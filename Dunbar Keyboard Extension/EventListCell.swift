//
//  EventListCell.swift
//  iOS Keyboard
//
//  Created by George Birch on 9/7/23.
//

import UIKit
import Dunbar_Common

class EventListCell: UICollectionViewCell {
    
    var stackView: UIStackView!
    var textStackView: UIStackView!
    
    var title: UILabel!
    var dateTime: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        dateTime = UILabel()
        dateTime.font = UIFont.systemFont(ofSize: 16)
        dateTime.textColor = UIColor.gray
        dateTime.textAlignment = .right
        dateTime.translatesAutoresizingMaskIntoConstraints = false
        
        title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.translatesAutoresizingMaskIntoConstraints = false
        
        textStackView = UIStackView()
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.addArrangedSubview(UIView()) // spacer view
        textStackView.addArrangedSubview(dateTime)
        textStackView.addArrangedSubview(title)
        let textBottomSpacer = UIView()
        textStackView.addArrangedSubview(textBottomSpacer)
        
        imageView = UIImageView(frame: CGRect(x: 200, y: 0, width: 95, height: 128))
        
        stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textStackView)
        let textTrailingSpacer = UIView()
        stackView.addArrangedSubview(textTrailingSpacer)
        stackView.addArrangedSubview(imageView)
        addSubview(stackView)
        layer.cornerRadius = 8
        
        let constraints = [
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 95),
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            
            textTrailingSpacer.widthAnchor.constraint(equalToConstant: 12),
            textTrailingSpacer.trailingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            textStackView.trailingAnchor.constraint(equalTo: textTrailingSpacer.leadingAnchor),
            textStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            
            textBottomSpacer.heightAnchor.constraint(equalToConstant: 12),
            
            dateTime.trailingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 12),
            dateTime.bottomAnchor.constraint(equalTo: title.topAnchor),
            
            title.trailingAnchor.constraint(equalTo: dateTime.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(event: EventData) {
        title.text = event.title
        dateTime.text = event.startDate
        dateTime.text! += event.startTime ?? ""
        
        // TODO: gate under conditional checking whether or not there is an image associated with the event
        stackView.removeArrangedSubview(imageView)
    }
    
}
