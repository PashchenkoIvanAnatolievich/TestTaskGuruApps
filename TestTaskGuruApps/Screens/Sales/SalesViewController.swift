import UIKit
import StoreKit
import SnapKit

class SalesViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let imageView = UIImageView(image: UIImage(named: "BackgroundGirl"))
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let startNowBtn = UIButton(type: .system)
    private let privacyTextView = UITextView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Public Properties
    
    var onPurchaseSuccess: (() -> Void)?
    var onClose: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var monthlyProduct: Product?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addActions()
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupImageView()
        setupTitleLabel()
        setupPriceLabel()
        setupStartNowButton()
        setupPrivacyText()
        setupActivityIndicator()
    }
    
    private func setupNavigationBar() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "CancelSaleScreen"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(AdaptiveService.getAdaptiveHeight(406))
        }
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Discover all Premium features"
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(named: "titleText")
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(AdaptiveService.getAdaptiveHeight(40))
            make.leading.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(24))
            make.trailing.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(63))
        }
    }
    
    private func setupPriceLabel() {
        view.addSubview(priceLabel)
        priceLabel.numberOfLines = 0
        priceLabel.lineBreakMode = .byWordWrapping
        priceLabel.textColor = UIColor(named: "privacyText")
        priceLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptiveService.getAdaptiveHeight(16))
            make.leading.trailing.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(24))
        }
    }
    
    private func setupStartNowButton() {
        view.addSubview(startNowBtn)
        startNowBtn.setTitle("Start Now", for: .normal)
        startNowBtn.setTitleColor(.white, for: .normal)
        startNowBtn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        startNowBtn.backgroundColor = UIColor(named: "activeBth")
        startNowBtn.layer.cornerRadius = AdaptiveService.getAdaptiveHeight(28)
        startNowBtn.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(AdaptiveService.getAdaptiveHeight(100))
            make.leading.trailing.equalToSuperview().inset(AdaptiveService.getAdaptiveWidth(24))
            make.height.equalTo(AdaptiveService.getAdaptiveHeight(56))
        }
    }
    
    private func setupPrivacyText() {
        view.addSubview(privacyTextView)
        privacyTextView.isEditable = false
        privacyTextView.isScrollEnabled = false
        privacyTextView.textAlignment = .center
        privacyTextView.backgroundColor = .clear
        privacyTextView.linkTextAttributes = [.foregroundColor: UIColor(named: "linkColor") ?? UIColor.blue]
        
        let fullText = "By continuing you accept our:\nTerms of Use, Privacy Policy, Subscription Terms"
        let links = ["Terms of Use", "Privacy Policy", "Subscription Terms"]
        let urls = [
            "https://www.google.com/search?q=Terms+of+Use",
            "https://www.google.com/search?q=Privacy+Policy",
            "https://www.google.com/search?q=Subscription+Terms"
        ]
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle
        ]
        attributedString.addAttributes(baseAttributes, range: NSRange(location: 0, length: attributedString.length))
        
        
        for (index, link) in links.enumerated() {
            if let range = fullText.range(of: link) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttribute(.link, value: urls[index], range: nsRange)
            }
        }
        
        privacyTextView.attributedText = attributedString
        privacyTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(AdaptiveService.getAdaptiveHeight(34))
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.color = .darkGray
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func addActions() {
        startNowBtn.addTarget(self, action: #selector(monthlyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - StoreKit Logic
    
    private func loadProducts() {
        showLoading(true)
        Task {
            defer { DispatchQueue.main.async { self.showLoading(false) } }
            do {
                try await StoreManager.shared.fetchProducts()
                self.monthlyProduct = StoreManager.shared.products.first { $0.id == "com.guruapps.test.monthly" }
                await MainActor.run { self.updateUIWithProducts() }
            } catch {
                await MainActor.run { self.showAlert(title: "Error", message: "Failed to load products.") }
            }
        }
    }
    
    private func purchase(product: Product) {
        showLoading(true)
        Task {
            defer { DispatchQueue.main.async { self.showLoading(false) } }
            do {
                _ = try await StoreManager.shared.purchase(product)
                self.onPurchaseSuccess?()
            } catch StoreError.userCancelled {
                LogService.log("User cancelled purchase.")
            } catch {
                await MainActor.run { self.showAlert(title: "Purchase Error", message: error.localizedDescription) }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func monthlyButtonTapped() {
        guard let product = monthlyProduct else { return }
        purchase(product: product)
    }
    
    @objc private func closeButtonTapped() {
        onClose?()
    }
    
    // MARK: - UI Helpers
    
    private func updateUIWithProducts() {
        guard let productToShow = monthlyProduct else {
            priceLabel.text = "Subscription info not available."
            return
        }
        
        let baseText = "Try 7 days for free\nthen \(productToShow.displayPrice) per week, auto-renewable"
        let priceText = productToShow.displayPrice
        
        let attributedString = NSMutableAttributedString(string: baseText)
        
        if let priceRange = baseText.range(of: priceText) {
            let nsRange = NSRange(priceRange, in: baseText)
            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor(named: "titleText") ?? .black
            ]
            attributedString.addAttributes(boldAttributes, range: nsRange)
        }
        
        priceLabel.attributedText = attributedString
    }
    
    private func showLoading(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        startNowBtn.isEnabled = !isLoading
        startNowBtn.alpha = isLoading ? 0.5 : 1.0
    }
    
    // MARK: - Alerts
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
