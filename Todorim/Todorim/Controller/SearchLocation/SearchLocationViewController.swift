//
//  SearchLocationViewController.swift
//  Todorim
//
//  Created by suni on 8/15/24.
//

import UIKit
import MapKit
import CoreLocation

class SearchLocationViewController: BaseViewController {
    
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
        moveToMap(selectedPin: pin)
    }
    
    // MARK: - Data 설정
    override func fetchData() {
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let status = locationManager.authorizationStatus
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            Alert.showCancelAndDone(
                self,
                title: L10n.Alert.AuthLocation.title,
                message: L10n.Alert.AuthLocation.message,
                cancelTitle: L10n.Alert.Button.moveSetting,
                cancelHandler: {
                    Utils.moveAppSetting()
                }
            )
        }
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        configureSearchView()
    }
    
    private func configureSearchView() {
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
            searchBar.placeholder = L10n.Location.Search.placeholder
            
            searchBar.translatesAutoresizingMaskIntoConstraints = true
            searchBar.frame = searchView.bounds
            searchBar.autoresizingMask = [.flexibleWidth]
            
            searchView.addSubview(searchBar)
            definesPresentationContext = true
        }
    }
    
    // MARK: - Navigation
    private func moveToMap(selectedPin: MKPlacemark) {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationMapViewController") as? SearchLocationMapViewController else { return }
        viewController.selectedPin = selectedPin
        viewController.delegate = delegate
        performUIUpdatesOnMain {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
// MARK: - CLLocationManagerDelegate
extension SearchLocationViewController: CLLocationManagerDelegate {
    // 이 메서드는 사용자가 권한 대화 상자에 응답 할 때 호출됩니다.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) { }
    
    // 오류를 인쇄합니다.
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

// MARK: - UISearchBarDelegate
extension SearchLocationViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performUIUpdatesOnMain {
            // 높이를 먼저 줄이도록 애니메이션 설정
            self.view.layoutIfNeeded() // 현재 상태를 먼저 렌더링
            
            // alpha와 constant를 동시에 애니메이션
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.topViewHeight.constant = 0.0
                self.view.layoutIfNeeded() // 변경된 레이아웃을 즉시 반영
            }, completion: nil)
        }
        
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        performUIUpdatesOnMain {
            self.view.layoutIfNeeded() // 현재 상태를 먼저 렌더링
            
            // alpha와 constant를 동시에 애니메이션
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.topViewHeight.constant = 70.0
                self.view.layoutIfNeeded() // 변경된 레이아웃을 즉시 반영
            }, completion: nil)
        }
        return true
    }
}

// MARK: - SearchLocationTableViewDelegate
extension SearchLocationViewController: SearchLocationTableViewDelegate {
    func didSelectLocation(_ tableView: UITableView, selectedItem: MKPlacemark) {        
        moveToMap(selectedPin: selectedItem)
    }
}
