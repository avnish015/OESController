//
//  OESTextView.swift
//  OESController
//
//  Created by Avnish on 07/09/20.
//

import UIKit

class OESTextView: UIView {
    var deleteButton:UIButton = UIButton()
    var textView = UITextView()
    var callBack:((UIButton)->Void)?  = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        deleteButton.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        deleteButton.target(forAction: #selector(deleteButtonTapped(sender:)), withSender: self)
        deleteButton.setImage(UIImage(systemName: "clear"), for: .normal)
        self.tintColor = .black
        
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        textView.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.isUserInteractionEnabled = true
        addSubview(textView)
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        deleteButton.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        deleteButton.setImage(UIImage(systemName: "clear"), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.backgroundColor = .white
        deleteButton.isUserInteractionEnabled = true

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: deleteButton.centerXAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        textView.topAnchor.constraint(equalTo: deleteButton.centerYAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.textView.tintColor = .black

    }

    @objc func deleteButtonTapped(sender:UIButton) {
        if let callBack = callBack {
            callBack(deleteButton)
        }
    }

}
