# PlasticWaste

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/2022-07-21%2016-00-22.gif)

Plastik atıklar için yaptığım bu uygulama  email, Google veya anonim olarak giriş yaptığımız, 4 farklı dili destekleyen,  mevcut konumuzu kullanan,  bir numune eklediğimizde veri tabanından sunucuya verilerimizi gönderen ve sunucudan verilerimizi telefona aktaran bir Flutter uygulamasıdır.

Uygulamamızda kullanılan teknolojiler; PostgreSQL, Firebase Authentication, Firebase Cloud Messaging, Firebase Storage, Node.js ve Pub.dev adresinden import edilen 3.Parti yazılımlardır.

Uygulamamızda portu etkinleştirmek için Node.js üzerinden mevcut klasörümüze geliyoruz. node index.js komutu ile 3000 portunda local bir sunucu açıyoruz. Node.js yardımıya yazdığım kodlarda, index.js sayfası ile 3000 portunu etkinleştiriyoruz ve gerekli CRUD işlemlerinin fonksiyonlarını tanımlıyoruz. Diğer sayfamız queries.js ile bu tanımladığımız fonksiyonların işlevlerini yazıyoruz. package.json kısmında express ve pg paketleri aktif. Bu paketlerden pg sayesinde PostgreSQL ile bağlantılı olarak çalışabiliyor.

PostgreSQL kısmında bir Server şifresi ve Databases klasörüne ulaşmak için bir şifre belirliyoruz. Uygulamamda 176369 olarak bu şifreyi verdim. Yeni bir database oluşturup bu database ismini plasticdb koydum. Oluşturduğumuz bu plasticdb veri tabanında sırasıyla Schemas -> public -> Tables klasöründe yeni bir tablo oluşturuyoruz. Projemde shares ismini verdim. Oluşturduğumuz tabloya sağ tıklayıp sırasıyla Properties… -> Columns kısmında verilerimizin isimlerini ve veri tiplerini giriyoruz. Uygulamamda oluşturduğum tablo aşağıdaki gibidir.

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/1.PNG)

Save butonuna tıkladıktan sonra tablomuzun sütunları PostgreSQL içerisine eklenmiş olacaktır. Bu sütunları Postgre içerisinden görmek, güncellemek veya silmek için shares tablosuna ters tıklayıp sırasıyla View/Edit Data -> All Rows içerisinden ulaşabiliriz.

Uygulamamızın Firebase kısmında, Firebase’ de konsola giderek yeni bir proje açıyoruz. Bu proje ismine PlasticWaste adını koydum. Projemizi Firebase’e entegre etmek için bize anlatılan talimatları yapıyoruz. Projemde zorunlu olmayan ama Google ile giriş yapmak için ihtiyaç duyduğumuz SHA-1 sertifikasını giriyoruz. Başarılı bir şekilde uygulamamızı Firebase’e ekledikten sonra Firebase Authentication işlemleri için Get Started diyoruz. Projede hangi yollardan giriş yapılabileceğini seçiyoruz. Bu projede Email/Password, Anonymous ve Google seçeneklerini seçtim. Firebase Storage kısmında Get Started dedikten sonra 1 aylık deneme sürümü olan test modunu ve Avrupa konumunu seçtim. Storage içinde Rules kısmında aşağıdaki gibi bir değişiklik yapıyoruz.

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/2.PNG)

Bununla birlikte Storage işlemlerini de bitirip Firebase Cloud Messaging(FCM) kısmına tıklıyoruz. FCM işlemleri için Google Analitik’i projemize eklememiz gerekiyor. Enable Google Analytics dedikten sonra gerekli adımları izleyerek FCM’yi etkinleştiriyoruz. FCM içerisinde New campaign -> Notifications kısmına tıklıyoruz. Örnek olması için Notification title ve Notification text alanlarını doldurup Next’e tıklıyoruz. Projemizde her seferinde manuel olarak bildirim göndermemek için Target -> Topic -> Message topic kısmına uygulamada kullanılan başlığı giriyoruz. Projemizde Samples olarak kullandım. Scheduling kısmında uygulamamızın ne zaman bildirim göndereceğini seçiyoruz. Projemizde bir butona bağlı olarak, butona tıklanılıp veriler girildiğinde anlık olarak bildirim gönderiliyor. Son olarak Review -> Publish dediğimizde FCM kısmını tamamlamış oluyoruz.

