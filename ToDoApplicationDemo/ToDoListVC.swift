//
//  ToDoListVC.swift
//  ToDoApplicationDemo
//
//  Created by Abhinay on 27/07/18.
//  Copyright © 2018 ONS. All rights reserved.
//

import UIKit

class ToDoListVC:UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    //MARK:- Private Vars
    fileprivate let cellId = "TaskCellId"
    fileprivate let headerId = "TaskHeaderId"
    fileprivate let footerId = "TaskFooterId"
    fileprivate var dataSource = ["Pay Credit Card Bill", "Pay Electricity Bill", "Pay Room Rent"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To Do List"
        collectionView?.backgroundColor = .white
        collectionView?.register(TaskCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TaskHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(TaskFooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    fileprivate func addTask(taskName:String){
        dataSource.append(taskName)
        collectionView?.reloadData()
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskCell
        cell.title = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    //Header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    //Supplementry Hader View
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        switch kind
        {
        case UICollectionElementKindSectionHeader:
            let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! TaskHeaderCell
            headerview.toDoVC = self
            return headerview
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as! TaskFooterCell
            return footerView
        default:
            return UICollectionReusableView()
        }
        
    }
    
}

class ToDoTaskCell:UICollectionViewCell
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews()
    {
        
    }
}

class TaskCell:ToDoTaskCell
{
    var title:String!{
        didSet{
            titleLabel.text = title
        }
    }
    
    //MARK:- Private Vars
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpViews() {
        addSubview(titleLabel)
        setUpLayout()
    }
    
    fileprivate func setUpLayout()
    {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: [], metrics: nil, views: ["v0":titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: [], metrics: nil, views: ["v0":titleLabel]))
    }
}

class TaskHeaderCell:ToDoTaskCell, UITextFieldDelegate
{
    var toDoVC:ToDoListVC?
    
    private let txtHeader:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter the task name"
        textField.borderStyle = UITextBorderStyle.bezel
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    }()
    
    private let btnAddTask:UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Add Task", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let borderLine:UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        addSubview(txtHeader)
        addSubview(btnAddTask)
        addSubview(borderLine)
        setUpLayout()
        
        txtHeader.delegate = self
        btnAddTask.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    
    fileprivate func setUpLayout()
    {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-[v1]-8-|", options: [], metrics: nil, views: ["v0":txtHeader, "v1":btnAddTask]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]-15-|", options: [], metrics: nil, views: ["v0":txtHeader]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]-15-|", options: [], metrics: nil, views: ["v0":btnAddTask]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: [], metrics: nil, views: ["v0":borderLine]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: [], metrics: nil, views: ["v0":borderLine]))
    }
    
    @objc private func addTask()
    {
        if !(txtHeader.text?.isEmpty)!{
            toDoVC?.addTask(taskName: txtHeader.text!)
            txtHeader.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class TaskFooterCell:ToDoTaskCell
{
    //MARK:- Private Vars
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Demo application"
        label.textAlignment = .center
        return label
    }()
    
    override func setUpViews() {
        self.backgroundColor = .darkGray
        addSubview(titleLabel)
        setUpLayout()
    }
    
    fileprivate func setUpLayout()
    {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: [], metrics: nil, views: ["v0":titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: [], metrics: nil, views: ["v0":titleLabel]))
    }
}

