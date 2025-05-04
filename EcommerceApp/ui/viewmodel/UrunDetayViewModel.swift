//
//  UrunDetayViewModel.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 2.05.2025.
//

import Foundation
 

class UrunDetayViewModel{
    
    var urunlerRepository = UrunlerRepository()
    
    func kaydet(sepetId: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String){
          urunlerRepository.sepeteEkle(sepetId: sepetId,
                                       ad: ad,
                                       resim: resim,
                                       kategori: kategori,
                                       fiyat: fiyat,
                                       marka: marka,
                                       siparisAdeti: siparisAdeti,
                                       kullaniciAdi: kullaniciAdi)
       }
}

