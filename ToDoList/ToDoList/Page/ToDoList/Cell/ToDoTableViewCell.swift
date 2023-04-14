//
//  ToDoTableViewCell.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import UIKit
import SnapKit

class ToDoTableViewCell: UITableViewCell {
    
    lazy var todoStackView: UIStackView = {
       
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .vertical
        stv.spacing = 2
        stv.distribution = .fill
        
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
    
    lazy var descriptionTextView: UITextView = {
        
        let txv = UITextView()
        txv.textColor = .black
        txv.backgroundColor = .gray
        
        return txv
    }()
    
    lazy var dateStackView: UIStackView = {
       
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .horizontal
        stv.spacing = 4
        stv.distribution = .fillEqually
        
        return stv
    }()
    
    lazy var createdDateTextField: UITextField = {
        
        let txf = UITextField()
        txf.textColor = .black
        txf.placeholder = "Create date"
        
        return txf
    }()
    
    lazy var dueDateTextField: UITextField = {
    
        let txf = UITextField()
        txf.textColor = .black
        txf.placeholder = "Due date"
        
        return txf
    }()
    
    lazy var locationTextField: UITextField = {
        
        let txf = UITextField()
        txf.textColor = .black
        txf.placeholder = "Location"
        
        return txf
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    func setupUI() {
        
        self.contentView.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        contentView.addSubview(todoStackView)
        todoStackView.addArrangedSubview(titleTextField)
        todoStackView.addArrangedSubview(descriptionLabel)
        todoStackView.addArrangedSubview(descriptionTextView)
        todoStackView.addArrangedSubview(dateStackView)
        dateStackView.addArrangedSubview(createdDateTextField)
        dateStackView.addArrangedSubview(dueDateTextField)
        todoStackView.addArrangedSubview(locationTextField)
        
        todoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.size.equalToSuperview().offset(-8)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalToSuperview().offset(-8)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(4)
        }
       
    }
    
    func addAction() {
        
    }

}
