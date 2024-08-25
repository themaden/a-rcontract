# Uçuş Rezervasyon Sistemi Akıllı Kontratı

## Genel Bakış

`FlightBookingSystem` akıllı kontratı, kullanıcıların uçuşları rezerve etmelerini, uçuş bilgilerini yönetmelerini ve karbon dengeleme satın alımlarını gerçekleştirmelerini sağlar. Ayrıca, yalnızca doğrulanmış kimliklerin sistemle etkileşimde bulunabilmesi için bir Merkeziyetsiz Kimlik (DID) kontratı ile entegre edilmiştir.

## Özellikler

- **Uçuş Yönetimi**: Uçuş bilgilerini ekleyin ve güncelleyin.
- **Kullanıcı Bakiyesi Yönetimi**: Kullanıcılar ETH yükleyebilir ve bakiyelerini kontrol edebilir.
- **Uçuş Rezervasyonu**: Kullanıcılar uçuş rezervasyonu yapabilir (işlevsellik bu kontratta uygulanmamıştır).
- **Karbon Dengeleme**: Bir uçuşun karbon salınımını hesaplayın ve karbon dengeleme maliyetlerini yönetin.
- **Dinamik Tarife**: Talebe bağlı olarak tarifeler ayarlanabilir (uygulama tam olarak sağlanmamıştır).

## Kontrat Arayüzleri

### IDID

`IDID` arayüzü, kullanıcı kimliklerini doğrulamak için kullanılır. Bu, DID kontratı tarafından uygulanmalıdır.

```solidity
interface IDID {
    function verifyIdentity(address user) external view returns (bool);
}
Kontrat Detayları
Durum Değişkenleri
balances: Kullanıcı adreslerini ETH bakiyeleri ile eşleştiren mapping.
flights: Uçuş numaralarını Flight yapılarına eşleştiren mapping.
owner: Kontrat sahibinin adresi.
carbonOffsetCostPerTon: Ton başına karbon dengeleme ücreti.
didContract: DID kontrat arayüzü örneği.
Yapılar
Flight
solidity
Kodu kopyala
struct Flight {
    uint256 flightNumber;
    string airline;
    string aircraftType;
    string departureCity;
    string destinationCity;
    uint256 departureTime;
    uint256 baseTariff;
    uint256 seatsAvailable;
    uint256 distance;
    bool exists;
}
Olaylar
TariffUpdated: Bir uçuşun tarifesi güncellendiğinde yayılır.
BalanceUpdated: Bir kullanıcının bakiyesi güncellendiğinde yayılır.
FlightReserved: Bir uçuş rezervasyonu yapıldığında yayılır (işlevsellik uygulanmamıştır).
CarbonOffsetPurchased: Bir kullanıcı karbon dengeleme satın aldığında yayılır (işlevsellik uygulanmamıştır).
FlightUpdated: Bir uçuş güncellendiğinde yayılır.
Modifikatörler
hasSufficientBalance: Kullanıcının belirli bir işlem için yeterli bakiyesi olup olmadığını kontrol eder.
onlyOwner: Erişimin sadece kontrat sahibi ile sınırlı olduğunu garanti eder.
identityVerified: Kullanıcının kimliğinin doğrulanmış olduğunu garanti eder.
Yapıcı Fonksiyon
solidity
Kodu kopyala
constructor(address _didContract) {
    owner = msg.sender;
    didContract = IDID(_didContract);
}
Fonksiyonlar
loadBalance(): Kullanıcıların ETH yüklemelerine izin verir.
addFlight(): Yeni bir uçuş ekler.
updateFlight(): Var olan bir uçuşu günceller.
withdraw(): Kontrattan ETH çekmeye izin verir.
checkBalance(): Kullanıcının bakiyesini kontrol eder.
updateTariffBasedOnDemand(): Talebe bağlı olarak uçuş tarifesini günceller (içsel bir fonksiyon).
calculateCarbonFootprint(): Bir uçuşun karbon salınımını hesaplar.
Kullanım
Kontratı Dağıtın: Kontratı dağıtırken DID kontratının adresini verin.
ETH Yükleyin: Kullanıcılar loadBalance fonksiyonu ile bakiyelerini artırabilir.
Uçuş Ekleyin/Güncelleyin: addFlight ve updateFlight fonksiyonları ile uçuş bilgilerini yönetin.
Bakiyeyi Kontrol Edin: Kullanıcılar checkBalance fonksiyonunu kullanarak bakiyelerini kontrol edebilir.
Karbon Ayak İzi Hesaplama: calculateCarbonFootprint fonksiyonu ile uçuşun karbon salınımını hesaplayın.
Bu doküman, akıllı kontratın temel işlevlerini ve nasıl kullanılacağını açıklamaktadır. Daha fazla bilgi için kontrat kodunu inceleyebilirsiniz.
