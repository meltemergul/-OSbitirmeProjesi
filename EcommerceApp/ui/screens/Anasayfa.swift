//
//  Anasayfa.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 30.04.2025.
//

import UIKit
import Kingfisher
import Lottie

class Anasayfa: UIViewController {

    var animationView: LottieAnimationView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var urunlerCollectionView: UICollectionView!
    
    var urunlerListesi = [Urunler]()
    var anasayfaViewModel = AnasayfaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        urunlerCollectionView.delegate=self
        urunlerCollectionView.dataSource=self
        _ = anasayfaViewModel.urunlerListesi.subscribe(onNext: { liste in//Dinleme
                   self.urunlerListesi = liste
                   DispatchQueue.main.async {
                       self.urunlerCollectionView.reloadData()
                       self.hideLoadingAnimation()
                   }
               })
    }
    func showLoadingAnimation() {
        animationView = .init(name: "loading")
        animationView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // SearchBar'ın hemen altına hizalayalım
        if let searchBarFrame = searchBar?.frame {
            let yPosition = searchBarFrame.origin.y + searchBarFrame.height + 50
            animationView?.center = CGPoint(x: self.view.center.x, y: yPosition + 50) // ortala + hafif boşluk
        } else {
            animationView?.center = self.view.center
        }
        
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1.0
        if let anim = animationView {
            self.view.addSubview(anim)
            anim.play()
        }
    }


       func hideLoadingAnimation() {
           animationView?.stop()
           animationView?.removeFromSuperview()
           animationView = nil
       }

    override func viewWillAppear(_ animated: Bool) {
        anasayfaViewModel.urunleriYukle()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("Geçiş yapıldı")
         if segue.identifier == "toDetay" {
             print("toDetay çalıştı")
             //Any : bütün sınıfların üstündedir.Java Object
             if let urun = sender as? Urunler {//as? downcasting : Super class > Sub class dönüştürmektir.
                 print("Veri : \(urun.ad!)")
          let gidilecekVC = segue.destination as! UrunDetay
                 //as? : downcasting,hata olma ihtimali yüksekse bunu kullanıyoruz.
                 //as! : downcasting,hata olma ihtimali düşükse bunu kullanıyoruz.
            gidilecekVC.urun = urun
             }
         }
     }
     
    
}
extension Anasayfa : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.anasayfaViewModel.ara(aramaKelimesi: searchText)
        }
    }
}
extension Anasayfa: UICollectionViewDelegate,UICollectionViewDataSource{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urunlerListesi.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "UrunlerHucre", for: indexPath) as! UrunlerHucre
        
        let urun=urunlerListesi[indexPath.row]
        
        let baseURL = "http://kasimadalan.pe.hu/urunler/resimler/"

        if let resimAdi = urun.resim {
              let tamURLString = baseURL + resimAdi
              if let url = URL(string: tamURLString) {
                  hucre.imageviewUrun.kf.setImage(with: url)
              }
          }

        hucre.labelUrunAd.text=urun.ad
        hucre.labelUrunFiyat.text="\(urun.fiyat!)₺"
        
        return hucre
    }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let urun = urunlerListesi[indexPath.row]
             performSegue(withIdentifier: "toDetay", sender: urun)
             collectionView.deselectItem(at: indexPath, animated: true)
    }

    
}
extension Anasayfa: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let ekranGenisligi = UIScreen.main.bounds.width
        let bosluk: CGFloat = 3
        let hucreSayisi: CGFloat = 2  // Yani 2 sütun

        let genislik = (ekranGenisligi - (bosluk * (hucreSayisi + 1))) / hucreSayisi
        return CGSize(width: genislik, height: genislik ) // 30 kadar etiket yüksekliği
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3 // Sütunlar arası boşluk
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6 // Satırlar arası boşluk
    }
}