Uygulamamızda Flutter kısmına geldiğimizde projeyi indirip sağ üstte Get Dependencies butonuna tıklayarak projemizde pubspec.yaml içerisindeki paketlerimizin import edilmesini sağlıyoruz. Eğer yükleme sırasında versiyon veya paket sürümü hatası alınırsa pubspec.yaml -> dependencies: altındaki eklenilen paketlerin sürümlerini silip sadece paket isimleri ve iki nokta(ör: firebase_auth:) kalacak şekilde yazabilirsiniz. 

Flutter projemiz pluginleri içeren bir sayfa, main sayfası, dil desteği için bir constants sayfası, kendi widgetlarımız olan components klasörü, dil desteği için extensions klasörü, projemizde oluşturulan model klasörü, backend işlemlerindeki servislerimiz için service klasörü ve arayüzlerimizin bulunduğu view klasörü içermektedir. Ayrıca assets klasörü altında resimlerimiz ve uygulamamızın dil desteği için json dosyaları bulunmaktadır.

Node.js ile uygulamamıza PostgreSQL bağlantısını yaptığımız kodlar: 

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/6.PNG)

Flutter ile uygulamamıza PostgreSQL bağlantısını yaptığımız kodlar:

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/4.PNG)

Yukarıdaki resimlerde görüldüğü gibi uygulamamızın düzgün bir şekilde çalışabilmesi için istenilen verilerin birbirleri ile örtüşmesi gerekiyor. Localhost ile çalışırken emülatörde bu porta ulaşmak için 10.0.2.2 yazmamız gerekiyor. Yukarıda gördüğümüz connection verimizde, 10.0.2.2 yerine Komut İstemi(CMD) üzerinden ipconfig komutu ile IPv4 adresini veya direkt olarak localhost yazdığımızda emülatör o sunucuya bağlanamıyor. Bu yüzden eğer belirli bir hosting yoksa ve emülatörde çalışmak istiyorsak host kısmına 10.0.2.2 giriyoruz.

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/5.PNG)

Yukarıda DatabaseService sayfasındaki bir kod örneğinde görüldüğü gibi 10.0.2.2 ağından her hangi bir get,post,put ve delete işlemi yapabiliyoruz. 

NotificationService sayfasından Firebase yardımıyla bir bildirim göndermek ve bu bildirimi manuel olarak yapmamak için aşağıdaki kod örneğindeki "to": "/topics/Samples", kısmını yazıyoruz. Buradaki Samples benim projemdeki kendi isimlendirmem. O yüzden Firebase içerisindeki topics kısmı ile aynı olması koşulu ile istediğimiz bir ismi yazabiliriz. Burada ayrıca önemli bir nokta ise Server Key’imizin aşağıdaki kod örneğindeki Authorization anahtarına karşılık gelen değerle aynı olmasıdır. Server Key’imizi öğrenmek için Project Overview yanındaki ayarlar butonundan Project Settings -> Cloud Messaging altındaki Cloud Messaging API (Legacy) kısmından görebiliriz.

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/7.PNG)

Son olarak Google Maps API’ı projemize eklemek için aşağıdaki kodu AndroidManifest.xml içerisine eklememiz gerekiyor.

![](https://github.com/anilyilmaz108/PlasticWaste/blob/main/images/8.PNG)

Bu kısımda name kısmımız sabit dururken value kısmına Google Maps API’ye kayıt olduktan sonra bize verilen Key’i yazıyoruz. Google Maps API içerisinde uygulamamızın çalışmasını istediğimiz platformları aktif ediyoruz. Projemizde IOS ve Android’i aktif edildi.
