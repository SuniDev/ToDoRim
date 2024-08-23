//
//  SettingViewController.swift
//  Todorim
//
//  Created by suni on 8/23/24.
//

import UIKit
import StoreKit

class SettingViewController: BaseViewController {
    
    // MARK: - DATA
    let removeAdsProductID = Constants.appBundleId
    var removeAdsProduct: SKProduct?
    
    // MARK: - Outlet
    @IBOutlet weak var gadSettingView: UIView!
    @IBOutlet weak var gadSettingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var gadLabel: UILabel!
    
    // MARK: - Action
    @IBAction func tappedBackButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedPurchaseRemoveAds(_ sender: Any) {
        purchaseRemoveAds()
    }
    
    @IBAction func tappedRestorePurchases(_ sender: Any) {
        restorePurchases()
    }
    
    @IBAction func tappedGoReview(_ sender: Any) {
        
    }
    
    @IBAction func tappedContactUs(_ sender: Any) {
        
    }
    
    @IBAction func tappedUpdate(_ sender: Any) {
        
    }
    
    @IBAction func tappedPrivacyPolicy(_ sender: Any) {
        
    }
    
    @IBAction func tappedTermsOfService(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
    }
    
    // MARK: - Data 설정
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [removeAdsProductID])
        request.delegate = self
        request.start()
    }
    
    private func purchaseRemoveAds() {
        guard let product = removeAdsProduct else {
            print("Product not available")
            return
        }

        guard SKPaymentQueue.canMakePayments() else {
            print("User cannot make payments")
            return
        }

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    private func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        updatePurchaseSettingUI()
    }
    
    private func updatePurchaseSettingUI() {
        performUIUpdatesOnMain {
            self.view.layoutIfNeeded()
            if Utils.isAdsRemoved {
                self.gadSettingView.isHidden = false
                self.self.gadSettingViewHeight.constant = 220
            } else {
                self.gadSettingView.isHidden = true
                self.gadSettingViewHeight.constant = 0
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - SKProductsRequestDelegate, SKPaymentTransactionObserver
extension SettingViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first(where: { $0.productIdentifier == removeAdsProductID }) {
            removeAdsProduct = product
            print("Product is available: \(product.localizedTitle)")
            // Here you can update UI to display purchase options
        } else {
            print("Product not found")
        }
    }

    // SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // 구매 성공
                if transaction.payment.productIdentifier == removeAdsProductID {
                    // 광고 제거 상태 저장
                    UserDefaultStorage.set(true, forKey: .isAdsRemoved)
                    updatePurchaseSettingUI()
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // 실패 처리
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // 구매 복원
                if transaction.payment.productIdentifier == removeAdsProductID {
                    // 구매 복원: 광고 제거 상태 복원
                    UserDefaultStorage.set(true, forKey: .isAdsRemoved)
                    updatePurchaseSettingUI()
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
