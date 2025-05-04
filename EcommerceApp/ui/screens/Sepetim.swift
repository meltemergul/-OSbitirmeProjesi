//
//  Sepetim.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 4.05.2025.
//

import UIKit
import Kingfisher
class Sepetim: UIViewController {

    
    @IBOutlet weak var collectionViewSepetim: UICollectionView!

    
    var sepetListesi = [Sepet]()
    var urunlerListesi=[Urunler]()
    var sepetViewModel = SepetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSepetim.delegate = self
        collectionViewSepetim.dataSource = self
        
        _ = sepetViewModel.sepetListesi.subscribe(onNext: { liste in
                    self.sepetListesi = liste
                    DispatchQueue.main.async {
                        self.collectionViewSepetim.reloadData()
                    }
                })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let kullaniciAdi = "meltemergul"
        sepetViewModel.sepetiYukle(kullaniciAdi: kullaniciAdi)
     }

}
extension Sepetim: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView (_: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return sepetListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "sepetHucre",for:indexPath) as! SepetHucre

        let sepet = sepetListesi[indexPath.row]
   
               let baseURL = "http://kasimadalan.pe.hu/urunler/resimler/"
               if let resimAdi = sepet.resim {
                   let tamURLString = baseURL + resimAdi
                   if let url = URL(string: tamURLString) {
                       hucre.imageViewResim.kf.setImage(with: url)
                   }
               }
               
            
               hucre.labelUrunAd.text = sepet.ad
               if let fiyat = sepet.fiyat {
                   hucre.labelFiyat.text = "\(fiyat)₺"
               }
        if let adet = sepet.siparisAdeti {
            hucre.labelAdet.text = "\(adet) adet"
        }
     
               return hucre
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.size.width // Hücrenin genişliği
           let sepet = sepetListesi[indexPath.row]
           
           // Burada her hücrenin yüksekliğini içerik miktarına göre dinamik olarak belirleyebilirsiniz
           let itemHeight: CGFloat = sepet.ad?.count ?? 0 > 50 ? 200 : 120 // Örneğin, başlık uzunluğuna göre yükseklik

           return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView,
                           trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           let silAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, _ in
               let sepet = self.sepetListesi[indexPath.row]
               
               let alert = UIAlertController(title: "Silme İşlemi", message: "\(sepet.ad ?? "Ürün") silinsin mi?", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
               
               alert.addAction(UIAlertAction(title: "Evet", style: .destructive) { _ in
                   if let sepetId = sepet.sepetId,let kullaniciAdi=sepet.kullaniciAdi {
                       self.sepetViewModel.sil(sepetId: sepetId,kullaniciAdi: kullaniciAdi)
                       
                   }
               })
               
               self.present(alert, animated: true)
           }
           
           return UISwipeActionsConfiguration(actions: [silAction])
       }
    
}
