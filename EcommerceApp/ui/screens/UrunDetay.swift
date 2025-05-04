//
//  UrunDetay.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 2.05.2025.
//

import UIKit

class UrunDetay: UIViewController {
    
    
    @IBOutlet weak var labelUrunAd: UILabel!
    
    @IBOutlet weak var imageViewResim: UIImageView!
    
    @IBOutlet weak var labelAdet: UILabel!
    
    @IBOutlet weak var labelUrunFiyat: UILabel!
    
    @IBOutlet weak var tfAdet: UITextField!
    
    @IBOutlet weak var tfKullaniciAdi: UITextField!
    
    @IBOutlet weak var labelKategori: UILabel!
    
    @IBOutlet weak var labelMarka: UILabel!
    
    var urunDetayViewModel = UrunDetayViewModel()

    
    var urun:Urunler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfAdet.text = "1"
        if let tempUrun = urun {
            
            labelUrunAd.text = tempUrun.ad
            labelUrunFiyat.text = "\(tempUrun.fiyat!)₺"
            labelMarka.text=tempUrun.marka
            labelKategori.text=tempUrun.kategori
            
            let baseURL = "http://kasimadalan.pe.hu/urunler/resimler/"
            
            if let resimAdi = tempUrun.resim {
                let tamURLString = baseURL + resimAdi
                if let url = URL(string: tamURLString) {
                    imageViewResim.kf.setImage(with: url)
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnArttir(_ sender: Any) {
        print("Butona tıklandı")
        if let mevcutAdetText = tfAdet.text,
           let mevcutAdet = Int(mevcutAdetText) {
            let yeniAdet = mevcutAdet + 1
            tfAdet.text = String(yeniAdet)
        } else {
            tfAdet.text = "1"
        }
    }
    
    @IBAction func btnEkle(_ sender: Any) {
        
        if let siparisAdetiText = tfAdet.text,
           let siparisAdeti = Int(siparisAdetiText),
           let ad = labelUrunAd.text,
           let marka = labelMarka.text,
           let kategori = labelKategori.text,
           let urun = urun
        {
            let sepetId = 1 // örnek sabit ID, istersen dinamik yapabilirsin
            let resim = urun.resim ?? ""
            let fiyat = urun.fiyat ?? 0
            let kullaniciAdi = "meltemergul"
            urunDetayViewModel.kaydet(
                sepetId: sepetId,
                ad: ad,
                resim: resim,
                kategori: kategori,
                fiyat: fiyat,
                marka: marka,
                siparisAdeti: siparisAdeti,
                kullaniciAdi: kullaniciAdi
            )
           
        }
        self.performSegue(withIdentifier: "toSepetim", sender: nil)

    }
}

