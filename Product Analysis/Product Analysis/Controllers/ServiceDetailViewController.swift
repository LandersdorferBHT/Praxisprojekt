//
//  ServiceDetailViewController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 04.03.25.
//

import UIKit

class ServiceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DocumentCellDelegate {
    
    public var serviceOrder: ServiceOrder?
    
    // Variables to handle full-screen image display
    private var fullScreenImageView: UIImageView?
    private var animator: UIViewPropertyAnimator?
    private var originalFrame: CGRect = .zero
    private var originalImageView: UIImageView?
    
    // TableView setup
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = serviceOrder?.orderNumber ?? "Auftrag"
        
        setupTableView()
    }
    
    // Sets up the table view, indluding layout constraints and cell registrations
    private func setupTableView() {
        view.addSubview(tableView)
        
        // Constraints for table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register table view cells
        tableView.register(DetailTextCell.self, forCellReuseIdentifier: "DetailTextCell")
        tableView.register(DetailDocumentCell.self, forCellReuseIdentifier: "DetailDocumentCell")
    }
    
    // Called when an image inside a document cell is tapped
    func didTapImageView(_ imageView: UIImageView) {
        showFullScreenImage(imageView: imageView)
    }
    
    // Displays an image in full-scren mode with an animation
    func showFullScreenImage(imageView: UIImageView) {
        guard let image = imageView.image,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        // Store refernce to the original image view and hide it
        originalImageView = imageView
        imageView.alpha = 0
        
        // Compute original frame relative to window
        originalFrame = imageView.superview?.convert(imageView.frame, to: window) ?? .zero
        
        let zoomImageView = UIImageView(frame: originalFrame)
        zoomImageView.image = image
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        zoomImageView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        zoomImageView.addGestureRecognizer(tapGesture)
        
        window.addSubview(zoomImageView)
        fullScreenImageView = zoomImageView
        
        let animator = UIViewPropertyAnimator(duration: 0.65, dampingRatio: 0.8) {
            // Expand image to full screen
            zoomImageView.frame = window.bounds
            zoomImageView.alpha = 1
        }
        animator.startAnimation()
    }
    
    // Dismisses the full-screen image view with an animation (shrinks back)
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        guard let zoomImageView = sender.view as? UIImageView else { return }
        
        let animator = UIViewPropertyAnimator(duration: 0.55, dampingRatio: 0.8) {
            zoomImageView.backgroundColor = .clear
            zoomImageView.frame = self.originalFrame
            zoomImageView.alpha = 1
        }
        animator.addCompletion { _ in
            zoomImageView.removeFromSuperview()
            // Restore original image view visibility
            self.originalImageView?.alpha = 1
        }
        animator.startAnimation()
    }
    
    // MARK: - TableView Data Source Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3  // Service order details
        case 1: return 4  // Customer details
        case 2: return 1  // Attached document
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailDocumentCell", for: indexPath) as! DetailDocumentCell
            if let imageData = serviceOrder?.scannedDocument,
               let image = UIImage(data: imageData) {
                cell.delegate = self
                cell.configure(with: image)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTextCell", for: indexPath) as! DetailTextCell
            let text = getTextForIndexPath(indexPath)
            cell.configure(with: text)
            return cell
        }
    }
    
    // Header-Titel für die Abschnitte
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Auftragsdaten"
        case 1: return "Kundendaten"
        case 2: return "Dokument"
        default: return nil
        }
    }
    
    // Retrieves the appropriatetext for a given index path
    private func getTextForIndexPath(_ indexPath: IndexPath) -> String {
        guard let order = serviceOrder else { return "N/A" }
        switch (indexPath.section, indexPath.row) {
        case (0, 0): return "Auftragsnummer: \(order.orderNumber ?? "")"
        case (0, 1): return "Auftragsdatum: \(order.date ?? "")"
        case (0, 2): return "Kundennummer: \(order.customerNumber ?? "")"
        case (1, 0): return "Name: \(order.name)"
        case (1, 1): return "Adresse: \(order.address)"
        case (1, 2): return "Telefon: \(order.phone ?? "")"
        case (1, 3): return "E-Mail: \(order.email ?? "")"
        default: return "N/A"
        }
    }
}
