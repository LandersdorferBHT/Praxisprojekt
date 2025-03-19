//
//  AnalysisTableViewController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 13.02.25.
//

import UIKit
import SwiftUI
import Charts

class AnalysisTableViewController: UITableViewController {
    
    // List of all available products
    public var products: [Product] = []
    
    // Inventory management instance
    private var inventoryManager: InventoryManager?
    
    private var diagramSpecTitle = "Alle Geräte"
    
    // Sales data analaysis period
    private let salesPeriod = 30
    
    // Variables for sales and stock data analysis
    private var topSales: [(name: String, count: Int)] = []
    private var lowSales: [(name: String, count: Int)] = []
    private var stockCount = 0
    private var averageStockDuration = 0
    private var categorySales: [(category: String, count: Int)] = []
    private var salesTrend: [Date: Int] = [:]
    private var stockAge: (newStockCount: Int, oldStockCount: Int) = (0, 0)
    private var colorSales: [(color:String, count: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize inventory manager with available products
        inventoryManager = InventoryManager(products: products)
        
        // Table view layout
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "analyseCell")

        setupMenu()
        
        // Load initital data for all devices
        updateDataForCategory("Alle Geräte")
    }
    
    /// Creates a menu for selecting a device category
    private func setupMenu() {
        let menu = UIMenu(title: "Kategorie wählen", children: [
            UIAction(title: "Alle Geräte", handler: { _ in self.updateDataForCategory("Alle Geräte") }),
            UIAction(title: "iPhone", handler: { _ in self.updateDataForCategory("iPhone") }),
            UIAction(title: "iPad", handler: { _ in self.updateDataForCategory("iPad") }),
            UIAction(title: "Apple Watch", handler: { _ in self.updateDataForCategory("Apple Watch") }),
            UIAction(title: "AirPods", handler: { _ in self.updateDataForCategory("AirPods") })
        ])
        
        let popupButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
        popupButton.menu = menu
        navigationItem.rightBarButtonItem = popupButton
    }
    
    /// Filters data based on the selected category and updates the view
    private func updateDataForCategory(_ category: String) {
        let filteredProducts: [Product]

        switch category {
        case "iPhone":
            filteredProducts = inventoryManager?.getAllProducts().filter { $0.id.lowercased().contains("iphone") } ?? []
            diagramSpecTitle = "iPhone"

        case "iPad":
            filteredProducts = inventoryManager?.getAllProducts().filter { $0.id.lowercased().contains("ipad") } ?? []
            diagramSpecTitle = "iPad"
            
        case "Apple Watch":
            filteredProducts = inventoryManager?.getAllProducts().filter { $0.id.lowercased().contains("watch") } ?? []
            diagramSpecTitle = "Watch"
            
        case "AirPods":
            filteredProducts = inventoryManager?.getAllProducts().filter { $0.id.lowercased().contains("airpods") } ?? []
            diagramSpecTitle = "AirPods"

        default:
            filteredProducts = inventoryManager?.getAllProducts() ?? []
            diagramSpecTitle = "Alle Geräte"

        }
        
        updateAnalysisData(for: filteredProducts)
        tableView.reloadData()
    }

    /// Updates all analysis data using the 'InventoryManager'
    private func updateAnalysisData(for products: [Product]) {
        let tempManager = InventoryManager(products: products)
        
        stockCount = tempManager.getStockCount()
        stockAge = tempManager.getStockAge()
        topSales = tempManager.getTopSales()
        lowSales = tempManager.getLowSales()
        categorySales = tempManager.getCategorySales()
        averageStockDuration = tempManager.getAverageStockDuration()
        salesTrend = tempManager.getSalesTrend(period: salesPeriod)
        colorSales = tempManager.getColorSales()
    }

    // MARK: - TableView DataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "analyseCell", for: indexPath)
        
        // Remove old SwiftUI views before adding new ones
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let chartView: AnyView
        switch indexPath.section {
        case 0:
            chartView = AnyView(SalesChartView(salesData: topSales, chartTitle: "Meistverkaufte Geräte"))
        case 1:
            chartView = AnyView(SalesChartView(salesData: lowSales, chartTitle: "Schlechtverkaufte Geräte"))
        case 2:
            chartView = AnyView(SalesChartView(salesData: [("Geräte im Lager", stockCount)], chartTitle: "Lagernde Geräte"))
        case 3:
            chartView = AnyView(AverageStockDurationChartView(averageDays: averageStockDuration))
        case 4:
            chartView = AnyView(CategorySalesChartView(salesData: categorySales))
        case 5:
            chartView = AnyView(SalesTrendChartView(salesData: salesTrend, selectedPeriod: salesPeriod))
        case 6:
            chartView = AnyView(StockAgeChartView(newStockCount: stockAge.newStockCount, oldStockCount: stockAge.oldStockCount))
        case 7:
//            chartView = AnyView(WorstPerformersChartView(salesData: lowSales))
            chartView = AnyView(ColorSalesChartView(salesData: colorSales))
        default:
            return cell
        }
        
        // Embed SwiftUI view into UIKit TableView cell
        let hostingController = UIHostingController(rootView: chartView)
        addChild(hostingController)
        cell.contentView.addSubview(hostingController.view)
        
        // Setting constraints to fit the SwiftUI view inside a cell
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Meistverkaufte Geräte - \(diagramSpecTitle)"
        case 1:
            return "Schlechtverkaufte Geräte - \(diagramSpecTitle)"
        case 2:
            return "Lagernde Geräte - \(diagramSpecTitle)"
        case 3:
            return "Durch. Lagerdauer - \(diagramSpecTitle)"
        case 4:
            return "Meistverkaufte Kategorien - \(diagramSpecTitle)"
        case 5:
            return "Verkaufstrends - \(diagramSpecTitle)"
        case 6:
            return "Lagerbestand – Neu vs. Alt - \(diagramSpecTitle)"
        case 7:
            return "Beliebteste Farben - \(diagramSpecTitle)"
        default:
            return nil
        }
    }
}
