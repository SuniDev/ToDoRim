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
    weak var delegate: SelectLocationMapViewDelegate?
    
    // MARK: - Outlet
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    var resultSearchController: UISearchController?
    
    // MARK: - Action
    @IBAction private func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func tappedSearchPosition(_ sender: UIButton) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let pin = MKPlacemark(coordinate: coordinate)
        moveMap(selectedPin: pin)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationManager()
        configureSearchView()
    }
    
    func configureSearchView() {
        if let searchTableViewController = storyboard?.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as? SearchLocationTableViewController {
            searchTableViewController.delegate = self
            resultSearchController = UISearchController(searchResultsController: searchTableViewController)
            resultSearchController?.searchResultsUpdater = searchTableViewController
        }
        
        if let searchBar = resultSearchController?.searchBar {
            resultSearchController?.obscuresBackgroundDuringPresentation = false
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            searchBar.delegate = self
            
            searchBar.barStyle = .default
            searchBar.placeholder = "장소를 검색하세요."
            
            searchBar.translatesAutoresizingMaskIntoConstraints = true
            searchBar.frame = searchView.bounds
            searchBar.autoresizingMask = [.flexibleWidth]
            
            searchView.addSubview(searchBar)
            definesPresentationContext = true
        }
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
        // 높이를 먼저 줄이도록 애니메이션 설정
        self.view.layoutIfNeeded() // 현재 상태를 먼저 렌더링

        // alpha와 constant를 동시에 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.topViewHeight.constant = 0.0
            self.view.layoutIfNeeded() // 변경된 레이아웃을 즉시 반영
        }, completion: nil)
        
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.layoutIfNeeded() // 현재 상태를 먼저 렌더링

        // alpha와 constant를 동시에 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.topViewHeight.constant = 70.0
            self.view.layoutIfNeeded() // 변경된 레이아웃을 즉시 반영
        }, completion: nil)
        
        return true
    }
    
    func moveMap(selectedPin: MKPlacemark) {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationMapViewController") as? SearchLocationMapViewController else { return }
        viewController.selectedPin = selectedPin
        viewController.delegate = delegate
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - SearchLocationTableViewDelegate
extension SearchLocationViewController: SearchLocationTableViewDelegate {
    func didSelectLocation(_ tableView: UITableView, selectedItem: MKPlacemark) {        
        moveMap(selectedPin: selectedItem)
    }
}
