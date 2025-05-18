//
//  HomeViewController.swift
//  StoreApp
//
//  Created by Vijai S on 17/05/25.
//

import UIKit
import SDWebImage
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var productListCV: UICollectionView!
    @IBOutlet weak var cartCountView: UIView!
    
    var Viewmodel = ProductAPI.shared
    var pageNum: Int = 1
    var ProductsData : ProductResponse?
    var gotresponse = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productModel:[Product] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isOfflineMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.registerCV()
        self.ProductsData = ProductResponse(searchProductMobile: [], totalCount: 0)
        self.loadData()
    }
        
        func loadData() {
            if Reachability.isConnectedToNetwork() {
                isOfflineMode = false
                self.ApiCallFunction()
            } else {
                isOfflineMode = true
                self.ProductsData?.searchProductMobile = self.productModel
                self.loadFromCoreData()
                showOfflineAlert()
            }
        }
    
    func loadFromCoreData() {
        do {
            self.fetchModelObjects { [weak self] Products in
                self?.productModel = Products
                self?.ProductsData?.searchProductMobile = Products
                DispatchQueue.main.async {
                    self?.productListCV.reloadData()
                }
            }
        } catch {
            print("Fetching Failed \(error)")
        }
    }
    
    func setViews(){
        self.cartCountView.makeRounded()
    }
    
    func registerCV(){
        self.productListCV.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.productListCV.delegate = self
        self.productListCV.dataSource = self
    }
    func ApiCallFunction(){
        ProductAPI.shared.fetchProducts(pageNumber: pageNum, pageSize: 5) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if self.ProductsData == nil {
                    self.ProductsData = response
                } else {
                    // Append new products and update total count
                    self.ProductsData?.searchProductMobile.append(contentsOf: response.searchProductMobile)
                    self.ProductsData?.totalCount = response.totalCount
                }
                let saved = self.saveDataToCoreData(items: response.searchProductMobile)
                if saved{
                }
                DispatchQueue.main.async {
                    self.productListCV.reloadData()
                    self.gotresponse = true
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.gotresponse = true
            }
        }
    }
    
    func showOfflineAlert() {
        let alert = UIAlertController(title: "Offline Mode",
                                    message: "You're viewing cached data. Some features may be limited.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    // MARK: - Core Data Methods
    func saveDataToCoreData(items: [Product]) -> Bool {
        let managedContext = self.appDelegate.persistentContainer.viewContext
        var success = true
        
        do {
            for item in items {
                let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "productId == %d", item.societyProductID)
                
                let results = try managedContext.fetch(fetchRequest)
                
                if let existingProduct = results.first {
                    existingProduct.setValue(item.finalPrice, forKey: "price")
                    existingProduct.setValue(item.title, forKey: "title")
                    existingProduct.setValue(item.thumbImage, forKey: "imageUrl")
                    existingProduct.setValue(item.totalCount, forKey: "totalCount")
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: managedContext)!
                    let newItem = NSManagedObject(entity: entity, insertInto: managedContext)
                    newItem.setValue(item.societyProductID, forKey: "productId")
                    newItem.setValue(item.finalPrice, forKey: "price")
                    newItem.setValue(item.title, forKey: "title")
                    newItem.setValue(item.thumbImage, forKey: "imageUrl")
                    newItem.setValue(item.totalCount, forKey: "totalCount")
                }
            }
            
            if self.ProductsData?.searchProductMobile.count ?? 0 <= self.ProductsData?.totalCount ?? 0 {
                try managedContext.save()
                self.fetchModelObjects { Products in
                    self.productModel = Products
                }
            } else {
                success = false
            }
        } catch {
            print("Error saving to CoreData: \(error)")
            success = false
        }
        
        return success
    }
       
    func fetchModelObjects(completion: @escaping ([Product]) -> Void) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        var users: [Product] = []
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let societyProductID = data.value(forKey: "productId") as? Int ?? 0
                let finalPrice = data.value(forKey: "price") as? Int ?? 0
                let title = data.value(forKey: "title") as? String ?? ""
                let thumbImage = data.value(forKey: "imageUrl") as? String ?? ""
                let totalCount = data.value(forKey: "totalCount") as? Double ?? 0.0
                let result = Product(societyProductID: Int(societyProductID), title: title, originalImage: thumbImage, thumbImage: thumbImage, finalPrice: Double(finalPrice), mrp: 0.0, cartQuantity: 0, totalCount: Int(totalCount), cartId: 0, cartCount: 0, unit: "")
                users.append(result)
            }
            completion(users)
        } catch {
            print("Error fetching data from CoreData: \(error)")
            completion(users)
        }
    }
    private func updateCart(productId: Int, quantity: Int) {
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ProductsData?.searchProductMobile.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let productlist = self.ProductsData?.searchProductMobile[indexPath.row]
        cell.showAlert = { [weak self] message in
               let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               self?.present(alert, animated: true)
           }
           
           cell.updateCartAction = { [weak self] quantity in
               self?.updateCart(productId: productlist?.societyProductID ?? 0, quantity: quantity)
           }
        cell.ProductPriceLbl.text = "Rs \(productlist?.finalPrice ?? 0)"
        if let imageUrl = productlist?.thumbImage {
            cell.productimgView.sd_setImage(with: URL(string: imageUrl))
        }
        cell.productTitleLbl.text = productlist?.title ?? ""
        cell.maxCount = productlist?.totalCount ?? 0
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        let productlist = self.ProductsData?.searchProductMobile[indexPath.row]
        vc.productID = productlist?.societyProductID ?? 0
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight * 2 {
            let productListCount = self.ProductsData?.searchProductMobile.count ?? 0
            let totalCount = self.ProductsData?.totalCount ?? 0
            
            if productListCount < totalCount && self.gotresponse {
                self.gotresponse = false
                self.pageNum += 1
                self.ApiCallFunction()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/2) - 10
        return CGSize(width: width, height: 360)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
