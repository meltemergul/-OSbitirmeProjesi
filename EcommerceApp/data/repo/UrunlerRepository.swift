//
//  UrunlerRepository.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 30.04.2025.
//

import Foundation
import Alamofire
import RxSwift

class UrunlerRepository {
  var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var sepetListesi = BehaviorSubject<[Sepet]>(value: [Sepet]())
private var tumUrunlerListesi: [Urunler] = []
    
    func urunleriYukle(){
            let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
            
            AF.request(url,method: .get).response { response in
                if let data = response.data {
                    do{
                        let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                        if let liste = cevap.urunler{
                            self.tumUrunlerListesi = liste
                        self.urunlerListesi.onNext(liste)
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    func sepeteEkle(sepetId: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String){
           let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
    let parameters:Parameters = [     "sepetId": sepetId, "ad": ad, "resim": resim,  "kategori": kategori,  "fiyat": fiyat, "marka": marka,
                                      "siparisAdeti": siparisAdeti,
                                      "kullaniciAdi": kullaniciAdi]
           
           AF.request(url,method: .post,parameters: parameters).response { response in
               if let data = response.data {
                   do{
                       let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                       print("Başarı : \(cevap.success!)")
                       print("Mesaj  : \(cevap.message!)")
                   }catch{
                       print(error.localizedDescription)
                   }
               }
           }
       }
       
    
    func ara(aramaKelimesi: String) {
        if aramaKelimesi.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
         
            self.urunlerListesi.onNext(tumUrunlerListesi)
        } else {
            let filtreli = tumUrunlerListesi.filter { urun in
                if let ad = urun.ad {
                    return ad.lowercased().contains(aramaKelimesi.lowercased())
                }
                return false
            }
            self.urunlerListesi.onNext(filtreli)
        }
    }
    


        
}
