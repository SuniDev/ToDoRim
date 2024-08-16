//
//  SearchLocationTableViewController.swift
//  Todorim
//
//  Created by suni on 8/15/24.
//

import UIKit
import MapKit

class SearchLocationTableViewController: UITableViewController {
    
    // 나중에 쉽게 액세스 할 수 있도록 검색 결과를 숨기려고 사용합니다.
    var matchingItems: [MKMapItem] = []
    // 검색 쿼리는 지도 영역을 사용하여 로컬 결과의 우선 순위를 지정합니다.
    var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView =  MKMapView(frame: self.view.bounds)
    }
}

// MARK: - Table view data source & delegate
extension SearchLocationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell") {
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel? .text = parseAddress(selectedItem: selectedItem)
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
//        CommonNav.shared.moveSearchMap(superVC: superVC, searchVC: searchVC, pin: selectedItem)
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

// MARK: - UISearchResultsUpdating
extension SearchLocationTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        // 검색 요청은 검색 문자열과 위치 컨텍스트를 제공하는 맵 영역으로 구성됩니다. 검색 문자열은 검색 창 텍스트에서 가져오고 맵 영역은 mapView에서 가져옵니다.
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        // 요청 오브젝트에서 실제 검색을 수행합니다. startWithCompletionHandler ()는  검색 질의를 실행하고 리턴, MKLocalSearchResponse의  배열이 포함 객체 mapItems를 . 당신은 내부에 이러한 mapItems을 숨기고  matchingItems 다음 테이블을 다시로드 .
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

