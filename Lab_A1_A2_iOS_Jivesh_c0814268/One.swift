//
//  One.swift
//  Lab_A1_A2_iOS_Jivesh_c0814268
//
//  Created by user205607 on 9/19/21.
//

import UIKit
import CoreData

class Screen1: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!

    var pArray : [Products] = []
    var proArray : [Providers] = []
    var selectedProduct = true
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
            }
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromDB()
    }
    
    func fetchDataFromDB(){
        pArray = []
        pArray = try! context.fetch(Products.fetchRequest())
        addProducts()
        tableView.reloadData()
    }
    func getAllProviders(){
        proArray = []
        proArray = try! context.fetch(Providers.fetchRequest())
        //print(proArray)
        //print("aaa",proArray.endIndex)
        tableView.reloadData()
    }
    func addProducts(){
        
        
        if pArray.isEmpty{
          

            
            let provider = Providers(context: context)
            let provider2 = Providers(context: context)
            let product  = Products(context: context)
            let product2 = Products(context: context)
            let product3 = Products(context: context)
            let product4 = Products(context: context)
            
            provider.provider_name = "AppleJM"
            product.product_name = "iPhone SE"
            product.product_desc = "iPhone SE with nano-SIM cards, eSIM voice. Compatible with MagSafe accessories and wireless chargers."
            product.product_id = "111"
            product.product_price = "1000"
            product.provider = provider
            
            
            provider.provider_name = "AppleJM"
            product2.product_name = "iPhone X"
            product2.product_desc = "Super Retina XDR display with ProMotion. New 16-core Neural Engine"
            product2.product_id = "112"
            product2.product_price = "1100"
            product2.provider = provider
            
            provider2.provider_name = "SonyJM"
            product3.product_name = "WH Noise Cancelling Headphone"
            product3.product_desc = "High-quality wireless audio with BLUETOOTH and LDAC technology"
            product3.product_id = "222"
            product3.product_price = "500"
            product3.provider = provider2
            
            
            provider2.provider_name = "SonyJM"
            product4.product_name = "MDR Headphone"
            product4.product_desc = "High-Resolution Audio compatible with 70-mm HD driver units"
            product4.product_id = "333"
            product4.product_price = "150"
            product4.provider = provider2
            
            
            try! context.save()
            fetchDataFromDB()
        }
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        if selectedProduct {
                    performSegue(withIdentifier: "insertProduct", sender: self)
                }
                else{
                    showInputDialog(title: "Enter New Provider",
                                    actionTitle: "Add",
                                    cancelTitle: "Cancel",
                                    inputPlaceholder: "Provider",
                                    inputKeyboardType: .default, actionHandler:
                                        { (input:String?) in
                                            let req : NSFetchRequest<Providers> = Providers.fetchRequest()
                                            req.predicate = NSPredicate(format: "provider_name = '\(input!)'")
                                            let storeProvider = try! self.context.fetch(req)
                                            if storeProvider.count == 0{
                                                let provider = Providers(context: self.context)
                                                provider.provider_name = input
                                            }
                                            try! self.context.save()
                                            self.getAllProviders()
                                            
                                        })
                
            }
    }
    @IBAction func switchPressed(_ sender: UIButton) {
        if sender.title(for: .normal) == "Products"{
                    selectedProduct = true
                    fetchDataFromDB()
                    self.title = "Products"
                }
                else{
                    selectedProduct = false
                    getAllProviders()
                    self.title = "Providers"
                }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  sender is String{
                    if selectedProduct{
                        let vc = segue.destination as! ProductViewController
                        vc.product = pArray[tableView.indexPathForSelectedRow!.row]
                    }
                    else{
                        let vc = segue.destination as! ProviderProductViewController
                        vc.provider = proArray[tableView.indexPathForSelectedRow!.row]
                    }
        }
    }
}
extension Screen1 : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "product_name contains[c] '\(searchText)' || product_desc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Products> = Products.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                pArray = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            fetchDataFromDB()
            
        }
        tableView.reloadData()
    }
    
}
extension Screen1 : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedProduct{
           // print("product row:",pArray.count)
            return pArray.count
        }
        else{
           /*print("provider row:",proArray.count)
            print(proArray)
            print("------------")
            let set = Array(Set(proArray))
            print("nowcount=",set.count)*/
            return proArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          
          if selectedProduct{
            cell.textLabel?.text =
                pArray[indexPath.row].product_name
            cell.detailTextLabel?.text = pArray[indexPath.row].provider?.provider_name
            }
          else{
              cell.textLabel?.text = proArray[indexPath.row].provider_name
           // print(proArray[indexPath.row].provider_name)
              let req : NSFetchRequest<Products> = Products.fetchRequest()
              let productz = try! context.fetch(req)
              var count = 0
              for pro in productz{
                  if pro.provider?.provider_name == proArray[indexPath.row].provider_name{
                      count = count + 1
                    //  print(count,"matched product",proArray[indexPath.row].provider_name)
                  }
              }
              cell.detailTextLabel?.text = count.description
               
              
          }
        return cell
    }
    
    
}
extension Screen1 : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedProduct{
                    performSegue(withIdentifier: "showProducts", sender: "Main")
                }
                else{
                    performSegue(withIdentifier: "showProviders", sender: "Main")
                }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if selectedProduct{
                let objc = pArray[indexPath.row]
                context.delete(objc)
                try! context.save()
                fetchDataFromDB()
            }
            else{
                
                for prod in pArray{
                                    if prod.provider?.provider_name == proArray[indexPath.row].provider_name{
                                        context.delete(prod)
                                    }
                                }
                                context.delete(proArray[indexPath.row])
                                try! context.save()
                                getAllProviders()
            }
            
            
            
        }
    }
}
extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
