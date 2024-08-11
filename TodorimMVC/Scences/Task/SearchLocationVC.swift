//
//  SearchLocalVC.swift
//  HSTODO
//
//  Created by 박현선 on 23/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//protocol HandleMapSearch {
//    func dropPinZoomIn(placemark:MKPlacemark)
//}

class SearchLocationVC: UIViewController {
    
    // Outlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var constTopViewHeight: NSLayoutConstraint!
    
    
    // let
    let locationManager = CLLocationManager()
    
    // var
    var resultSearchController: UISearchController? = nil
//    var selectedPin : MKPlacemark? = nil
    var superVC: UIViewController!
    
    // Action
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchPosition(_ sender: UIButton) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let pin = MKPlacemark(coordinate: coordinate)
        CommonNav.shared.moveSearchMap(superVC: superVC, searchVC: self, pin: pin)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 위치 권한 요청
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alert = UIAlertController(title: "위치 서비스를 이용할 수 없습니다.", message: "기기의 '설정 > 개인정보보호' 에서 위치 접근을 허용해 주세요.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
        }
        
        
        // 위치 검색 결과 테이블 세팅
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "SearchLocationTVC") as! SearchLocationTVC
        locationSearchTable.superVC = self.superVC
        locationSearchTable.searchVC = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // 검색 바 세팅
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "장소를 검색하세요."
        searchBar.delegate = self
        viewSearch.addSubview(resultSearchController!.searchBar)
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        // 검색 막대가 선택 될 때 모달 오버레이에 반투명 배경을 제공합니다.
//        resultSearchController?.dimsBackgroundDuringPresentation = true
        // 기본적으로 모달 오버레이는 검색 창을 포함하여 전체 화면을 차지합니다
        definesPresentationContext = true
        
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchLocationVC: CLLocationManagerDelegate {
    
    // 이 메서드는 사용자가 권한 대화 상자에 응답 할 때 호출됩니다.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       
    }
    
    
    // 오류를 인쇄합니다.
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}

// MARK: - UISearchBar
extension SearchLocationVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.layoutIfNeeded()
        
        constTopViewHeight.constant = 0.0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.layoutIfNeeded()
        
        constTopViewHeight.constant = 70.0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        return true
    }
}

// MARK: - extension
extension SearchLocationVC {
    
}
