//
//  ViewController.swift
//  ShopifyTag
//
//  Created by Daian Aiziatov on 22/09/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//
import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var productViewController: ProductViewController? = nil
    var productList: [Products] = []
    var tagsList: [String] = []
    
    @IBOutlet weak var tagTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagTableView.dataSource = self
        readProductData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductListForTag" {
            if let indexPath = tagTableView.indexPathForSelectedRow {
                let selectedTag: String = self.tagsList[indexPath.row]
                let controller = segue.destination as! ProductViewController
                controller.selectedTag = selectedTag
                controller.productList = self.productList
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tagsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tagTableView.dequeueReusableCell(withIdentifier: "TagCell") else { return UITableViewCell() }
        let tag: String = self.tagsList[indexPath.row]
        cell.textLabel?.text = tag
        return cell
    }
    
    private func readProductData() {
        let urlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        Alamofire.request(urlString).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    if let products = json["products"] as? [[String: Any]] {
                        for product in products {
                            var productObject: Products = Products()
                            
                            // geting all product info
                            productObject.title = product["title"] as? String ?? ""
                            productObject.vendor = product["vendor"] as? String ?? ""
                            //calculating total inventory
                            var totalInventory = 0
                            if let variants = product["variants"] as? [[String: Any]] {
                                for variant in variants {
                                    if let inventory = variant["inventory_quantity"] as? Int {
                                        totalInventory += inventory
                                    }
                                }
                            }
                            productObject.totalAvail = totalInventory
                            
                            //making tagList for all products
                            if let tags = product["tags"] as? String {
                                let tagsForProduct = tags.components(separatedBy: ", ")
                                productObject.tags = tagsForProduct
                                for tag in tagsForProduct {
                                    if !self.tagsList.contains(tag) {
                                        self.tagsList.append(tag)
                                    }
                                    self.tagsList = self.tagsList.sorted(by: { $0 < $1 })
                                }
                            }
                            self.productList.append(productObject)
                            DispatchQueue.main.async {
                                self.tagTableView.reloadData()
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    
    }

}


