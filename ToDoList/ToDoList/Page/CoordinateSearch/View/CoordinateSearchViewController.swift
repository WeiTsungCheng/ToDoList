//
//  CoordinateSearchViewController.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/16.
//

import UIKit
import MapKit


class CoordinateSearchViewController: UIViewController, NetWorkStatusProtocal {
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.showsUserLocation = true
        
        return mv
    }()
    
    lazy var searchTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = .white
        txf.textColor = .black
        txf.placeholder = "Search"
        
        let image = UIImage(systemName: "magnifyingglass")
        let imageView = UIImageView(image: image)
        txf.leftViewMode = .always
        txf.leftView = imageView
        txf.delegate = self
        
        return txf
    }()
    
    lazy var selectCoordinateTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = .white
        txf.textColor = .black
        txf.placeholder = "The coordinates of the currently selected position"
        txf.isEnabled = false
        
        return txf
    }()
    
    lazy var selectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        btn.setTitle("Select", for: .normal)
        btn.addTarget(self, action: #selector(selectCoordinate(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc private func selectCoordinate(_: UIButton) {
        
        guard let location = viewModel.selectLocation else {
            return
        }
        
        passCoordinateClosure?(location)
        dismiss(animated: true)
    }
    
    var passCoordinateClosure: ((CLLocationCoordinate2D) -> Void)?
    
    var observerNetStatusChangedNotification: NSObjectProtocol?
    
    func noticeNetStatusChanged(_ nofification: Notification) {
        checkNetStatusAlert()
    }
    
    var viewModel: CoordinateSearchViewModel
    
    init(viewModel: CoordinateSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        registerNetStatusManager()
        addGesture()
        
        MapManager.shared.delegate = self
        MapManager.shared.mapView = mapView
        
        
        if let coordinate = LocationManager.shared.currentLocation?.coordinate {
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.setRegion(region, animated: true)
        }
        
                
        mapView.delegate = MapManager.shared
        
        viewModel.selectCoordinateObervable.addObserver { text in
            self.selectCoordinateTextField.text  = text
        }
        
    }
    
    deinit {
        unregisterNetStatusManager()
    }
    
    private func setUpUI() {
        
        self.view.backgroundColor = .systemGray
        self.view.addSubview(searchTextField)
        self.view.addSubview(mapView)
        self.view.addSubview(selectCoordinateTextField)
        self.view.addSubview(selectButton)
        
        searchTextField.snp.makeConstraints { make in
            
            make.top.equalTo(view.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
        
        selectButton.snp.makeConstraints { make in
            
            make.bottom.equalTo(view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            
        }
        
        selectCoordinateTextField.snp.makeConstraints { make in
            
            make.bottom.equalTo(selectButton.snp.top).offset(-8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
            
        }
        
        mapView.snp.makeConstraints { make in
            
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.bottom.equalTo(selectCoordinateTextField.snp.top).offset(-8)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    private func addGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
}

extension CoordinateSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == searchTextField {
            
            let query = textField.text
            MapManager.shared.search(query: query)
        }
        
        return true
    }
}

extension CoordinateSearchViewController: MapManagerProtocol {
    
    func selectedCoordinateOnMap(_ coodinate: CLLocationCoordinate2D) {
        
        viewModel.selectLocation = coodinate
    }
    
}
