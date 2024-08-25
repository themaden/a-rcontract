README
Proje Adı
FlightBookingSystem

Proje Açıklaması
FlightBookingSystem, Scroll Blockchain üzerinde geliştirilmiş merkeziyetsiz bir uçuş rezervasyon sistemidir. Bu sistem, kullanıcıların uçuş rezervasyonları yapmalarını, bakiye yüklemelerini ve karbon dengelemesi yapmalarını sağlar. Kullanıcılar, kimlik doğrulaması sonrası uçuşlara rezervasyon yapabilir ve dinamik tarifelerle karşılaşabilirler. Ayrıca, sistem her uçuş için karbon ayak izini hesaplar ve karbon dengeleme ücretlerini yönetir.

Vizyon
FlightBookingSystem, hava yolculuğunda blockchain teknolojisini kullanarak şeffaf, güvenli ve verimli bir rezervasyon sistemi sunmayı hedefler. Dinamik fiyatlandırma ve karbon dengeleme ile kullanıcı deneyimini geliştirir ve çevresel sürdürülebilirliği teşvik eder. Proje, seyahat endüstrisinde teknolojiyi ve çevre bilincini birleştirerek daha sürdürülebilir bir geleceği desteklemeyi amaçlar.

Kurulum ve Kullanım
Gereksinimler
Solidity ^0.8.0
Ethereum uyumlu bir test ağı veya ana ağ
Kurulum Adımları
Akıllı Sözleşmeleri Derleme ve Dağıtım

Bu sözleşmeler, Solidity derleyicisi kullanılarak derlenmelidir.
Derlenen akıllı sözleşmeler, Scroll Blockchain veya uyumlu bir test ağına dağıtılmalıdır.
DID Kontratı ile Entegrasyon

DID (Decentralized Identifier) kontrat adresini, constructor işlevine parametre olarak geçmelisiniz.
DID kontratının kimlik doğrulama işlevinin doğru çalıştığından emin olun.
Kullanıcı Bakiyelerini Yönetme

loadBalance işlevi ile kullanıcılar ETH göndererek bakiyelerini yükleyebilirler.
checkBalance işlevi ile kullanıcılar mevcut bakiyelerini kontrol edebilirler.
Uçuş Ekleme ve Güncelleme

addFlight ve updateFlight işlevlerini kullanarak uçuş bilgilerini ekleyebilir veya güncelleyebilirsiniz.
Rezervasyon ve Karbon Dengeleme

Rezervasyon ve karbon dengeleme işlevleri şu anda eklenmemiştir. Bu işlevleri uygulamak için ek geliştirmeler yapabilirsiniz.
Geliştirme ve Test

Akıllı sözleşmeleri dağıttıktan sonra, sistemin tüm işlevlerini test etmek için bir dizi test senaryosu oluşturun.
Fonksiyonel testler, güvenlik testleri ve kullanıcı kabul testleri gerçekleştirin.
Katkıda Bulunma
Katkıda bulunmak için lütfen GitHub repository'sine göz atın ve katkıda bulunmak için pull request gönderin. İlgili konularda yardım veya önerileriniz varsa, bunları issue açarak belirtebilirsiniz.

Lisans
Bu proje MIT Lisansı altında lisanslanmıştır. Ayrıntılar için LICENSE dosyasına bakabilirsiniz.
