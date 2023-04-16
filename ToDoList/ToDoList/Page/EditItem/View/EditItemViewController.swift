//
//  EditItemViewController.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import UIKit
import SnapKit

class EditItemViewController: UIViewController {

    lazy var editItemScrollView: UIScrollView = {
       
        let srv = UIScrollView()
        return srv
        
    }()
    
    lazy var editItemContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var editItemStackView: UIStackView = {
        
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .vertical
        stv.spacing = 2
        stv.distribution = .fill
        stv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        return stv
    }()
    
    lazy var titleTextField: UITextField = {
        
        let txf = UITextField()
        txf.textColor = .black
        txf.placeholder = "Item Title"
        
        return txf
    }()
    
    lazy var descriptionLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "Description:"
        
        return lbl
    }()
    
    lazy var dateStackView: UIStackView = {
       
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .horizontal
        stv.spacing = 4
        stv.distribution = .fillEqually
        
        return stv
    }()
    
    lazy var createdDateDatePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.date = Date()
        dp.overrideUserInterfaceStyle = .light
    
        return dp
    }()
    
    lazy var dueDateDatePicker: UIDatePicker = {
    
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        dp.date = nextDate
        dp.overrideUserInterfaceStyle = .light
        
        return dp
    }()
    
    lazy var locationTextField: UITextField = {
        
        let txf = UITextField()
        txf.textColor = .black
        txf.placeholder = "location: (121.5188, 25.0223)"
        
        return txf
    }()
    
    lazy var descriptionTextView: UITextView = {
        
        let txv = UITextView()
        txv.textColor = .black
        txv.backgroundColor = .gray
        
        return txv
    }()
    
    lazy var confirmButton: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Confirm", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(confirmEditItem(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func confirmEditItem(_: UIButton) {
        
        let todoItem = ToDoItem(title: self.titleTextField.text ?? "",
                                description: self.descriptionTextView.text ?? "",
                                createDate: self.createdDateDatePicker.date,
                                dueDate: self.dueDateDatePicker.date,
                                coordinate: Coordinate(latitude: 1, longitude: 2))
        printContent(todoItem)
        
    }
    
    var viewModel: EditItemViewModel
    
    init(viewModel: EditItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        
        self.title = "Edit Item"
        self.view.backgroundColor = .white
        
        self.view.addSubview(editItemScrollView)
        self.view.addSubview(confirmButton)
        
        editItemScrollView.addSubview(editItemContentView)
        editItemContentView.addSubview(editItemStackView)
        
        editItemStackView.addArrangedSubview(titleTextField)
        editItemStackView.addArrangedSubview(descriptionLabel)
        editItemStackView.addArrangedSubview(descriptionTextView)
        editItemStackView.addArrangedSubview(dateStackView)
        editItemStackView.addArrangedSubview(locationTextField)
        
        dateStackView.addArrangedSubview(createdDateDatePicker)
        dateStackView.addArrangedSubview(dueDateDatePicker)
    
        editItemScrollView.snp.makeConstraints { make in
            
            make.topMargin.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin) .offset(-44)
        }
        
        confirmButton.snp.makeConstraints { make in
            
            make.top.equalTo(editItemScrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        editItemContentView.snp.makeConstraints { make in
            
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        editItemStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(8)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalToSuperview()
        }
        
        dateStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(4)
        }
        
        
    }

}
