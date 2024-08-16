//
//  SearchLocationViewController.swift
//  Todorim
//
//  Created by suni on 8/15/24.
//

import UIKit
import MapKit
import CoreLocation

class SearchLocationViewController: UIViewController {
    
    // MARK: - Data
    let locationManager = CLLocationManager()
    
    // MARK: - Outlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    var resultSearchController: UISearchController?
    
    // MARK: - Action
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSearchPosition(_ sender: UIButton) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let pin = MKPlacemark(coordinate: coordinate)
//        CommonNav.shared.moveSearchMap(superVC: superVC, searchVC: self, pin: pin)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationManager()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let status = locationManager.authorizationStatus
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alert = UIAlertController(title: "위치 서비스를 이용할 수 없습니다.", message: "기기의 '설정 > 개인정보보호' 에서 위치 접근을 허용해 주세요.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        }
        
        if let searchTableViewController = storyboard!.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as? SearchLocationTableViewController {
            resultSearchController = UISearchController(searchResultsController: searchTableViewController)
            resultSearchController?.searchResultsUpdater = searchTableViewController
        }
        
        if let searchBar = resultSearchController?.searchBar {
            searchBar.sizeToFit()
            searchBar.placeholder = "장소를 검색하세요."
            searchBar.delegate = self
            searchView.addSubview(searchBar)
        }
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
}
// MARK: - CLLocationManagerDelegate
extension SearchLocationViewController: CLLocationManagerDelegate {
    
    // 이 메서드는 사용자가 권한 대화 상자에 응답 할 때 호출됩니다.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       
    }
    
    // 오류를 인쇄합니다.
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

// MARK: - UISearchBarDelegate
extension SearchLocationViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.layoutIfNeeded()
        
        topViewHeight.constant = 0.0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.layoutIfNeeded()
        
        topViewHeight.constant = 70.0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        return true
    }
}
