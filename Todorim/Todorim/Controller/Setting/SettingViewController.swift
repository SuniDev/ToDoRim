//
//  SettingViewController.swift
//  Todorim
//
//  Created by suni on 8/23/24.
//

import UIKit
import StoreKit
import MessageUI
import SafariServices

class SettingViewController: BaseViewController {
    
    // MARK: - DATA
    let removeAdsProductID = Constants.appProductId
    var removeAdsProduct: SKProduct?
    
    // MARK: - Outlet
    @IBOutlet weak var gadSettingView: UIView!
    @IBOutlet weak var gadSettingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateArrowImageWidth: NSLayoutConstraint!
    @IBOutlet weak var updateArrowImage: UIImageView!
    @IBOutlet weak var gadLabel: UILabel!
    
    // MARK: - Action
    @IBAction private func tappedBackButton(_ sender: Any) {
        navigationController?.hero.isEnabled = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func tappedPurchaseRemoveAds(_ sender: Any) {
        purchaseRemoveAds()
    }
    
    @IBAction private func tappedRestorePurchases(_ sender: Any) {
        restorePurchases()
    }
    
    @IBAction private func tappedGoReview(_ sender: Any) {
        
    }
    
    @IBAction private func tappedContactUs(_ sender: Any) {
        showContractUsMail()
    }
    
    @IBAction private func tappedUpdate(_ sender: Any) {
        Utils.moveAppStore()
    }
    
    @IBAction private func tappedPrivacyPolicy(_ sender: Any) {
        openSafariViewController(urlString: Constants.privacyPolicyUrl)
    }
    
    @IBAction private func tappedTermsOfService(_ sender: Any) {
        openSafariViewController(urlString: Constants.termsOfServiceUrl)
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
        
        updateLoadingView(isLoading: true)

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    private func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func showContractUsMail() {
        let mail = Constants.appMail
        let subject = "[\(Constants.appName) 문의]"
        let body = """
                ℹ️ 앱 및 계정 정보 ℹ️
                앱 이름 : \(Constants.appName)
                앱 버전 : \(Constants.appVersion)
                                
                💡 문의 내용 💡
                - 오류 문의 시, 발생 시각을 함께 적어주시면 원활한 해결이 가능해요!
                - 이곳에 문의하실 내용을 적어 주세요.
                
                
                
                
                
                
                """
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([mail])
            mailComposeVC.setSubject(subject)
            mailComposeVC.setMessageBody(body, isHTML: false)
            
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            // TODO: 메일을 보낼 수 없는 경우 경고 표시
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVersionUpdate()
    }
    
    // MARK: - Data 설정
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [removeAdsProductID])
        request.delegate = self
        request.start()
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        updatePurchaseUI()
    }

    func configureVersionUpdate() {
        let currentVersion: String = Constants.appVersion
        
        Utils.checkForUpdate { [weak self] appUpdate, storeVersion in
            guard let self else { return }
            self.performUIUpdatesOnMain {
                self.versionLabel.text = currentVersion
                if appUpdate == .none {
                    self.updateLabel.text = "최신 버전입니다."
                    self.updateButton.isHidden = true
                    self.updateArrowImage.isHidden = true
                    self.updateArrowImageWidth.constant = 0
                } else {
                    if let storeVersion {
                        self.updateLabel.text = "\(storeVersion)으로 업데이트 하러가기"
                    } else {
                        self.updateLabel.text = "업데이트 하러가기"
                    }
                    self.updateButton.isHidden = false
                    self.updateArrowImage.isHidden = false
                    self.updateArrowImageWidth.constant = 25
                }
            }
        }
    }
    
    private func updatePurchaseUI() {
        performUIUpdatesOnMain {
            if Utils.isAdsRemoved {
                self.gadSettingView.isHidden = true
                self.gadSettingViewHeight.constant = 0
            } else {
                self.gadSettingView.isHidden = false
                self.gadSettingViewHeight.constant = 220
            }
        }
    }
    
    private func animateUpdatePurchaseUI() {
        performUIUpdatesOnMain {
            self.view.layoutIfNeeded()
            self.updatePurchaseUI()
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - Navigation
extension SettingViewController {
    private func openSafariViewController(urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        if url.scheme == "http" || url.scheme == "https" {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .pageSheet
            performUIUpdatesOnMain {
                self.present(safariViewController, animated: true, completion: nil)
            }
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
        updateLoadingView(isLoading: false)
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // 구매 성공
                if transaction.payment.productIdentifier == removeAdsProductID {
                    // 광고 제거 상태 저장
                    UserDefaultStorage.set(true, forKey: .isAdsRemoved)
                    animateUpdatePurchaseUI()
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
                    animateUpdatePurchaseUI()
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            showToast(message: L10n.Toast.ContractUs.complete)
        case .failed:
            showToast(message: L10n.Toast.ContractUs.error)
        @unknown default:
            showToast(message: L10n.Toast.ContractUs.error)
        }
    }
}
