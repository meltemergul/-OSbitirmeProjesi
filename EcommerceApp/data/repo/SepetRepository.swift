//
//  SepetRepository.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 4.05.2025.
//

import Foundation
import Alamofire
import RxSwift

class SepetRepository {
    var sepetListesi = BehaviorSubject<[Sepet]>(value: [Sepet]())
    
    
    func sepetiYukle(kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        // POST parametrelerini hazırlıyoruz
        let parameters: [String: Any] = [
            "kullaniciAdi": kullaniciAdi
        ]
        
        // Alamofire ile POST isteği gönderiyoruz
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).response { response in
            if let data = response.data {
                if let jsonString = String(data: data, encoding: .utf8) {
                               print("Gelen JSON: \(jsonString)")
                           }
                do {
                    // JSON verisini decode ediyoruz
                    let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                    
                    if let success = cevap.success, success == 1 {
                        if let urunler = cevap.urunler_sepeti {
                            // Sepet verilerini gönderiyoruz
                            self.sepetListesi.onNext(urunler)
                        } else {
                            print("Sepet verisi boş")
                        }
                    } else {
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }
    }

    
    func sil(sepetId:Int,kullaniciAdi:String){
           let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
           let parameters:Parameters = ["sepetId":sepetId,"kullaniciAdi":kullaniciAdi]
           
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
    
    
    
    
}
