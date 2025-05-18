//
//  DetailsViewController.swift
//  StoreApp
//
//  Created by Vijai S on 17/05/25.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var BackBtnView: UIView!
    @IBOutlet weak var productCountView: UIView!
    @IBOutlet weak var PageTitleLbl: UILabel!
    
    @IBOutlet weak var addCartView: UIView!
    @IBOutlet weak var ImgCollectioView: UICollectionView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var ProductPriceLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var CountView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var lessView: UIView!

    var productID = 1
    var currentQuantity: Int = 0
    let maxCount: Int = 9
    let minCount: Int = 0
    var Viewmodel = ProductDetailAPI.shared

    @IBAction func BackBtn_Act(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productCountView.makeRounded()
        self.CountView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
        self.addView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
        self.lessView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
        self.fetchproductDetails()
        self.BackBtnView.makeRounded()
        self.addCartView.setCornerRadius(radius: 5)
        self.registerCV()
    }

    func Initialsetup(){
        let productlist = self.Viewmodel.productDetailtModel?.productDetails.productInfoDetails.first
        self.productTitleLbl.text = productlist?.title ?? ""
        self.PageTitleLbl.text = productlist?.title ?? ""
        self.ProductPriceLbl.text = "Rs \(productlist?.finalPrice ?? 0)"
        self.productQuantityLbl.text = "\(currentQuantity)"
        if let htmlDescription = productlist?.description {
            if let attributedString = htmlDescription.htmlToAttributedString {
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                let range = NSRange(location: 0, length: mutableAttributedString.length)
                mutableAttributedString.addAttributes([
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.darkGray
                ], range: range)
                DescLbl.attributedText = mutableAttributedString
            } else {
                DescLbl.text = productlist?.description.htmlToString ?? "No description available"
            }
        } else {
            DescLbl.text = "No description available"
        }
    }
    func registerCV(){
        self.ImgCollectioView.register(UINib(nibName: "DetailsImgCVCell", bundle: nil), forCellWithReuseIdentifier: "DetailsImgCVCell")
        self.ImgCollectioView.delegate = self
        self.ImgCollectioView.dataSource = self
    }
    func fetchproductDetails() {
        ProductDetailAPI.shared.fetchProductDetails(productID: productID) { result in
            switch result {
            case .success:
                self.Initialsetup()
                self.ImgCollectioView.reloadData()
            case .failure(let error):
                print("Error fetching product details: \(error.localizedDescription)")
                let alert = UIAlertController(title: nil, message: "Somthing went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in 
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    

    @IBAction func AddCartBtn_Act(_ sender: Any) {
        if currentQuantity > 0 {
            currentQuantity = 0
            productQuantityLbl.text = "\(currentQuantity)"
        } else {
            showAlert(message: "Please select at least 1 item")
        }
    }

    @IBAction func LessBtn_Act(_ sender: Any) {
        if currentQuantity > minCount {
            currentQuantity -= 1
            productQuantityLbl.text = "\(currentQuantity)"
        } else {
            showAlert(message: "Quantity can't be less than \(minCount)")
        }
    }

    @IBAction func AddBtn_Act(_ sender: Any) {
        if currentQuantity < maxCount {
            currentQuantity += 1
            productQuantityLbl.text = "\(currentQuantity)"
        } else {
            showAlert(message: "Maximum \(maxCount) items allowed")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Viewmodel.productDetailtModel?.productDetails.productImageDetails.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsImgCVCell", for: indexPath) as! DetailsImgCVCell
        let productlist = self.Viewmodel.productDetailtModel?.productDetails.productImageDetails[indexPath.row]
        if let imageUrl = productlist?.originalImage {
            cell.DetailProductImgView.sd_setImage(with: URL(string: imageUrl))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print("Error converting HTML: \(error)")
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
