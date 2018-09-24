//
//  ProductViewController.swift
//  ShopifyTag
//
//  Created by Daian Aiziatov on 23/09/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productVendor: UILabel!
    @IBOutlet weak var totalAvail: UILabel!
}

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productTableView: UITableView!
    
    var productList: [Products]? {
        didSet {
            // Update the view.
        }
    }
    var selectedTag: String? {
        didSet {
            // Update the view.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getProductListForTag().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productTableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductTableViewCell else { return UITableViewCell() }
        let product: Products = getProductListForTag()[indexPath.row]
        cell.productTitle.text = product.title
        cell.totalAvail.text = "Available: \n \(product.totalAvail)"
        cell.productVendor.text = product.vendor
        return cell
    }
    
    func getProductListForTag() -> [Products] {
        var productListForTag: [Products] = []
        if let tagForProductList = selectedTag {
            for product in self.productList! {
                for tag in product.tags {
                    if tag == tagForProductList {
                        productListForTag.append(product)
                    }
                }
            }
        }
        return productListForTag
    }


}
