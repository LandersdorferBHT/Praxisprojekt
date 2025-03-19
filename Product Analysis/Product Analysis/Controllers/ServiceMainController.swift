//
//  ServiceMainController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 26.02.25.
//

import UIKit
import Vision
import VisionKit
import CoreData

class ServiceMainController: UIViewController, VNDocumentCameraViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    private let progressBarView = UIView()
//    private let newOrdersView = UIView()
//    private let oldOrdersView = UIView()
//    private let completedOrdersView = UIView()
//    
//    private let newOrdersLabel = UILabel()
//    private let oldOrdersLabel = UILabel()
//    private let completedOrdersLabel = UILabel()
    
    // Setting up table view
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private var indicatorContainerView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var newOrdersCount = 0
    private var oldOrdersCount = 0
    private var completedOrdersCount = 0
    
    private var scannedOrders: [ServiceOrder] = []
    private var selectedServicerOrder: ServiceOrder?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
//        setupProgressBar()
        setupTableView()
        setupIndicatorContainer()
        loadDataFromCoreData()
    }
    
    // Configures the navigation bar and adds a camera button to the top right
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action: #selector(scanButtonTapped)
        )
    }
    
    // Initializes and configures the table view
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // Set up an acitivty indicator overlay for loading processes
    private func setupIndicatorContainer() {
        
        // Background view
        indicatorContainerView = UIView()
        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainerView.backgroundColor = .systemGray
        indicatorContainerView.layer.cornerRadius = 10
        indicatorContainerView.clipsToBounds = true

        // Setting up activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        // Add indicator to background-container
        indicatorContainerView.addSubview(activityIndicator)
        view.addSubview(indicatorContainerView)
        
        NSLayoutConstraint.activate([
            indicatorContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicatorContainerView.widthAnchor.constraint(equalToConstant: 100),
            indicatorContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorContainerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorContainerView.centerYAnchor)
        ])
        
        // Hidden by default
        indicatorContainerView.isHidden = true
    }
    
    /// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showServiceDetailController" {
            if let destVC = segue.destination as? ServiceDetailViewController {
                destVC.serviceOrder = selectedServicerOrder
            }
        }
    }

    
    
    // MARK: - CoreData Funktionen
    
    // Fetches all saved service orders from core data
    private func loadDataFromCoreData() {
        if let entities = CoreDataManager.shared.fetchAllServiceOrders() {
            self.scannedOrders = entities  // Hier werden direkt ServiceOrder-Objekte zugewiesen
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Saves a new service order to core data and refreshes the table view
    private func saveOrderToCoreData(serviceOrder: ServiceOrder) {
        // Speichern der ServiceOrder-Objekte über den CoreDataManager
        CoreDataManager.shared.saveServiceOrder(serviceOrder: serviceOrder)
        loadDataFromCoreData()  // Nach dem Speichern die Daten neu laden
    }
    
    // Deletes a service order from core data and updates the UI
    private func deleteOrderFromCoreData(order: ServiceOrder) {
        if let orderEntity = CoreDataManager.shared.findServiceOrderEntity(by: order) {
            CoreDataManager.shared.deleteServiceOrder(serviceOrder: orderEntity)
            loadDataFromCoreData()
        }
    }
    
    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let order = scannedOrders[indexPath.row]
        
        let displayText = """
        Auftragsnummer: \(order.orderNumber ?? "Nicht gefunden")
        Name: \(order.name)
        Datum: \(order.date ?? "Nicht gefunden")
        """
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = displayText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedServicerOrder = scannedOrders[indexPath.row]
        performSegue(withIdentifier: "showServiceDetailController", sender: self)
    }
    
    // Handles swipe to delete function in table view
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Löschen") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }

            guard indexPath.row < self.scannedOrders.count else {
                print("Fehler: Index ist außerhalb des Bereichs!")
                completionHandler(false)
                return
            }

            let orderToDelete = self.scannedOrders[indexPath.row]

            self.scannedOrders.remove(at: indexPath.row)

            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }) { finished in

                if self.scannedOrders.isEmpty {
                    tableView.reloadData()
                }
        
                completionHandler(true)
            }

            DispatchQueue.global(qos: .background).async {
                self.deleteOrderFromCoreData(order: orderToDelete)
            }
        }

        deleteAction.image = UIImage(systemName: "trash.fill")

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = true

        return swipeActions
    }

    
    // MARK: - Document Scanning
    
    // Opens the document scanner when camera button is tapped
    @objc private func scanButtonTapped() {
        guard VNDocumentCameraViewController.isSupported else {
            showAlert(message: "Dieses Gerät unterstützt keinen Scanner.")
            return
        }
        
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    // Displays an alert with a given message
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hinweis", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Text Recognition
    
    // Processes the scanned document, extracting text for further processing
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        
        guard scan.pageCount > 0 else { return }
        
        let scannedImage = scan.imageOfPage(at: 0)
        
        DispatchQueue.main.async {
            self.indicatorContainerView.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        recognizeText(from: scannedImage)
    }
    
    // Uses Vision framework to recognize text from an image
    private func recognizeText(from image: UIImage) {
        
        // Ensures the image can be converted to a Core Graphics image format
        guard let cgImage = image.cgImage else { return }
        
        // Text recognition request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.indicatorContainerView.isHidden = true
                }
                
                return
            }
            
            // Extract recognized text from the results and join them into a single string
            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            
            // Pass the extracted text and image data to next processing step
            self.extractRelevantData(from: extractedText, imageData: image.jpegData(compressionQuality: 1.0))
        }
        
        request.recognitionLevel = .accurate
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Perform request async on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("Error while recognizing Text: \(error)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.indicatorContainerView.isHidden = true
                }
            }
        }
    }

    // The regex patterns are completely generated by ChatGPT
    // I developed the foundational structure of this algorithm, utilizing ChatGPT to assist with optimizing its organization
    private func extractRelevantData(from text: String, imageData: Data?) {
        
        // Split text into lines and trim whitespace and new lines
        let lines = text.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        // Flags and storage variables for extracted information
        var foundLocationHeader = false
        var extractedLines: [String] = []
        var phoneNumber: String?
        var email: String?
        var orderNumber: String?
        var customerNumber: String?
        var date: String?
        
        for line in lines {
            
            // Extract Phone Number
            if phoneNumber == nil, let phone = extractRegexMatch(from: line, pattern: #"(\+49|0)[1-9][0-9]{8,}"#) {
                phoneNumber = phone
                print("Gefundene Telefonnummer: \(phoneNumber!)")
            }
            
            // Extract Email Address
            if email == nil, let mail = extractRegexMatch(from: line, pattern: #"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#) {
                email = mail
                print("Gefundene E-Mail: \(email!)")
            }
            
            // Identify and extract address details
            if foundLocationHeader {

                // Stop extracting if an email or phone number is found
                if line.contains("@") || line.range(of: #"\+49|0[1-9][0-9]{8,}"#, options: .regularExpression) != nil {
                    foundLocationHeader = false
                    continue
                }
                extractedLines.append(line)
            }
            
            // Check for a key word that marks beginning of an address section
            if line.lowercased().contains("standort / lieferanschrift") {
                foundLocationHeader = true
                continue
            }
            
            // Extract Order Number
            if orderNumber == nil, line.lowercased().contains("auftragsnummer") {
                if let orderNum = extractRegexMatch(from: line, pattern: #"A\d{6}"#) {
                    orderNumber = orderNum
                    print("Gefundene Auftragsnummer: \(orderNumber!)")
                } else {
                    print("Keine Auftragsnummer gefunden in Zeile: \(line)")
                }
            }
            
            // Extract Date of service
            if orderNumber != nil, date == nil, line.lowercased().contains("vom") {
                if let extractedDate = extractRegexMatch(from: line, pattern: #"\d{2}\.\d{2}\.\d{4}"#) {
                    date = extractedDate
                    print("Gefundenes Datum: \(date!)")
                } else {
                    print("Kein Datum gefunden in Zeile: \(line)")
                }
            }
            
            // Extract Customer Number
            if customerNumber == nil, line.lowercased().contains("kundennummer") {
                if let customerNum = extractRegexMatch(from: line, pattern: #"\d{5}"#) {
                    customerNumber = customerNum
                    print("Gefundene Kundennummer: \(customerNumber!)")
                } else {
                    print("Keine Kundennummer gefunden in Zeile: \(line)")
                }
            }
        }
        
        // Use the first extracted lines as the name and join the rest as an address
        let name = extractedLines.first ?? "Nicht gefunden"
        let address = extractedLines.dropFirst().joined(separator: ", ")
        
//        print("Endgültige Adresse: \(address)")
//        print("Endgültige Telefonnummer: \(phoneNumber ?? "Nicht gefunden")")
//        print("Endgültige E-Mail: \(email ?? "Nicht gefunden")")
//        print("Endgültige Auftragsnummer: \(orderNumber ?? "Nicht gefunden")")
//        print("Endgültige Kundennummer: \(customerNumber ?? "Nicht gefunden")")
//        print("Endgültiges Datum: \(date ?? "Nicht gefunden")")
        
        // Create new 'ServiceOrder' object with the extracted data
        let serviceOrder = ServiceOrder(
            name: name,
            address: address,
            phone: phoneNumber,
            email: email,
            scannedDocument: imageData,
            orderNumber: orderNumber,
            customerNumber: customerNumber,
            date: date
        )
        
        // Save extracted data to core data
        saveOrderToCoreData(serviceOrder: serviceOrder)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.indicatorContainerView.isHidden = true
        }
    }

    // Extract a pattern match from a string using using regular expressions (regex)
    private func extractRegexMatch(from text: String, pattern: String) -> String? {
        do {
            // The following Code was written with help of ChatGPT
            // Create a regex object with the given pattern
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: text.utf16.count)
            
            // Find the first match in the text
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                // Return matching substring
                return (text as NSString).substring(with: match.range)
            }
        } catch {
            print("Error with regex: \(error)")
        }
        return nil
    }
    
}
