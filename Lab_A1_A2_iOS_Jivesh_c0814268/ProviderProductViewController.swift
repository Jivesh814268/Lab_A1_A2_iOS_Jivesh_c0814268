//
//  ProviderProductViewController.swift
//  Lab_A1_A2_iOS_Jivesh_c0814268
//
//  Created by user205607 on 9/20/21.
//

import UIKit
import CoreData

class ProviderProductViewController: UITableViewController {
    var provider : Providers?
    var products : [Products] = []
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = provider{
            let req : NSFetchRequest<Products> =  Products.fetchRequest()
            products = try! context.fetch(req)
            products = products.filter({$0.provider?.provider_name == provider?.provider_name})
            tableView.reloadData()
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text =
            products[indexPath.row].product_name
        cell.detailTextLabel?.text = products[indexPath.row].provider?.provider_name

        return cell
    }
    

}
