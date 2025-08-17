
MySQL ve EF Core ile İlişkisel Veritabanı Tasarımı ve Uygulaması: Kütüphane Otomasyonu Örneği


Giriş: İlişkisel Veritabanları ve EF Core'a Genel Bakış

İlişkisel veritabanları, modern yazılım geliştirmenin temel taşlarından biridir. Verileri düzenli, tutarlı ve erişilebilir bir biçimde depolamak için tabloları ve bu tablolar arasındaki tanımlı ilişkileri kullanan bir model sunarlar. Bu yapısal yaklaşım, veri tekrarını önemli ölçüde azaltır ve veri bütünlüğünü artırır.1 Verilerin birbiriyle olan bağlantılarının net bir şekilde tanımlanması, veri hakimiyetini yükseltir ve genel iş yükünü düşürür. Bu, bir müşteri kaydının silinmesi durumunda, o müşteriye ait tüm siparişlerin otomatik olarak ne olacağının belirlenmesi gibi referans bütünlüğü kurallarıyla doğrudan ilişkilidir.2 Bu tür kuralların veritabanı seviyesinde uygulanması, uygulama katmanındaki karmaşıklığı azaltırken veritabanının güvenilirliğini artırır. Veri tekrarının azaltılması, veri tutarlılığının artmasına yol açar; bu da veri bütünlüğü kurallarının etkin bir şekilde uygulanmasıyla sonuçlanır. Bu durum, uygulama katmanında daha az hata ve daha basit bir iş mantığına olanak tanır. Sonuç olarak, veritabanı tasarımı sadece teknik bir gereklilik olmanın ötesinde, yazılım geliştirme sürecinin genel kalitesini artıran stratejik bir karardır.
Entity Framework Core (EF Core),.NET uygulamaları için geliştirilmiş güçlü bir Nesne-İlişkisel Eşleyici (ORM) aracıdır. Geliştiricilerin veritabanı etkileşimlerini doğrudan C# nesneleri (POCO sınıfları) üzerinden gerçekleştirmesine imkan tanıyarak, manuel SQL sorguları yazma ihtiyacını minimize eder.5 Bu durum, geliştirme hızını önemli ölçüde artırır ve veritabanı sistemine olan bağımlılığı azaltır. EF Core'un "Migrations" özelliği, veritabanı şemasının zaman içinde evrimini yönetmek için kritik bir yetenek sunar.8 Bu özellik sayesinde, uygulama modelindeki değişiklikler mevcut verileri kaybetmeden veritabanına yansıtılabilir. Migrations, sürekli değişen yazılım gereksinimlerine uyum sağlarken veri kaybını önleyen kritik bir DevOps aracı olarak işlev görür. ORM kullanımıyla SQL yazma yükünün azalması, geliştirme hızını artırırken hata oranını düşürür. Migrations'ın şema değişikliklerini versiyonlama yeteneği ise veri kaybı riskini azaltır ve ekip içi işbirliğini kolaylaştırır.9 Bu, EF Core'un yalnızca bir veritabanı aracı olmaktan öte, modern yazılım geliştirme süreçlerinde çevikliği ve güvenliği destekleyen entegre bir çözüm olduğunu gösterir.
Bu rapor, MySQL gibi ilişkisel bir veritabanı yönetim sistemiyle çalışan bir C# uygulamasında EF Core'un nasıl kullanılacağını detaylandırmaktadır. Kullanıcının MySQL tercihine uygun olarak, EF Core, özel sağlayıcılar aracılığıyla MySQL ile sorunsuz bir entegrasyon sunar.11 Bu entegrasyon, geliştiricilerin C# ortamında kalırken güçlü ve güvenilir bir veritabanı altyapısından faydalanmasını sağlar.

Bölüm 1: İlişkisel Veritabanı Temelleri


1.1. Tablolar, Sütunlar ve Satırlar: Temel Yapı Taşları

İlişkisel veritabanlarının temelini tablolar oluşturur. Her tablo, belirli bir varlık türünü, örneğin "Kitaplar" veya "Üyeler" gibi gerçek dünya kavramlarını temsil eder. Tablolar, verileri yapılandırılmış bir şekilde düzenlemek için kullanılır ve iki ana bileşenden oluşur: sütunlar ve satırlar.2
Sütunlar (Nitelikler/Alanlar): Bir tablodaki dikey alanlardır ve varlığın belirli bir özelliğini tanımlarlar. Örneğin, "Kitaplar" tablosunda "Kitap Adı", "Yazar" veya "ISBN" gibi sütunlar bulunabilir. Her sütun, belirli bir veri türünü (metin, sayı, tarih vb.) barındırır.
Satırlar (Kayıtlar/Demetler): Bir tablodaki yatay kayıtlardır ve varlığın tekil bir örneğini temsil ederler. Örneğin, "Sefiller" adlı kitabın tüm bilgileri (adı, yazarı, ISBN'si) tek bir satırda yer alır. Her satır, ilgili sütunlardaki değerlerin bir kombinasyonudur.
Bu temel yapı taşları, verilerin organize edilmesini, sorgulanmasını ve manipüle edilmesini sağlar.

1.2. Birincil Anahtarlar (Primary Keys - PK)

Birincil anahtar, bir tablodaki her bir satırı benzersiz bir şekilde tanımlayan bir sütun veya sütun kombinasyonudur.2 Birincil anahtarların temel özellikleri, veri bütünlüğünü sağlamada kritik bir rol oynar:
Benzersizlik: Birincil anahtar sütunundaki her değer benzersiz olmalıdır; hiçbir iki satır aynı birincil anahtar değerine sahip olamaz.2
Boş Olmama (NOT NULL): Birincil anahtar sütunları boş (NULL) değer içeremez.4 Bu, her kaydın her zaman bir tanımlayıcıya sahip olmasını garanti eder.
İndeksleme: Birincil anahtar tanımlandığında, veritabanı motoru otomatik olarak birincil anahtar sütunları üzerinde benzersiz bir indeks oluşturur.4 Bu indeks, birincil anahtarın sorgularda kullanılması durumunda verilere hızlı erişim sağlar. Bu durum, sorgu performansını doğrudan etkileyen önemli bir faktördür. Birincil anahtarların benzersizlik sağlaması, veri bütünlüğünün temelini oluşturur ve otomatik indeksleme sayesinde sorgu performansında artış gözlemlenir. Bu, birincil anahtarların sadece mantıksal bir tanımlayıcı olmanın ötesinde, aynı zamanda fiziksel veritabanı performansını optimize eden bir mekanizma olduğunu ortaya koyar.
Bazı durumlarda, birincil anahtar birden fazla sütunun birleşimiyle oluşturulur. Buna bileşik anahtar (composite key) denir.2 Bileşik anahtarda, tek tek sütunlardaki değerler tekrarlanabilirken, bu sütunların kombinasyonu benzersiz olmalıdır. Örneğin, bir
ProductVendor tablosunda ProductID ve VendorID sütunları birleşerek benzersiz bir birincil anahtar oluşturabilir.4

1.3. Yabancı Anahtarlar (Foreign Keys - FK)

Yabancı anahtar, bir tablodaki bir sütunun veya sütun kombinasyonunun, başka bir tablonun birincil anahtar sütununa başvurması durumudur.2 Yabancı anahtarların temel işlevi, iki tablo arasında mantıksal bir bağlantı kurmak ve veri bütünlüğünü sağlamaktır.
İlişki Kurma: Yabancı anahtarlar, tablolar arasında çapraz referanslar oluşturmak için kullanılır.2 Örneğin, bir "Siparişler" tablosundaki
CustomerID sütunu, "Müşteriler" tablosundaki CustomerID birincil anahtarına başvurarak, her siparişin mevcut bir müşteriye ait olmasını sağlar.
Benzersizlik Gereksinimi Yok: Birincil anahtarların aksine, yabancı anahtarların benzersiz değerlere sahip olması gerekmez.2 Bir müşteri birden fazla sipariş verebileceği için, "Siparişler" tablosundaki
CustomerID yabancı anahtarı tekrarlayan değerler içerebilir.
Referans Bütünlüğü (Referential Integrity): Yabancı anahtarların en önemli işlevlerinden biri referans bütünlüğünü sağlamaktır.3 Bu, aşağıdaki kuralların uygulanmasını içerir:
İlgili tabloda (foreign key table) ana tabloda (primary table) mevcut olmayan bir değerin girilmesi engellenir.
İlgili kayıtları olan bir ana tablodaki kaydın silinmesi veya birincil anahtar değerinin değiştirilmesi kısıtlanabilir. Örneğin, "Çalışanlar" tablosundan bir çalışanı, ona atanmış siparişler varsa silemezsiniz.3
Basamaklı Referans Bütünlüğü (Cascading Referential Integrity): EF Core ve veritabanları, ana tablodaki bir kaydın silinmesi veya güncellenmesi durumunda ilgili tablolardaki verilere ne olacağını belirlemek için basamaklı eylemler tanımlamaya izin verir.4 Bu eylemler şunları içerebilir:
NO ACTION: Ebeveyn tablosundaki silme veya güncelleme işlemi, ilgili kayıtlar varsa bir hata ile geri alınır.
CASCADE: Ebeveyn tablosundaki bir kayıt güncellendiğinde veya silindiğinde, bağımlı tablodaki ilgili kayıtlar da otomatik olarak güncellenir veya silinir.
SET NULL: Ebeveyn tablosundaki bir kayıt güncellendiğinde veya silindiğinde, bağımlı tablodaki yabancı anahtar değerleri NULL olarak ayarlanır (yabancı anahtar sütunu NULL değer alabilir olmalıdır).
SET DEFAULT: Ebeveyn tablosundaki bir kayıt güncellendiğinde veya silindiğinde, bağımlı tablodaki yabancı anahtar değerleri varsayılan değerlerine ayarlanır (yabancı anahtar sütunu için varsayılan bir değer tanımlanmış olmalıdır).
Yabancı anahtarlar ve referans bütünlüğü, veritabanı tutarlılığının temel direğidir. CASCADE gibi basamaklı eylemler, karmaşık iş kurallarını veritabanı seviyesinde otomatize ederek uygulama kodunu basitleştirir. Ancak, bu tür eylemlerin yanlış kullanılması, özellikle büyük veri setlerinde istenmeyen veri kayıplarına veya performans sorunlarına yol açabilir. Bu nedenle, basamaklı eylemlerin seçimi, iş mantığı ve veri güvenliği gereksinimleri dikkate alınarak dikkatlice yapılmalıdır. Yabancı anahtarların ilişki kurması ve referans bütünlüğü sağlaması, veri tutarlılığını garanti eder. Basamaklı eylemlerin otomatik veri yönetimi sağlaması, uygulama katmanında manuel işlemleri azaltır. Ancak, CASCADE gibi güçlü eylemlerin potansiyel tehlikeleri de beraberinde getirmesi, veritabanı tasarımında sadece teknik yeterliliğin değil, aynı zamanda sistemin genel davranışını öngörme yeteneğinin de önemini vurgular.
Aşağıdaki tablo, temel ilişkisel veritabanı kavramlarını özetlemektedir:

Kavram
Tanım
İşlev / Önemi
Tablo
Verilerin satırlar ve sütunlar halinde düzenlendiği yapı.
Belirli bir varlık türünü temsil eder, verileri organize eder.
Sütun (Nitelik)
Tablodaki belirli bir veri türünü temsil eden dikey alan.
Varlığın bir özelliğini tanımlar (örn. "Kitap Adı").
Satır (Kayıt)
Tablodaki tek bir veri kaydı, varlığın tekil bir örneği.
Varlığın tüm özelliklerini içeren tekil bir öğe (örn. "Sefiller" kitabının tüm bilgileri).
Birincil Anahtar (PK)
Bir tablodaki her satırı benzersiz kılan bir veya daha fazla sütun.
Varlık bütünlüğünü sağlar, hızlı veri erişimi için indekslenir, NULL olamaz. 2
Yabancı Anahtar (FK)
Başka bir tablonun birincil anahtarına başvuran sütun veya sütunlar.
Tablolar arası ilişkileri kurar, referans bütünlüğünü sağlar. 2


1.4. Veritabanı Normalizasyonu


1.4.1. Neden Normalizasyon?

Normalizasyon, veritabanı tasarımında verileri yapılandırarak veri tekrarını (redundancy) en aza indirme ve veri bütünlüğünü (integrity) sağlama tekniğidir.1 Tekrarlanan veriler, disk alanı israfına yol açar ve veritabanında
anomali olarak bilinen sorunlara neden olur:
Ekleme Anomalisi: Yeni bir veri eklerken, gereksiz veya eksik bilgi girmek zorunda kalmak.
Güncelleme Anomalisi: Bir veriyi güncellerken, aynı verinin birden fazla yerde güncellenmesi gerekliliği ve bu güncellemelerin tutarsız olma riski.
Silme Anomalisi: Bir veriyi silerken, başka önemli verilerin de istemeden silinmesi.
Normalizasyon, bu anomalileri çözerek veritabanı hakimiyetini artırır ve tutarsızlıkları önler.1 Normalizasyonun temel amacı sadece veri tekrarını azaltmak değil, aynı zamanda veritabanının bu anomalilere karşı direncini artırmaktır. Ekleme, silme ve güncelleme anomalileri, veritabanı tutarlılığını bozan ve uygulama geliştirme sürecini karmaşıklaştıran ciddi sorunlardır. Normalizasyon, bu sorunları ortadan kaldırarak daha istikrarlı ve güvenilir bir veri modeli oluşturur. Veri tekrarının anomali riskleri yaratması ve veri tutarsızlığına yol açması, normalizasyon ile bu risklerin ortadan kaldırılmasının önemini gösterir. Bu, normalizasyonun sadece teorik bir kavram değil, aynı zamanda pratik veri yönetimi ve uygulama güvenilirliği için vazgeçilmez bir mühendislik prensibi olduğunu vurgular.

1.4.2. Birinci Normal Form (1NF)

Bir tablonun Birinci Normal Form'da (1NF) olabilmesi için aşağıdaki kriterleri karşılaması gerekir:
Atomisite: Her hücre tek bir değer içermelidir. Yani, bir sütunda birden fazla bilgi (örneğin, virgülle ayrılmış listeler) bulunmamalıdır.13
Tekrarlayan Grupların Olmaması: Bir tabloda benzer verileri depolayan birden fazla sütun (örn. Ders1, Ders2, Ders3) bulunmamalıdır. Bu tür veriler ayrı satırlara veya ayrı bir tabloya taşınmalıdır.15
Benzersiz Birincil Anahtar: Her satır, benzersiz bir birincil anahtar ile tanımlanmalıdır.13
Her Sütunun Tek Değer İçermesi: Her sütun, her satır için yalnızca bir değer içermelidir.13
Örnek olarak, bir öğrencinin birden fazla dersi varsa, bu dersler aynı sütunda virgülle ayrılmış şekilde değil, her ders için ayrı bir satırda veya ayrı bir "Kayıtlar" tablosunda listelenmelidir.15

1.4.3. İkinci Normal Form (2NF)

Bir tablonun İkinci Normal Form'da (2NF) olabilmesi için aşağıdaki kriterleri karşılaması gerekir:
1NF'de Olmalıdır: Tablo zaten 1NF kurallarına uygun olmalıdır.13
Kısmi Bağımlılık Olmamalıdır: Anahtar olmayan (yani birincil anahtarın parçası olmayan) tüm nitelikler, birincil anahtarın tamamına tamamen bağımlı olmalıdır. Eğer birincil anahtar bileşik bir anahtarsa, anahtar olmayan hiçbir nitelik, birincil anahtarın yalnızca bir kısmına bağımlı olmamalıdır.13
Örnek olarak, bir employee_roles tablosunda employee_id ve job_code birleşik birincil anahtar olsun. Eğer name, home_state ve state_code gibi bilgiler sadece employee_id'ye bağımlıysa (yani job_code değişse bile bu bilgiler değişmiyorsa), bu bir kısmi bağımlılıktır. 2NF'ye ulaşmak için bu tür bağımlılıklar ayrı bir tabloya taşınmalıdır.13

1.4.4. Üçüncü Normal Form (3NF)

Bir tablonun Üçüncü Normal Form'da (3NF) olabilmesi için aşağıdaki kriterleri karşılaması gerekir:
2NF'de Olmalıdır: Tablo zaten 2NF kurallarına uygun olmalıdır.13
Geçişli Kısmi Bağımlılık Olmamalıdır: Anahtar olmayan bir nitelik, başka bir anahtar olmayan niteliğe bağımlı olmamalıdır. Yani, bir niteliğin değeri, birincil anahtar dışındaki başka bir niteliğin değerine göre belirlenmemelidir.13
Örnek olarak, 2NF'ye uygun bir employees tablosunda state_code ve home_state sütunları bulunsun. Eğer home_state değeri state_code'a bağımlıysa (yani state_code bilindiğinde home_state otomatik olarak biliniyorsa), bu bir geçişli bağımlılıktır. 3NF'ye ulaşmak için state_code ve home_state ayrı bir states tablosuna taşınmalıdır.13
3NF, çoğu pratik veritabanı tasarımı için yeterli kabul edilen en yaygın normal formdur.13 Daha yüksek normal formlar (4NF, 5NF, Boyce-Codd Normal Form - BCNF) mevcut olsa da, genellikle karmaşıklığı artırıp performansı düşürebilirler, bu nedenle her zaman uygulanmaları pratik olmayabilir.15 Normalizasyonun bir denge meselesi olduğu unutulmamalıdır: aşırı normalizasyon, çok sayıda küçük tabloya yol açarak sorgu karmaşıklığını ve performans maliyetini artırabilir.15 Normalizasyonun amacı veri bütünlüğü ve anomali eliminasyonudur. 3NF'nin pratik yeterliliği, çoğu iş senaryosu için optimal bir denge sunar. Ancak, aşırı normalizasyonun potansiyel dezavantajları (performans düşüşü, sorgu karmaşıklığı) göz önüne alındığında, tasarımda pragmatizm ve iş gereksinimlerinin önceliği önem kazanır. Bu, veritabanı tasarımının sadece kurallara uymakla kalmayıp, aynı zamanda gerçek dünya kısıtlamalarını ve performans hedeflerini de göz önünde bulundurmayı gerektiren bir disiplin olduğunu gösterir.
Aşağıdaki tablo, normalizasyon kurallarını özetlemektedir:

Normal Form
Kriterler
Açıklama
1NF
1. Her hücre atomik (tek değer) olmalı. 2. Tekrarlayan gruplar olmamalı. 3. Her satır benzersiz bir PK ile tanımlanmalı. 4. Her sütun, her satır için tek bir değer içermeli.
Veri tekrarını ve çok değerli nitelikleri ortadan kaldırır. 13
2NF
1. 1NF'de olmalı. 2. Kısmi bağımlılık olmamalı (anahtar olmayan tüm nitelikler PK'ye tamamen bağımlı olmalı).
Birincil anahtarın bir parçasına bağımlı olan verilerin tekrarlanmasını önler. 13
3NF
1. 2NF'de olmalı. 2. Geçişli kısmi bağımlılık olmamalı (anahtar olmayan bir nitelik, başka bir anahtar olmayan niteliğe bağımlı olmamalı).
Anahtar olmayan nitelikler arasındaki bağımlılıkları ortadan kaldırır, en yaygın kullanılan formdur. 13


Bölüm 2: İlişki Türleri ve Modelleme

İlişkisel veritabanlarında tablolar arasındaki bağlantılar, belirli ilişki türleri ile ifade edilir. Bu ilişkiler, verilerin nasıl birbiriyle ilgili olduğunu ve veri bütünlüğünün nasıl sağlanacağını belirler. Üç ana ilişki türü bulunmaktadır: Bire-Bir, Bire-Çok ve Çoka-Çok.1

2.1. Bire-Bir (One-to-One / 1:1) İlişkiler

Bire-bir ilişki, bir tablodaki her bir kaydın, diğer tablodaki yalnızca bir kayda karşılık gelmesi durumudur.1 Bu ilişki türü, genellikle aşağıdaki senaryolarda kullanılır:
Veri Ayırma: Nadiren erişilen veya hassas verileri ana tablodan ayırmak için. Örneğin, bir Kişiler tablosundaki temel bilgileri ve KişiDetayları tablosundaki daha az erişilen veya hassas bilgileri ayrı tutmak.
Güvenlik: Belirli bir veri alt kümesini daha sıkı güvenlik kurallarıyla izole etmek.
Performans Optimizasyonu: Çok sayıda sütuna sahip bir tabloyu, daha sık kullanılan ve daha az kullanılan sütunlara ayırarak sorgu performansını artırmak.
Geçici Veri Saklama: Kolayca silinebilecek geçici verileri ayrı bir tabloda tutmak.3
Bire-bir ilişkiler, genellikle bir tablonun birincil anahtarı ile diğer tablonun benzersiz (unique) bir yabancı anahtarı arasında kurulur.1 Örneğin, bir
Arabalar tablosu ile bir SigortaBilgileri tablosu arasında bire-bir ilişki kurulabilir, çünkü bir arabanın bir sigortası ve bir sigorta bilgisinin bir arabaya ait olduğu varsayılır.1
Bire-bir ilişkiler, genellikle bir varlığın özelliklerini mantıksal olarak ayırmak veya performans/güvenlik nedenleriyle bir tabloyu fiziksel olarak bölmek için kullanılır.3 Bu, normalizasyonun ötesinde, sistem mimarisini ve operasyonel gereksinimleri dikkate alan bir tasarım kararıdır. Bire-bir ilişkilerin nadir kullanımı, genellikle tek tabloda birleştirilebilecek verilerin ayrılmasından kaynaklanır. Ancak, güvenlik, performans veya modülerlik gibi belirli senaryolarda tablo bölme (table splitting) tekniği kullanılır.20 Bu durum, veritabanı tasarımının sadece teorik kurallara değil, aynı zamanda pratik mühendislik ihtiyaçlarına da yanıt vermesi gerektiğini gösterir.

2.2. Bire-Çok (One-to-Many / 1:N) İlişkiler

Bire-çok ilişki, ilişkisel veritabanlarında en yaygın kullanılan ilişki türüdür.1 Bu ilişkide, bir tablodaki tek bir kayıt, diğer tablodaki birden fazla kayda karşılık gelebilir; ancak diğer tablodaki her bir kayıt, birinci tablodaki yalnızca bir kayda bağlıdır.
Bu ilişki, genellikle "bir" tarafındaki tablonun birincil anahtarı ile "çok" tarafındaki tablonun yabancı anahtarı arasında kurulur.1 Örneğin:
Bir Liseler tablosu ile bir Öğrenciler tablosu arasında bire-çok ilişki vardır. Bir lisede birden fazla öğrenci eğitim alabilir, ancak bir öğrenci aynı anda yalnızca bir lisede eğitim alır.1
Bir Yayıncılar tablosu ile bir Kitaplar tablosu arasında da bire-çok ilişki bulunur. Bir yayıncı birçok kitap yayınlayabilir, ancak her kitap tek bir yayıncıya aittir.3
Bire-çok ilişkiler, ilişkisel veritabanlarının temelini oluşturur ve veri tekrarını azaltmada kritik bir rol oynar. Bu ilişkiler, bir ana kaydın birden çok ilgili kaydı yönetmesini sağlayarak, verilerin hiyerarşik veya kategorik olarak düzenlenmesine olanak tanır. Bu durum, veritabanı tasarımında en sık karşılaşılan ve en temel ilişki modelidir.

2.3. Çoka-Çok (Many-to-Many / N:M) İlişkiler

Çoka-çok ilişki, iki tablodaki birer satırlık verilerin, karşılıklı olarak birden fazla satırlık veriye denk gelmesi durumudur.1 Bu ilişki türü doğrudan iki tablo arasında tanımlanamaz. Bunun yerine, bu tür ilişkileri oluşturmak için
ara tablo (junction table, bridging table, linking table) adı verilen yeni bir tabloya ihtiyaç duyulur.1
Ara tablo, ilişkili olduğu iki ana tablonun birincil anahtarlarını yabancı anahtar olarak içerir ve genellikle bu iki yabancı anahtarın birleşimi ara tablonun bileşik birincil anahtarını oluşturur.1 Bu ara tablo, aslında iki adet bire-çok ilişki kurar: birincisi ilk ana tablo ile ara tablo arasında, ikincisi ise ikinci ana tablo ile ara tablo arasında.
Örnekler:
Bir Filmler tablosu ile bir Kategoriler tablosu arasında çoka-çok ilişki vardır. Bir film birden fazla kategoriye (örneğin, "dram", "psikolojik gerilim") ait olabilir ve bir kategori birden fazla film içerebilir. Bu ilişkiyi modellemek için FilmKategorileri gibi bir ara tablo kullanılır.1
Bir Öğrenciler tablosu ile bir Öğretmenler tablosu arasında da çoka-çok ilişki bulunabilir. Bir öğrencinin birden fazla öğretmeni olabilir ve bir öğretmen birden fazla öğrenciye ders verebilir. Bu durum, ÖğretmenÖğrenci gibi bir ara tablo ile çözülür.24
Çoka-çok ilişkiler, karmaşık iş gereksinimlerini modellemek için vazgeçilmezdir. Ara tablolar, sadece iki varlığı birbirine bağlamakla kalmaz, aynı zamanda ilişkinin kendisine ait ek öznitelikler (payload) içerebilir (örneğin, bir öğrencinin bir derse kaydolduğu tarih veya bir kitabın bir kategoriye eklendiği tarih).24 Bu, veritabanı tasarımının sadece yapısal değil, aynı zamanda anlamsal zenginliğini de artırır. Çoka-çok ilişkilerin karmaşıklığı, doğrudan modellemenin imkansızlığı nedeniyle ara tablo ihtiyacını doğurur.3 Ara tablonun sadece yabancı anahtarları değil, ek "payload" verileri de içerebilmesi, ilişkinin kendisinin bir varlık gibi davranmasını ve daha zengin iş mantığı modellemesini mümkün kılar. Bu durum, veritabanı tasarımının soyut kavramları somut tablolara dönüştürme yeteneğinin bir göstergesidir.
Aşağıdaki tablo, farklı ilişki türlerini ve temel özelliklerini özetlemektedir:

İlişki Türü
Tanım
Temel Özellik
Örnek
Bire-Bir (1:1)
Bir varlık, diğer varlığın yalnızca bir örneğiyle ilişkilidir.
Her iki tarafta da PK veya benzersiz kısıtlama. Genellikle tablo bölme veya güvenlik için kullanılır.
Araba - Sigorta 1
Bire-Çok (1:N)
Bir varlık, diğer varlığın birden çok örneğiyle ilişkilidir.
"Bir" tarafında PK, "Çok" tarafında FK. En yaygın ilişki türü.
Lise - Öğrenci 1
Çoka-Çok (N:M)
Bir varlık, diğer varlığın birden çok örneğiyle ilişkilidir ve tersi de geçerlidir.
Ara tablo (junction table) gerektirir. Ara tablo, iki FK'den oluşan bir PK'ye sahiptir.
Film - Kategori 1, Öğrenci - Öğretmen 24


Bölüm 3: Varlık İlişki Diyagramları (ERD)


3.1. ERD Nedir ve Neden Önemlidir?

Varlık İlişki Diyagramı (ERD), varlıkların (insanlar, nesneler, kavramlar) birbirleriyle nasıl etkileşime girdiğini gösteren kavramsal bir veri modelidir.25 Bu diyagramlar, geliştiricilerin ve tasarımcıların temel yazılım bileşenleri arasındaki ilişkileri görselleştirmesine yardımcı olur. Bir sistemin yapısını anlamak, veri akışını görmek ve potansiyel sorunları erken aşamada tespit etmek için veritabanı tasarımında kritik bir araçtır.25
ERD'ler, teknik ve teknik olmayan paydaşlar arasında ortak bir dil sağlayarak iletişimi kolaylaştırır.25 Bu, veritabanı tasarımının yalnızca bir mühendislik görevi olmanın ötesinde, aynı zamanda etkili bir iletişim aracı olduğunu gösterir. Karmaşık sistemleri basitleştirmede ve ekip işbirliğini geliştirmede görselleştirme kilit bir rol oynar. Veritabanı karmaşıklığı, görselleştirme ihtiyacını doğurur ve ERD'ler bu ihtiyacı karşılar.25 ERD'nin paydaşlar arası ortak bir dil olması, iletişimi kolaylaştırarak proje başarısına katkıda bulunur. Bu durum, ERD'nin sadece teknik bir çizim değil, aynı zamanda proje yönetimi ve ekip uyumu için stratejik bir araç olduğunu vurgular.

3.2. ERD Bileşenleri: Varlıklar, Nitelikler, İlişkiler

Bir ERD, üç ana bileşenden oluşur:
Varlıklar (Entities): Bir sistemde depolanacak bilgiyi temsil eden nesneler, insanlar, kavramlar veya olaylardır.25 Genellikle dikdörtgenlerle gösterilirler. Güçlü varlıklar (kendi başına var olabilenler) tek dikdörtgenle, zayıf varlıklar (başka bir varlığa bağımlı olanlar) ise çift dikdörtgenle gösterilebilir.25
Nitelikler (Attributes): Bir varlığın özelliklerini tanımlayan verilerdir. Örneğin, bir "Kitap" varlığının "Başlık", "ISBN" veya "Yayın Yılı" gibi nitelikleri olabilir.25 ERD'de genellikle oval şekillerle gösterilir ve ait oldukları varlığa bir çizgi ile bağlanır. Özel nitelik türleri şunları içerir:
Anahtar Nitelik (Key Attribute): Bir varlığı benzersiz şekilde tanımlayan niteliktir (örn. BookId). Genellikle altı çizili olarak gösterilir.26
Kısmi Anahtar Nitelik (Partial Key Attribute): Zayıf bir varlığı, sahibi olan varlığın anahtar niteliğiyle birleştiğinde benzersiz şekilde tanımlayan niteliktir. Kesik altı çizili olarak gösterilir.26
Çok Değerli Nitelik (Multivalued Attribute): Aynı sütunda birden fazla değer tutabilen niteliktir (örn. bir kişinin birden fazla telefon numarası). Çift ovalle gösterilir.26
Türetilmiş Nitelik (Derived Attribute): Değeri başka niteliklerden hesaplanan niteliktir (örn. doğum tarihinden hesaplanan yaş). Kesik ovalle gösterilir.26
Bileşik Nitelikler (Composite Attributes): Daha küçük parçalara ayrılabilen niteliklerdir (örn. "Adres" niteliği "Sokak", "Şehir", "Posta Kodu" gibi parçalara ayrılabilir).26
İlişkiler (Relationships): Varlıkların birbirleriyle nasıl etkileşime girdiğini gösterir.25 Genellikle bağlantı çizgileri ve oklarla temsil edilir ve ilişkinin anlamını açıklayan etiketler içerir. İlişki türleri (bire-bir, bire-çok, çoka-çok) ve katılım kısıtlamaları (zorunlu veya isteğe bağlı) bu çizgiler üzerinde veya uçlarında sembollerle belirtilir. Güçlü ilişkiler tek elmas, zayıf ilişkiler çift elmasla gösterilebilir (Chen Notasyonu).26

3.3. ERD Notasyonları

ERD çiziminde kullanılan çeşitli notasyonlar bulunmaktadır. En yaygın ikisi Chen Notasyonu ve Crow's Foot Notasyonu'dur.26

3.3.1. Chen Notasyonu

Bilgisayar bilimci Peter Chen tarafından 1970'lerde geliştirilen bu notasyon, kavramsal veri modellemesi için daha fazla detay sunar ve beyin fırtınası süreçlerinde kullanışlıdır.25 Chen notasyonunda:
Varlıklar: Dikdörtgenlerle temsil edilir.
Nitelikler: Oval şekillerle gösterilir ve varlıklara çizgilerle bağlanır. Anahtar nitelikler altı çizilidir.
İlişkiler: Elmas şekilleriyle temsil edilir ve ilgili varlıklara çizgilerle bağlanır.
Kardinalite ve Katılım: İlişki çizgileri üzerinde sayılar (1, N, M) ve çizgilerin kalınlığı (tek çizgi kısmi katılım, çift çizgi toplam katılım) ile belirtilir.26
Chen Notasyonu, kavramsal modellemede detaylı bir bakış açısı sunsa da 26, diyagramın karmaşıklığı arttıkça okunabilirliği Crow's Foot notasyonuna göre daha az kompakt olabilir.31 Bu durum, notasyon seçiminin projenin aşamasına ve hedef kitlesine göre değişebileceğini göstermektedir.

3.3.2. Crow's Foot Notasyonu

Gordon Everest tarafından 1976'da ortaya çıkan Crow's Foot notasyonu, "çok" kardinalitesini temsil eden sembolün karga ayağına benzemesi nedeniyle bu adı almıştır.31 Bu notasyon, Chen notasyonuna göre daha kompakt ve görsel olarak daha kolay okunabilir olduğu için özellikle mantıksal ve fiziksel veri modellemede tercih edilir.31 Sembollerin netliği, karmaşık ilişkileri hızlıca anlamayı sağlar.
Crow's Foot notasyonunda:
Varlıklar: Basit dikdörtgenlerle temsil edilir.30 Nitelikler genellikle varlık kutularının içine liste halinde yazılır, birincil anahtarlar kalın ve altı çizili, yabancı anahtarlar ise italik olarak belirtilebilir.30
İlişkiler: Varlıkları bağlayan çizgilerle gösterilir.30
Kardinalite Sembolleri: İlişki çizgilerinin uçlarındaki semboller, ilişkinin kardinalitesini (sayısını) ve katılımını (zorunluluğunu) belirtir.30 Bu semboller, ilişkinin her iki tarafındaki minimum ve maksimum örnek sayısını gösterir:
Halka (Ring - O): "Sıfır"ı temsil eder. İlişkinin bu tarafında minimum sıfır örnek olduğunu, yani katılımın isteğe bağlı olduğunu gösterir.30
Çizgi (Dash - |): "Bir"i temsil eder. İlişkinin bu tarafında minimum veya maksimum bir örnek olduğunu gösterir. Minimum bir olması, katılımın zorunlu olduğunu belirtir.30
Karga Ayağı (Crow's Foot - <): "Çok" veya "Sonsuz"u temsil eder. İlişkinin bu tarafında maksimum çok sayıda örnek olduğunu gösterir.30
Bu semboller birleştirilerek farklı kardinalite kombinasyonları oluşturulur:

Sembol
Anlam
Açıklama
O (Halka)
Sıfır
İlişkinin bu tarafında minimum sıfır örnek. (İsteğe bağlı katılım) 30
**
** (Çizgi)
Bir
< (Karga Ayağı)
Çok (Many)
İlişkinin bu tarafında maksimum çok sayıda örnek. 30
**O
**
Sıfır veya Bir
**


**
O<
Sıfır veya Çok
İsteğe bağlı bire-çok. 30
**
<**
Bir veya Çok

Crow's Foot notasyonunun kompakt yapısı, büyük ve karmaşık diyagramlarda okunabilirlik avantajı sağlar ve bu nedenle endüstriyel uygulamalarda yaygın olarak kullanılır.30 Bu durum, notasyon seçiminin pratik faydaları ve endüstri standardı olma potansiyeli açısından önemini gösterir.

3.4. ERD Çizim Adımları

ERD çizimi, veritabanı tasarımının sistematik bir yaklaşımını gerektiren iteratif bir süreçtir. Aşağıdaki adımlar, etkili bir ERD oluşturmak için izlenebilir:
Varlık Setlerini Belirleme: Sistemin temel işlevselliği için gerekli olan ana nesneleri veya kavramları tanımlayın (örneğin, Kitap, Üye, Yazar, Ödünç Alma).28 Bu, veritabanının hangi temel bilgileri depolayacağını belirlemenin ilk adımıdır.
Nitelikleri Atama: Her varlığın sahip olması gereken özellikleri veya sütunları belirleyin (örneğin, Kitap için Başlık, ISBN, Yayın Yılı).28 Bu adımda, her niteliğin veri türü ve kısıtlamaları (NULL olabilir mi, benzersiz mi vb.) da düşünülmelidir.
Anahtar Nitelikleri Bulma: Her varlık için benzersiz birincil anahtarları (PK) tanımlayın.28 Bu anahtarlar, her kaydı tekil olarak tanımlamak için kullanılır. Bileşik anahtarların gerektiği durumları da göz önünde bulundurun.
İlişkileri Belirleme: Varlıklar arasındaki mantıksal bağlantıları ve bu ilişkilerin türlerini (bire-bir, bire-çok, çoka-çok) tanımlayın.28 Her ilişkinin bir adı olmalı ve iki varlık arasındaki etkileşimi açıkça ifade etmelidir.
Kardinalite ve Kısıtlamaları Ayarlama: Her ilişkinin her iki tarafındaki minimum ve maksimum katılımları (kardinalite) belirleyin.28 Bu, ilişkinin zorunlu mu yoksa isteğe bağlı mı olduğunu ve bir varlığın diğerine kaç örnekle bağlanabileceğini gösterir.
Diyagramı Çizme: Seçtiğiniz notasyonu (örneğin Crow's Foot) kullanarak varlıkları (dikdörtgenler), nitelikleri (varlık kutularının içinde) ve ilişkileri (çizgiler ve kardinalite sembolleri) görselleştirin.25 Çoka-çok ilişkiler için ara tabloyu açıkça gösterin. Miro, Creately, EdrawMax veya Visio gibi araçlar bu süreçte yardımcı olabilir.
İnceleme ve İyileştirme: Çizilen diyagramı dikkatlice gözden geçirin. Gereksiz veya eksik ilişkileri, yanlış kardinaliteleri kontrol edin ve normalizasyon kurallarına uygunluğunu doğrulayın.30 ERD çizimi iteratif bir süreçtir; ilk taslaklar genellikle mükemmel değildir ve normalizasyon kuralları veya iş gereksinimlerindeki değişiklikler doğrultusunda revize edilmesi gerekir. Bu süreç, veritabanı tasarımının dinamik doğasını yansıtır. ERD çizim adımları sistematik bir yaklaşım sunarken, tasarımın ilk seferde kusursuz olmaması iteratif iyileştirme ihtiyacını doğurur.30 Bu durum, yazılım mühendisliğindeki genel iteratif geliştirme prensiplerinin veritabanı tasarımına da uygulandığını göstermektedir.

Bölüm 4: EF Core ile İlişkisel Veritabanı İlişkileri Kurma (C# ve MySQL)


4.1. EF Core'a Giriş ve MySQL için Kurulum

Entity Framework Core (EF Core),.NET uygulamaları ile ilişkisel veritabanları arasında bir köprü görevi görür. Geliştiricilerin veritabanı şemasını C# sınıfları (entity'ler) olarak modellemesini sağlar ve bu modeller üzerinden veritabanı işlemlerini gerçekleştirmeyi kolaylaştırır.5
MySQL ile çalışmak için,.NET projenize aşağıdaki NuGet paketlerini eklemeniz gerekmektedir:
Microsoft.EntityFrameworkCore.Design: EF Core araçlarını (migrations gibi) kullanmak için gereklidir.
Pomelo.EntityFrameworkCore.MySql: MySQL veritabanı sağlayıcısıdır.
Projenizde bir DbContext sınıfı tanımlanmalıdır. Bu sınıf, veritabanı oturumunu temsil eder ve veritabanındaki tablolarınıza karşılık gelen DbSet özelliklerini içerir. Veritabanı bağlantı dizesi, DbContext sınıfının OnConfiguring metodunda veya harici bir yapılandırma dosyası (örn. appsettings.json) aracılığıyla belirtilir.

C#


// Örnek DbContext sınıfı
public class MyLibraryContext : DbContext
{
    public DbSet<Book> Books { get; set; }
    public DbSet<Author> Authors { get; set; }
    //... diğer DbSet'ler

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        // MySQL bağlantı dizesi
        optionsBuilder.UseMySql("Server=localhost;Port=3306;Database=LibraryDb;Uid=root;Pwd=password;",
                                ServerVersion.AutoDetect("Server=localhost;Port=3306;Database=LibraryDb;Uid=root;Pwd=password;"));
    }
}



4.2. Entity Tanımlama ve Özellik Eşleme

EF Core'da entity'ler, veritabanı tablolarına eşlenen basit C# sınıflarıdır (POCO - Plain Old CLR Objects). Bu sınıfların özellikleri, tablolardaki sütunlara eşlenir. EF Core, bu eşlemeyi yapılandırmak için iki ana yaklaşım sunar: Data Annotations ve Fluent API.
Data Annotations: Bu yaklaşım, eşleme kurallarını doğrudan entity sınıflarındaki özelliklere nitelikler (attributes) ekleyerek tanımlar.32 Basit senaryolar için hızlı ve okunabilir bir yol sunar.
[Key]: Bir özelliği birincil anahtar olarak işaretler.32
``: Bir entity'nin eşlendiği veritabanı tablosunun adını belirtir.32
[Column("ColumnName")]: Bir özelliği belirli bir veritabanı sütununa eşler.32
[ForeignKey("ForeignKeyProperty")]: Bir navigasyon özelliği için yabancı anahtar özelliğini belirtir.32
[InverseProperty("NavigationProperty")]: Bir ilişkinin diğer ucundaki navigasyon özelliğini belirtir.32
[Unicode(false)], [MaxLength(22)]: Sütun veri tipini (Unicode olmayan) ve uzunluğunu kontrol eder.32
C#
public class Book
{
    [Key]
    public int Id { get; set; }
    public string Title { get; set; }
    [Unicode(false)] // Maps to varchar in MySQL
    [MaxLength(22)]
    public string Isbn { get; set; }
}


Fluent API: Bu yaklaşım, DbContext sınıfı içindeki OnModelCreating metodunda ModelBuilder nesnesini kullanarak eşleme kurallarını programatik olarak tanımlar.5 Fluent API, Data Annotations'a göre daha esnek ve karmaşık yapılandırmalara olanak tanır ve çakışma durumlarında Data Annotations'dan daha önceliklidir.6
Data Annotations, basit senaryolar için hızlı ve okunabilir bir yol sunarken, Fluent API karmaşık ilişkiler, özelleştirilmiş eşlemeler ve veritabanı davranışları üzerinde tam kontrol sağlar. Büyük projelerde veya karmaşık veritabanı şemalarında Fluent API'nin kullanılması, kodun daha düzenli ve sürdürülebilir olmasını sağlar. Data Annotations'ın kolaylığı hızlı başlangıç ve basit modeller için uygunluk sağlarken, Fluent API'nin esnekliği ve önceliği karmaşık ilişkiler ve özel senaryolar için gereklilik arz eder.6 Bu durum, geliştiricinin projenin karmaşıklığına ve ölçeğine göre doğru yapılandırma yaklaşımını seçmesi gerektiğini gösterir.

4.3. Bire-Bir İlişkileri EF Core'da Yapılandırma

Bire-bir ilişkiler, bir entity'nin en fazla bir başka entity ile ilişkili olduğu durumlar için kullanılır.5
Entity Sınıfları: Bu ilişkide genellikle bir tarafta birincil anahtar, diğer tarafta ise bu anahtara referans veren bir yabancı anahtar bulunur. Bu yabancı anahtar genellikle aynı zamanda bağımlı entity'nin birincil anahtarıdır veya benzersiz bir kısıtlamaya sahiptir. Her iki entity'de de ilgili entity'ye referans veren navigasyon özellikleri tanımlanır.6
Fluent API: HasOne().WithOne().HasForeignKey<DependentEntity>(e => e.ForeignKeyProperty) deseni kullanılır.5 İlişkinin zorunlu (required) veya isteğe bağlı (optional) olduğu
IsRequired() metodu ile belirtilir.7
Tablo Bölme (Table Splitting): İki entity'nin mantıksal olarak ayrı olmasına rağmen aynı fiziksel veritabanı tablosunu paylaşması durumudur. Bu senaryoda, her iki entity'nin de aynı birincil anahtara sahip olması ve aralarında bir bire-bir ilişki tanımlanması gerekir.20 Bu yaklaşım, performans veya kapsülleme amacıyla bir tablodaki sütunların bir alt kümesini kullanmak istendiğinde faydalıdır.
C# Kod Örneği (Fluent API - Zorunlu Bire-Bir):
Bu örnekte, bir Blog'un bir BlogHeader'a sahip olduğu ve her BlogHeader'ın tek bir Blog'a ait olduğu zorunlu bir bire-bir ilişki gösterilmektedir.

C#


// Principal (Parent) Entity
public class Blog
{
    public int Id { get; set; }
    public string Name { get; set; }
    public BlogHeader Header { get; set; } // Bağımlı entity'ye referans navigasyon
}

// Dependent (Child) Entity
public class BlogHeader
{
    public int Id { get; set; }
    public int BlogId { get; set; } // Zorunlu yabancı anahtar özelliği
    public Blog Blog { get; set; } = null!; // Asıl entity'ye zorunlu referans navigasyon
}

// DbContext Yapılandırması
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Blog>()
       .HasOne(e => e.Header) // Bir Blog'un bir BlogHeader'ı vardır
       .WithOne(e => e.Blog)  // Bir BlogHeader'ın bir Blog'u vardır
       .HasForeignKey<BlogHeader>(e => e.BlogId) // BlogHeader'daki BlogId, yabancı anahtardır
       .IsRequired(); // İlişkiyi zorunlu yapar
}


Bire-bir ilişkilerde HasForeignKey kullanımı, EF Core'un hangi özelliğin yabancı anahtar olduğunu ve dolayısıyla hangi entity'nin bağımlı olduğunu anlaması için önemlidir.7 Tablo bölme, mantıksal olarak ayrı olan ancak fiziksel olarak aynı tabloda depolanan veriler için performans ve organizasyon avantajları sunar. Bire-bir ilişkilerin tanımı ve uygulama alanları 3 EF Core'da
HasOne().WithOne().HasForeignKey() ile yapılandırılır.7 Tablo bölme kavramı 20, performans ve kapsülleme için aynı fiziksel tabloya birden fazla entity eşlemeyi mümkün kılar. Bu durum, EF Core'un esnek eşleme yeteneklerinin karmaşık veritabanı gereksinimlerine nasıl yanıt verdiğini gösterir.

4.4. Bire-Çok İlişkileri EF Core'da Yapılandırma

Bire-çok ilişkiler, bir entity'nin birden çok başka entity ile ilişkili olduğu durumlarda kullanılır.5 Bu, EF Core'da en sık kullanılan ve genellikle kural tabanlı (convention-based) yapılandırma ile otomatik olarak keşfedilen ilişkilerdir.14
Entity Sınıfları: "Bir" tarafındaki (principal) entity'de, ilgili "çok" tarafındaki (dependent) entity'lerin bir koleksiyon navigasyon özelliği (ICollection<T>) bulunur. "Çok" tarafındaki entity'de ise, "bir" tarafındaki entity'ye referans veren bir referans navigasyon özelliği ve yabancı anahtar özelliği tanımlanır.33
Fluent API: HasMany().WithOne().HasForeignKey() deseni kullanılır.5 İlişkinin zorunlu veya isteğe bağlı olduğu
IsRequired() metodu ile belirtilir.14
Basamaklı Silme Davranışları (OnDelete): Ana entity silindiğinde bağımlı entity'lere ne olacağını kontrol etmek için OnDelete() metodu kullanılır. Bu, veritabanındaki referans bütünlüğü kurallarını yönetir.5 Yaygın
DeleteBehavior seçenekleri şunlardır: Cascade (bağımlıları da sil), SetNull (yabancı anahtarı NULL yap), NoAction (hiçbir şey yapma, silmeyi engelle) ve Restrict (silmeyi engelle).
C# Kod Örneği (Fluent API - Zorunlu Bire-Çok):
Bu örnekte, bir Blog'un birden çok Post'a sahip olduğu ve her Post'un tek bir Blog'a ait olduğu zorunlu bir bire-çok ilişki gösterilmektedir.

C#


// Principal (One) Entity
public class Blog
{
    public int Id { get; set; }
    public string Name { get; set; }
    public ICollection<Post> Posts { get; set; } // Bağımlı entity'lere koleksiyon navigasyon
}

// Dependent (Many) Entity
public class Post
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }
    public int BlogId { get; set; } // Zorunlu yabancı anahtar özelliği
    public Blog Blog { get; set; } = null!; // Asıl entity'ye zorunlu referans navigasyon
}

// DbContext Yapılandırması
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Blog>()
       .HasMany(b => b.Posts) // Bir Blog'un birçok Post'u vardır
       .WithOne(p => p.Blog)  // Her Post'un bir Blog'u vardır
       .HasForeignKey(p => p.BlogId) // Post'taki BlogId yabancı anahtardır
       .IsRequired(); // İlişkiyi zorunlu yapar
}


Bire-çok ilişkiler, EF Core'da en sık kullanılan ve genellikle kural tabanlı (convention-based) yapılandırma ile otomatik olarak keşfedilen ilişkilerdir.14 Ancak, açık Fluent API yapılandırması, özellikle yabancı anahtar adlandırma kurallarına uyulmadığında veya özel silme davranışları gerektiğinde önemlidir.14 Bu durum, EF Core'un "convention over configuration" prensibini uygularken, gerektiğinde esneklik sağladığını gösterir.

4.5. Çoka-Çok İlişkileri EF Core'da Yapılandırma

Çoka-çok ilişkiler, iki entity arasında her iki yönde de bire-çok ilişki olduğunda ortaya çıkar.5 Bu tür ilişkiler, ilişkisel veritabanlarında bir
ara tablo (join table) aracılığıyla temsil edilir.
EF Core 5.0 Öncesi: EF Core 5.0 öncesi sürümlerde, çoka-çok ilişkileri modellemek için her zaman açıkça bir ara entity (join entity) tanımlamak zorunluydu. Bu ara entity, iki ana entity'nin yabancı anahtarlarını içeren bir bileşik anahtara sahipti.23
EF Core 5.0 ve Sonrası: EF Core 5.0 ile birlikte, UsingEntity() metodu kullanılarak ara entity'yi açıkça tanımlamadan da çoka-çok ilişkiler yapılandırılabilir.24 Bu, kodu basitleştirir. Ancak, ara tabloya ek veri (payload) eklenmesi gerekiyorsa (örneğin, bir ilişkinin oluşturulduğu tarih gibi), yine de bir ara entity sınıfı tanımlamak tercih edilir.24
Entity Sınıfları: Her iki ana entity'de de diğer entity'nin bir koleksiyon navigasyon özelliği bulunur. Eğer ara entity açıkça tanımlanıyorsa, ana entity'ler bu ara entity'ye navigasyon özelliği üzerinden bağlanır.23
Fluent API: HasMany().WithMany().UsingEntity() deseni kullanılır. Bu, EF Core'a ara tabloyu nasıl oluşturacağını ve ilişkileri nasıl kuracağını söyler.24 Ara tablonun birincil anahtarı genellikle iki yabancı anahtarın bileşik anahtarı olarak yapılandırılır.
C# Kod Örneği (Fluent API - Çoka-Çok, Ara Entity ile):
Bu örnekte, Book ve Category entity'leri arasında bir çoka-çok ilişki, BookCategory adında açık bir ara entity kullanılarak gösterilmektedir. BookCategory ayrıca ilişkinin oluşturulduğu tarihi (AddedDate) tutan bir "payload" özelliğine sahiptir.

C#


// Main Entities
public class Book
{
    public int BookId { get; set; }
    public string Title { get; set; }
    // Diğer özellikler...

    // Ara entity'ye navigasyon özelliği
    public ICollection<BookCategory> BookCategories { get; set; }
}

public class Category
{
    public int CategoryId { get; set; }
    public string Name { get; set; }
    // Diğer özellikler...

    // Ara entity'ye navigasyon özelliği
    public ICollection<BookCategory> BookCategories { get; set; }
}

// Join Entity (Ara Tablo)
public class BookCategory
{
    public int BookId { get; set; } // PK, FK
    public Book Book { get; set; } // Kitap entity'sine referans

    public int CategoryId { get; set; } // PK, FK
    public Category Category { get; set; } // Kategori entity'sine referans

    // İsteğe bağlı: İlişkiye ait ek veri (payload)
    public DateTime AddedDate { get; set; }
}

// DbContext Yapılandırması
public class LibraryDbContext : DbContext
{
    public DbSet<Book> Books { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<BookCategory> BookCategories { get; set; } // Ara entity için DbSet

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        // MySQL bağlantı dizesi
        optionsBuilder.UseMySql("Server=localhost;Port=3306;Database=LibraryDb;Uid=root;Pwd=password;",
                                ServerVersion.AutoDetect("Server=localhost;Port=3306;Database=LibraryDb;Uid=root;Pwd=password;"));
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Ara tablo için bileşik birincil anahtar tanımla
        modelBuilder.Entity<BookCategory>()
           .HasKey(bc => new { bc.BookId, bc.CategoryId });

        // İlişkileri yapılandır
        modelBuilder.Entity<BookCategory>()
           .HasOne(bc => bc.Book) // BookCategory'nin bir Book'u vardır
           .WithMany(b => b.BookCategories) // Bir Book'un birçok BookCategory'si vardır
           .HasForeignKey(bc => bc.BookId); // BookCategory'deki BookId yabancı anahtardır

        modelBuilder.Entity<BookCategory>()
           .HasOne(bc => bc.Category) // BookCategory'nin bir Category'si vardır
           .WithMany(c => c.BookCategories) // Bir Category'nin birçok BookCategory'si vardır
           .HasForeignKey(bc => bc.CategoryId); // BookCategory'deki CategoryId yabancı anahtardır

        // Payload özelliğini yapılandır (isteğe bağlı)
        modelBuilder.Entity<BookCategory>()
           .Property(bc => bc.AddedDate)
           .HasDefaultValueSql("CURRENT_TIMESTAMP"); // MySQL için varsayılan değer
    }
}


Çoka-çok ilişkilerin EF Core'da ele alınışı, ORM'lerin veritabanı modelini uygulama modeline nasıl soyutladığını gösteren iyi bir örnektir. EF Core 5.0 ile gelen UsingEntity() metodu, geliştiricinin ara entity'yi açıkça modellemesi gerekliliğini ortadan kaldırarak kodu basitleştirmiştir. Ancak, ara tabloda ek veri gerektiğinde ara entity'nin hala faydalı olduğu bu örnekte açıkça görülmektedir.24 Bu durum, EF Core'un evriminin ve tasarım kararlarının pratik kullanım senaryolarına göre nasıl şekillendiğini ortaya koyar.

4.6. EF Core Migrations ile Veritabanı Şemasını Yönetme


Migrations Nedir ve Neden Kullanılır?

Migrations, EF Core'un veritabanı şemasını zaman içinde, mevcut veriyi koruyarak, uygulamanın veri modeliyle senkronize tutmak için kullanılan bir özelliğidir.8 Geliştirme sırasında hızlı iterasyon için veritabanını tamamen silip yeniden oluşturmak (
Create ve Drop API'leri) pratik olabilir. Ancak, üretim ortamında mevcut veriyi kaybetmeden şemayı güvenli bir şekilde evrimleştirmek için migrations vazgeçilmezdir.8
Migrations'ın sunduğu avantajlar şunlardır:
Şema Evrimi Takibi: Uygulama geliştikçe veritabanı şeması da değişir. Migrations, bu değişiklikleri zaman içinde izlemeyi ve yönetmeyi sağlar.9
Kolay Veritabanı Yönetimi: Veritabanı değişikliklerini versiyonlu bir şekilde yönetme imkanı sunar, bu da uygulamanın evrimiyle birlikte veritabanı yönetimini kolaylaştırır.9
Otomatik Veritabanı Oluşturma: Manuel SQL betikleri yazma ihtiyacını ortadan kaldırarak veritabanı şemasını otomatik olarak oluşturmayı sağlar.9
Tutarlı Veritabanı Durumu: Veritabanının tüm örneklerinin (geliştirme, test, üretim) tutarlı bir durumda olmasını sağlar, bu da hataları ve tutarsızlıkları azaltır.9
İyileştirilmiş İşbirliği: Her geliştiricinin veritabanının en son şema değişiklikleriyle senkronize bir yerel kopyasıyla çalışmasına olanak tanıyarak ekip içinde işbirliğini kolaylaştırır.9
Migrations, veritabanı şema yönetimini kod tabanlı hale getirerek (Code-First yaklaşımı), veritabanı değişikliklerini versiyon kontrol sistemine entegre etmeyi sağlar.8 Bu, özellikle ekip ortamlarında veya Sürekli Entegrasyon/Sürekli Dağıtım (CI/CD) süreçlerinde veritabanı dağıtımını otomatikleştirmek için kritik bir yetenektir.10

Migration Oluşturma ve Uygulama Adımları:

EF Core CLI Araçlarını Yükleme: Komut satırından EF Core araçlarını kullanmak için aşağıdaki komutu çalıştırmanız gerekir:
Bash
dotnet tool install --global dotnet-ef

Bu araçlar, tüm platformlarda çalışır.8
İlk Migration'ı Oluşturma: Uygulamanızın veri modelindeki ilk şema değişikliklerini yansıtmak için bir migration oluşturulur. Projenizin kök dizininde aşağıdaki komutu çalıştırın:
Bash
dotnet ef migrations add InitialCreate

Bu komut, projenizde Migrations adında bir dizin oluşturur ve içinde bir C# sınıfı (genellikle _InitialCreate.cs adında) ve bir ModelSnapshot.cs dosyası oluşturur.8 C# sınıfı,
Up() ve Down() olmak üzere iki metot içerir. Up() metodu, modeldeki değişiklikleri veritabanı şemasına uygulamak için gerekli SQL komutlarını (C# kodu olarak) içerirken, Down() metodu bu değişiklikleri geri almak için kullanılır.9
ModelSnapshot dosyası, mevcut veritabanı şemasının anlık görüntüsünü tutar ve EF Core'un sonraki migration'ları oluştururken farkları algılamasına yardımcı olur.8
Veritabanını Güncelleme (Migration'ı Uygulama): Oluşturulan migration'ı veritabanına uygulamak için aşağıdaki komutu kullanın:
Bash
dotnet ef database update

Bu komut, Up() metodunu çalıştırarak veritabanı şemasını günceller.9 EF Core, veritabanında
__EFMigrationsHistory adında özel bir tablo oluşturarak hangi migration'ların uygulandığını takip eder.8 Bu tablo, EF Core'un yalnızca henüz uygulanmamış migration'ları çalıştırmasını sağlar.
Modeli Geliştirme ve Yeni Migration'lar Ekleme: Uygulama modelinizde (entity sınıflarınızda) yeni bir entity, özellik ekleme veya mevcut bir özelliği değiştirme gibi değişiklikler yaptığınızda, yeni bir migration oluşturmanız gerekir:
Bash
dotnet ef migrations add AddNewFeatureTable

EF Core, mevcut ModelSnapshot ile yeni modeli karşılaştırarak farkları otomatik olarak algılar ve bu farkları yansıtan yeni bir migration dosyası oluşturur.8 Ardından,
dotnet ef database update komutunu tekrar çalıştırarak bu yeni migration'ı veritabanına uygulayabilirsiniz.
Uygulama Sırasında Migration Uygulama: Uygulama başlatıldığında bekleyen migration'ları otomatik olarak uygulamak için DbContext üzerinde Database.Migrate() metodu kullanılabilir 9:
C#
using (var context = new MyLibraryContext())
{
    context.Database.Migrate(); // Bekleyen tüm migration'ları uygular
}


Migrations, veritabanı şema yönetimini kod tabanlı hale getirerek, veritabanı değişikliklerini versiyon kontrol sistemine entegre etmeyi sağlar.8 Bu durum, özellikle ekip ortamlarında veya CI/CD (Sürekli Entegrasyon/Sürekli Dağıtım) süreçlerinde veritabanı dağıtımını otomatikleştirmek için kritik bir yetenektir.10
Up ve Down metotlarının varlığı, gerektiğinde şema değişikliklerini geri alma (rollback) yeteneği sunar, ancak genellikle "geri alma yerine ileri gitme" (roll forward) stratejisi önerilir.10 Bu strateji, veri kaybını önlemeye ve daha sağlam dağıtım süreçleri oluşturmaya yardımcı olur. Şema değişikliklerinin kaçınılmazlığı ve manuel SQL yazmanın zorluğu ve hata riski, Migrations'ın otomasyon yeteneğini ön plana çıkarır.9 Code-First yaklaşımı ve Migrations'ın birlikte kullanımı, veritabanı şemasının uygulama koduyla senkronize kalmasını sağlayarak geliştirici verimliliğini artırır. CI/CD entegrasyonu, otomatik dağıtım ve sürekli teslimatı mümkün kılar.
Up ve Down metotları geri alma yeteneği sunsa da, "roll forward" stratejisinin tercih edilmesi veri kaybını önlemeye ve daha sağlam dağıtım süreçleri oluşturmaya yardımcı olur.9 Bu durum, Migrations'ın sadece bir araç olmaktan öte, modern yazılım geliştirme metodolojilerinin temel bir parçası olduğunu gösterir.

Bölüm 5: Basit Kütüphane Otomasyonu Veritabanı Tasarımı ve ER Diyagramı

Bu bölümde, öğrenilen ilişkisel veritabanı kavramları ve EF Core bilgisi kullanılarak basit bir kütüphane otomasyon sistemi için veritabanı tasarlanacak ve bir Varlık İlişki Diyagramı (ERD) çizilecektir.

5.1. Gereksinim Analizi: Kütüphane Sistemi için Temel Varlıklar ve İşlevler

Basit bir kütüphane otomasyon sistemi, temel olarak kitapların, üyelerin ve ödünç alma/iade işlemlerinin yönetimini içermelidir.28 Bu sistemin temel işlevleri şunları kapsamalıdır:
Kitap Yönetimi: Kitapların kataloğunu tutma (başlık, yazar, ISBN, kategori, yayıncı, yayın yılı).
Üye Yönetimi: Kütüphane üyelerinin kaydı ve yönetimi (ad, soyad, e-posta, telefon numarası, adres, üyelik tarihi).
Ödünç Alma/İade İşlemleri: Kitapların ödünç alınması ve iade edilmesi süreçlerini kaydetme (ödünç alma tarihi, iade tarihi, son iade tarihi, gecikme ücretleri).
Yazar ve Yayıncı Bilgileri: Kitapların yazarları ve yayıncıları hakkında ayrıntılı bilgi tutma.
Kategori Yönetimi: Kitapları farklı kategorilere ayırma (örneğin, Bilim Kurgu, Tarih, Roman).
Kitap Rezervasyonu (İsteğe Bağlı): Bir kitabın müsait olmadığı durumlarda üyelerin rezervasyon yapabilmesi.
Gereksinim analizi, veritabanı tasarımının ilk ve en kritik adımıdır. Doğru varlıkları ve ilişkileri belirlemek, sistemin işlevselliğini ve ölçeklenebilirliğini doğrudan etkiler. Bu aşamada, iş kurallarının (örneğin, bir üyenin aynı anda kaç kitap ödünç alabileceği veya bir kitabın kaç kopyası olduğu) netleştirilmesi önemlidir, çünkü bunlar veritabanı kısıtlamalarına dönüşecektir.28 İşlevsel gereksinimlerin belirlenmesi, varlıkların ve niteliklerin tanımlanmasına yol açar.35 İş kurallarının anlaşılması, bu gereksinimlerin veritabanı kısıtlamalarına dönüşmesini sağlar.28 Bu durum, yazılım geliştirmenin "gereksinimlerden tasarıma" akışının veritabanı özelinde nasıl uygulandığını göstermektedir.

5.2. Varlıkların ve Niteliklerin Belirlenmesi

Yukarıdaki gereksinimler doğrultusunda, kütüphane otomasyonu için aşağıdaki temel varlıklar ve nitelikler belirlenmiştir:
Varlık Adı
Anahtar Nitelik (PK)
Diğer Nitelikler
Books
BookId
Title, ISBN, PublicationYear, PublisherId (FK), GenreId (FK)
Authors
AuthorId
FirstName, LastName, Biography
Publishers
PublisherId
Name, Address, Phone
Genres
GenreId
Name
Members
MemberId
FirstName, LastName, Email, PhoneNumber, Address, MembershipDate
Borrows
BorrowId
BookId (FK), MemberId (FK), BorrowDate, ReturnDate, DueDate, FineAmount
BookAuthors
BookId (PK, FK), AuthorId (PK, FK)
(Ara tablo, ek nitelik yok)


5.3. İlişkilerin Tanımlanması ve Kardinalite

Belirlenen varlıklar arasındaki ilişkiler ve kardinaliteleri aşağıdaki gibidir:
Publishers - Books: Bir yayıncı birden çok kitap yayınlayabilir, ancak bir kitap tek bir yayıncıya aittir. Bu, Bire-Çok (1:N) bir ilişkidir. Books tablosundaki PublisherId sütunu, Publishers tablosundaki PublisherId birincil anahtarına başvurur.37
Genres - Books: Bir kategori birden çok kitap içerebilir, ancak bir kitap tek bir kategoriye aittir. Bu da Bire-Çok (1:N) bir ilişkidir. Books tablosundaki GenreId sütunu, Genres tablosundaki GenreId birincil anahtarına başvurur.37
Authors - Books: Bir yazar birden çok kitap yazabilir ve bir kitap da birden çok yazar tarafından yazılabilir. Bu, Çoka-Çok (N:M) bir ilişkidir. Bu ilişki, BookAuthors adında bir ara tablo ile çözülür. BookAuthors tablosundaki AuthorId ve BookId sütunları, sırasıyla Authors ve Books tablolarına yabancı anahtar olarak başvurur ve birlikte BookAuthors tablosunun bileşik birincil anahtarını oluştururlar.36
Members - Borrows: Bir üye birden çok kitap ödünç alabilir (birden çok ödünç alma işlemi yapabilir), ancak her bir ödünç alma işlemi tek bir üyeye aittir. Bu, Bire-Çok (1:N) bir ilişkidir. Borrows tablosundaki MemberId sütunu, Members tablosundaki MemberId birincil anahtarına başvurur.28
Books - Borrows: Bir kitap birden çok kez ödünç alınabilir (farklı zamanlarda veya farklı üyeler tarafından), ancak her bir ödünç alma işlemi tek bir kitaba aittir. Bu da Bire-Çok (1:N) bir ilişkidir. Borrows tablosundaki BookId sütunu, Books tablosundaki BookId birincil anahtarına başvurur.36
Aşağıdaki tablo, kütüphane otomasyonu sistemi için belirlenen ilişkileri ve kardinalitelerini özetlemektedir:
İlişki
İlişki Türü
Açıklama
Publishers - Books
Bire-Çok (1:N)
Bir yayıncı birçok kitap yayınlar, bir kitap bir yayıncıya aittir.
Genres - Books
Bire-Çok (1:N)
Bir kategori birçok kitap içerir, bir kitap bir kategoriye aittir.
Authors - Books
Çoka-Çok (N:M)
Bir yazar birçok kitap yazabilir, bir kitap birçok yazara sahip olabilir. (Ara tablo: BookAuthors)
Members - Borrows
Bire-Çok (1:N)
Bir üye birçok ödünç alma işlemi yapabilir, bir ödünç alma bir üyeye aittir.
Books - Borrows
Bire-Çok (1:N)
Bir kitap birçok kez ödünç alınabilir, bir ödünç alma bir kitaba aittir.


5.4. Normalizasyon Uygulaması

Yukarıdaki veritabanı tasarımı, Üçüncü Normal Form (3NF) kurallarına uygun olarak yapılmıştır:
1NF Uygunluğu: Her tabloda atomik değerler bulunur ve tekrarlayan gruplar veya çok değerli nitelikler yoktur. Her varlık, benzersiz bir birincil anahtar ile tanımlanmıştır. Örneğin, bir kitabın birden fazla yazarı olması durumu, BookAuthors adında ayrı bir ara tablo ile ele alınmıştır, böylece Books tablosunda tekrarlayan yazar bilgileri bulunmaz.
2NF Uygunluğu: Kısmi bağımlılıklar ortadan kaldırılmıştır. Örneğin, BookAuthors ara tablosu, BookId ve AuthorId'den oluşan bileşik birincil anahtara sahiptir. Bu tablodaki herhangi bir nitelik, bu bileşik anahtarın tamamına bağımlıdır.
3NF Uygunluğu: Geçişli kısmi bağımlılıklar ortadan kaldırılmıştır. Örneğin, Books tablosunda doğrudan yayıncı adı veya kategori adı yerine, PublisherId ve GenreId gibi yabancı anahtarlar kullanılarak Publishers ve Genres tablolarına referans verilmiştir. Bu, yayıncı veya kategori bilgilerinin sadece kendi tablolarında depolanmasını ve diğer tablolarda tekrarlanmamasını sağlar.
Normalizasyon, tasarım sürecinin ayrılmaz bir parçasıdır. Varlıklar ve nitelikler belirlenirken, veri tekrarını önlemek ve tutarlılığı sağlamak için normalizasyon kuralları sürekli göz önünde bulundurulmalıdır. Bu yaklaşım, daha temiz, daha verimli ve daha kolay yönetilebilir bir veritabanı şeması sağlar. Varlık ve nitelik belirleme aşamasında ortaya çıkabilecek potansiyel veri tekrarı ve anomali riski, normalizasyon kurallarının uygulanmasıyla giderilir ve bu da temiz ve tutarlı bir şema elde edilmesini sağlar. Bu, tasarım sürecinin teorik prensiplerle nasıl iç içe geçtiğini açıkça ortaya koyar.

5.5. Kütüphane Otomasyonu ER Diyagramı (Crow's Foot Notasyonu)

Bu bölümde, yukarıda tanımlanan varlıklar ve ilişkiler kullanılarak Crow's Foot notasyonunda bir Varlık İlişki Diyagramı (ERD) çizimi sunulacaktır. Gerçek bir görsel diyagram bu raporun metinsel formatında doğrudan gösterilemese de, bir görselleştirme aracı kullanılarak (örneğin Miro, Creately, EdrawMax veya Visio) aşağıdaki gibi bir diyagram oluşturulabilir:
ERD'nin Görselleştirilmesi:
Varlık Kutuları: Her varlık (Books, Authors, Publishers, Genres, Members, Borrows, BookAuthors) bir dikdörtgen içinde temsil edilecektir.
Nitelikler: Her varlık kutusunun içinde, yukarıdaki "Varlıklar ve Nitelikler" tablosunda belirtilen nitelikler listelenecektir.
Birincil anahtarlar (örn. BookId, AuthorId) kalın ve altı çizili olarak gösterilecektir.
Yabancı anahtarlar (örn. PublisherId, GenreId in Books tablosunda) italik olarak gösterilecektir.
İlişki Çizgileri ve Kardinalite Sembolleri: Varlıklar arasındaki ilişkiler çizgilerle bağlanacak ve her çizginin uçlarında Crow's Foot notasyonunun kardinalite sembolleri yer alacaktır:
Publishers ve Books arasındaki ilişki: Publishers tarafından |< (Bir veya Çok), Books tarafından || (Tam Olarak Bir) sembolleri ile gösterilecektir. Bu, bir yayıncının birçok kitabı olabileceğini, ancak bir kitabın tam olarak bir yayıncıya ait olduğunu belirtir.
Genres ve Books arasındaki ilişki: Benzer şekilde, Genres tarafından |< (Bir veya Çok), Books tarafından || (Tam Olarak Bir) sembolleri ile gösterilecektir.
Authors ve Books arasındaki çoka-çok ilişki, BookAuthors ara tablosu üzerinden gösterilecektir:
Authors ve BookAuthors arasında: Authors tarafından |< (Bir veya Çok), BookAuthors tarafından || (Tam Olarak Bir) sembolleri.
Books ve BookAuthors arasında: Books tarafından |< (Bir veya Çok), BookAuthors tarafından || (Tam Olarak Bir) sembolleri.
BookAuthors tablosu, BookId ve AuthorId'den oluşan bileşik birincil anahtara sahip olacaktır.
Members ve Borrows arasındaki ilişki: Members tarafından |< (Bir veya Çok), Borrows tarafından || (Tam Olarak Bir) sembolleri ile gösterilecektir.
Books ve Borrows arasındaki ilişki: Books tarafından |< (Bir veya Çok), Borrows tarafından || (Tam Olarak Bir) sembolleri ile gösterilecektir.
Bu diyagram, kullanıcının teorik bilgiyi pratik bir görselleştirmeye dönüştürme yeteneğini pekiştirecek ve kütüphane otomasyonu için somut bir şema örneği sunacaktır.

5.6. EF Core Modellerinin Oluşturulması (C#)

Tasarlanan ERD'ye uygun olarak, her varlık için C# entity sınıfları ve bir DbContext sınıfı tanımlanacaktır. İlişkiler ve kısıtlamalar, Fluent API kullanılarak OnModelCreating metodunda yapılandırılacaktır.

C#


using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

// Entity Sınıfları

public class Book
{
    public int BookId { get; set; } // PK
    public string Title { get; set; }
    public string ISBN { get; set; } // Unique
    public int PublicationYear { get; set; }

    // Foreign Keys
    public int PublisherId { get; set; }
    public int GenreId { get; set; }

    // Navigation Properties
    public Publisher Publisher { get; set; } // One-to-Many (Book to Publisher)
    public Genre Genre { get; set; } // One-to-Many (Book to Genre)
    public ICollection<BookAuthor> BookAuthors { get; set; } // Many-to-Many (Book to Author via BookAuthor)
    public ICollection<Borrow> Borrows { get; set; } // One-to-Many (Book to Borrows)
}

public class Author
{
    public int AuthorId { get; set; } // PK
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Biography { get; set; }

    // Navigation Property
    public ICollection<BookAuthor> BookAuthors { get; set; } // Many-to-Many (Author to Book via BookAuthor)
}

public class Publisher
{
    public int PublisherId { get; set; } // PK
    public string Name { get; set; }
    public string Address { get; set; }
    public string Phone { get; set; }
    // Publisher'ın kitaplarını tutan bir koleksiyon navigasyonu eklemeye gerek yoksa WithMany() boş bırakılabilir.
    // public ICollection<Book> Books { get; set; }
}

public class Genre
{
    public int GenreId { get; set; } // PK
    public string Name { get; set; }
    // Genre'nin kitaplarını tutan bir koleksiyon navigasyonu eklemeye gerek yoksa WithMany() boş bırakılabilir.
    // public ICollection<Book> Books { get; set; }
}

public class Member
{
    public int MemberId { get; set; } // PK
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; } // Unique
    public string PhoneNumber { get; set; }
    public string Address { get; set; }
    public DateTime MembershipDate { get; set; }

    // Navigation Property
    public ICollection<Borrow> Borrows { get; set; } // One-to-Many (Member to Borrows)
}

public class Borrow
{
    public int BorrowId { get; set; } // PK
    public int BookId { get; set; } // FK
    public int MemberId { get; set; } // FK
    public DateTime BorrowDate { get; set; }
    public DateTime? ReturnDate { get; set; } // Nullable, optional
    public DateTime DueDate { get; set; }
    public decimal? FineAmount { get; set; } // Nullable, optional

    // Navigation Properties
    public Book Book { get; set; } // One-to-Many (Borrow to Book)
    public Member Member { get; set; } // One-to-Many (Borrow to Member)
}

// Join Entity for Many-to-Many relationship between Book and Author
public class BookAuthor
{
    public int BookId { get; set; } // PK, FK
    public Book Book { get; set; }

    public int AuthorId { get; set; } // PK, FK
    public Author Author { get; set; }
}

// DbContext Sınıfı
public class LibraryDbContext : DbContext
{
    public DbSet<Book> Books { get; set; }
    public DbSet<Author> Authors { get; set; }
    public DbSet<Publisher> Publishers { get; set; }
    public DbSet<Genre> Genres { get; set; }
    public DbSet<Member> Members { get; set; }
    public DbSet<Borrow> Borrows { get; set; }
    public DbSet<BookAuthor> BookAuthors { get; set; } // Join entity için DbSet

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        // MySQL bağlantı dizesi ve ServerVersion'ın otomatik tespiti
        optionsBuilder.UseMySql("Server=localhost;Port=3306;Database=LibraryDb;Uid=root;Pwd=password;",
                                ServerVersion.AutoDetect("Server=localhost;Port=3306;Database=LibraryDb;Uid=root;Pwd=password;"));
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Many-to-Many ilişkisini yapılandırma (Book ve Author arasında BookAuthor aracılığıyla)
        modelBuilder.Entity<BookAuthor>()
           .HasKey(ba => new { ba.BookId, ba.AuthorId }); // Ara tablo için bileşik PK

        modelBuilder.Entity<BookAuthor>()
           .HasOne(ba => ba.Book) // BookAuthor'ın bir Book'u vardır
           .WithMany(b => b.BookAuthors) // Bir Book'un birçok BookAuthor'ı vardır
           .HasForeignKey(ba => ba.BookId); // BookAuthor'daki BookId yabancı anahtardır

        modelBuilder.Entity<BookAuthor>()
           .HasOne(ba => ba.Author) // BookAuthor'ın bir Author'ı vardır
           .WithMany(a => a.BookAuthors) // Bir Author'ın birçok BookAuthor'ı vardır
           .HasForeignKey(ba => ba.AuthorId); // BookAuthor'daki AuthorId yabancı anahtardır

        // Bire-Çok ilişkilerini yapılandırma

        // Book - Publisher ilişkisi
        modelBuilder.Entity<Book>()
           .HasOne(b => b.Publisher) // Bir Book'un bir Publisher'ı vardır
           .WithMany() // Publisher'ın Book koleksiyonuna ihtiyacı yoksa boş bırakılır
           .HasForeignKey(b => b.PublisherId); // Book'taki PublisherId yabancı anahtardır

        // Book - Genre ilişkisi
        modelBuilder.Entity<Book>()
           .HasOne(b => b.Genre) // Bir Book'un bir Genre'ı vardır
           .WithMany() // Genre'nin Book koleksiyonuna ihtiyacı yoksa boş bırakılır
           .HasForeignKey(b => b.GenreId); // Book'taki GenreId yabancı anahtardır

        // Borrow - Book ilişkisi
        modelBuilder.Entity<Borrow>()
           .HasOne(br => br.Book) // Bir Borrow'un bir Book'u vardır
           .WithMany(b => b.Borrows) // Bir Book'un birçok Borrow'u vardır
           .HasForeignKey(br => br.BookId); // Borrow'daki BookId yabancı anahtardır

        // Borrow - Member ilişkisi
        modelBuilder.Entity<Borrow>()
           .HasOne(br => br.Member) // Bir Borrow'un bir Member'ı vardır
           .WithMany(m => m.Borrows) // Bir Member'ın birçok Borrow'u vardır
           .HasForeignKey(br => br.MemberId); // Borrow'daki MemberId yabancı anahtardır

        // Ek kısıtlamalar
        // ISBN'nin benzersiz olmasını sağla
        modelBuilder.Entity<Book>()
           .HasIndex(b => b.ISBN)
           .IsUnique();

        // Üye E-postasının benzersiz olmasını sağla
        modelBuilder.Entity<Member>()
           .HasIndex(m => m.Email)
           .IsUnique();
    }
}


C# entity sınıflarının ve DbContext yapılandırmasının ERD ile doğrudan eşleşmesi, Code-First yaklaşımının gücünü gösterir. Bu, veritabanı şemasının koddan türetilmesini ve böylece geliştirme sürecinde tutarlılığın sağlanmasını kolaylaştırır. Migrations ile birlikte kullanıldığında, bu modeller veritabanını otomatik olarak oluşturabilir ve güncelleyebilir. ERD tasarımı, C# entity modellerine, oradan Fluent API yapılandırmalarına ve son olarak EF Core Migrations ile veritabanı oluşturmaya kadar uçtan uca bir geliştirme akışını temsil eder.

Sonuç ve İleri Adımlar

Bu rapor, ilişkisel veritabanı temellerinden (birincil anahtarlar, yabancı anahtarlar, normalizasyon) Varlık İlişki Diyagramı (ERD) çizimine (Chen ve Crow's Foot notasyonları) ve Entity Framework Core (EF Core) kullanarak C# ile ilişkileri yapılandırmaya (bire-bir, bire-çok, çoka-çok) kadar geniş bir yelpazede bilgi sunmuştur. Basit bir kütüphane otomasyonu örneği üzerinden teorik bilgilerin pratik uygulaması gösterilmiş ve bu sistem için bir veritabanı şeması tasarlanmıştır. Bu kapsamlı rehber, kullanıcının MySQL ve EF Core ile ilişkisel veritabanı tasarımı ve uygulaması konusunda sağlam bir temel oluşturmasını sağlamıştır.
Kütüphane otomasyonu projesini daha da genişletmek ve geliştirmek için aşağıdaki adımlar önerilebilir:
Rezervasyon Sistemi: Kitapların müsaitlik durumuna göre rezervasyon yapma ve yönetme işlevselliği eklenmelidir. Bu, Reservations gibi yeni bir entity ve Book ile Member arasında ilişkiler gerektirecektir.
Personel Yönetimi: Kütüphane personelinin yetkilendirme ve rol tabanlı erişim kontrolü için ayrı bir Staff entity'si ve Roles ile ilişkileri tanımlanabilir.
Gecikme Ücreti Hesaplama: Otomatik gecikme ücreti hesaplama ve tahsilat mekanizmaları geliştirilebilir. Bu, Borrow tablosundaki FineAmount alanının otomatik olarak güncellenmesini ve belki de bir Payments tablosu ile ilişkilendirilmesini gerektirebilir.
Kitap Kopyaları: Her kitabın birden fazla kopyasının takibi için ayrı bir BookCopies tablosu oluşturulabilir. Bu tablo, Book entity'sine bire-çok ilişkiyle bağlanır ve her bir kopyanın durumunu (ödünç alınabilir, onarımda vb.) tutabilir.
Arama ve Filtreleme: Gelişmiş arama ve filtreleme özellikleri (başlık, yazar, kategoriye göre) eklenerek kullanıcı deneyimi iyileştirilebilir. EF Core'un LINQ yetenekleri bu konuda yardımcı olacaktır.
Raporlama: Ödünç alma geçmişi, en popüler kitaplar, üye istatistikleri gibi raporlar oluşturulabilir. Bu, karmaşık sorguların yazılmasını veya özel raporlama entity'lerinin tanımlanmasını gerektirebilir.
EF Core ve veritabanı tasarımında daha ileri konulara yönelmek isteyenler için aşağıdaki alanlar incelenebilir:
Daha Yüksek Normal Formlar: BCNF (Boyce-Codd Normal Form), Dördüncü Normal Form (4NF) ve Beşinci Normal Form (5NF) gibi daha ileri normalizasyon seviyeleri ve bunların spesifik kullanım senaryoları araştırılabilir.
Denormalizasyon: Performans optimizasyonu için denormalizasyonun ne zaman ve nasıl uygulanacağı, normalizasyonun getirdiği sorgu birleştirme maliyetlerini azaltma yöntemleri incelenebilir.
Concurrency Kontrolü: EF Core'da eşzamanlılık çakışmalarını (aynı anda aynı verinin birden fazla kullanıcı tarafından değiştirilmesi) nasıl yönetileceği (örneğin, RowVersion veya ConcurrencyCheck nitelikleri ile) öğrenilebilir.
Sorgu Optimizasyonu: LINQ sorgularını daha verimli hale getirme, N+1 sorgu sorunlarını çözme (eager loading, lazy loading, explicit loading) ve karmaşık sorguları optimize etme teknikleri derinlemesine incelenebilir.
Performans İzleme: Veritabanı ve EF Core uygulamalarının performansını izleme araçları ve yöntemleri (örneğin, sorgu profilleyiciler) hakkında bilgi edinilebilir.
Test Edilebilirlik: EF Core uygulamaları için birim ve entegrasyon testleri yazma pratikleri, veritabanı bağımlılıklarını izole etme yöntemleri öğrenilebilir.
Bu konuların her biri, veritabanı ve ORM teknolojileri konusundaki uzmanlığı daha da derinleştirecek ve daha karmaşık, ölçeklenebilir ve performanslı uygulamalar geliştirmeye olanak tanıyacaktır.
Alıntılanan çalışmalar
Tablolar arası İlişkiler (Bire-bir, Bire-çok, Çoka-çok) - Favorim, erişim tarihi Ağustos 16, 2025, https://favorim.net/tablolar-arasi-iliskiler-bire-bir-bire-cok-coka-cok/
İlişkisel veritabanı - Vikipedi, erişim tarihi Ağustos 16, 2025, https://tr.wikipedia.org/wiki/%C4%B0li%C5%9Fkisel_veritaban%C4%B1
Define relationships between tables in an Access database ..., erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/access/define-table-relationships
Primary and foreign key constraints - SQL Server | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints?view=sql-server-ver17
EF Core Relationships: Types, Foreign Keys & Examples - Devart Blog, erişim tarihi Ağustos 16, 2025, https://blog.devart.com/ef-core-relationships.html
Introduction to relationships - EF Core | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/ef/core/modeling/relationships
One-to-one relationships - EF Core | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/ef/core/modeling/relationships/one-to-one
Migrations Overview - EF Core | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/
Entity Framework Core Migrations - Learn Entity Framework Core, erişim tarihi Ağustos 16, 2025, https://www.learnentityframeworkcore.com/migrations
What exactly are EF Core migrations(or database schema migrations) and how do you use them in your developer workflow/sdlc? - Reddit, erişim tarihi Ağustos 16, 2025, https://www.reddit.com/r/dotnet/comments/1gkkw5f/what_exactly_are_ef_core_migrationsor_database/
Connect to MySQL using EF Core - YouTube, erişim tarihi Ağustos 16, 2025, https://www.youtube.com/watch?v=nXYc37-IxmM
Veritabanı Yönetimi - OMÜ - Akademik Veri Yönetim Sistemi, erişim tarihi Ağustos 16, 2025, https://avys.omu.edu.tr/storage/app/public/baris.ozkan/121120/END315%20-%20HF%2003.pdf
Database Normalization – Normal Forms 1nf 2nf 3nf Table Examples, erişim tarihi Ağustos 16, 2025, https://www.freecodecamp.org/news/database-normalization-1nf-2nf-3nf-table-examples/
Configuring one-to-many Relationship in Entity Framework Core, erişim tarihi Ağustos 16, 2025, https://www.learnentityframeworkcore.com/configuration/one-to-many-relationship-configuration
Database normalization description - Microsoft 365 Apps | Microsoft ..., erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/access/database-normalization-description
Normalization in DBMS - 1NF, 2NF, 3NF, BCNF, 4NF and 5NF | Studytonight, erişim tarihi Ağustos 16, 2025, https://www.studytonight.com/dbms/database-normalization.php
Veritabanı ve Yönetim Sistemleri - Ankara Üniversitesi Açık Ders Malzemeleri, erişim tarihi Ağustos 16, 2025, https://acikders.ankara.edu.tr/mod/resource/view.php?id=45133
Learn One-to-One and Many-to-Many | Relational Database - Codefinity, erişim tarihi Ağustos 16, 2025, https://codefinity.com/courses/v2/5ac24d9d-4a16-45b3-8856-07dec028c5e9/3d6c4ab0-f470-4b5d-ad0e-5f76d28ca0af/7992cacf-81b2-4169-b8e9-6d2e322daf07
Database Relationships, erişim tarihi Ağustos 16, 2025, https://condor.depaul.edu/gandrus/240IT/accesspages/relationships.htm
Advanced table mapping - EF Core | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/ef/core/modeling/table-splitting
Configuring One To One Relationship In Entity Framework Core, erişim tarihi Ağustos 16, 2025, https://www.learnentityframeworkcore.com/configuration/one-to-one-relationship-configuration
Video: Çoka çok ilişkiler oluşturma - Microsoft Support, erişim tarihi Ağustos 16, 2025, https://support.microsoft.com/tr-tr/office/video-%C3%A7oka-%C3%A7ok-ili%C5%9Fkiler-olu%C5%9Fturma-e65bcc53-8e1c-444a-b4fb-1c0b8c1f5653
Configuring Many To Many Relationship in Entity Framework Core, erişim tarihi Ağustos 16, 2025, https://www.learnentityframeworkcore.com/configuration/many-to-many-relationship-configuration
Configure Many-to-Many relationship using Fluent API in Entity ..., erişim tarihi Ağustos 16, 2025, https://www.yogihosting.com/fluent-api-many-to-many-relationship-entity-framework-core/
Varlık ilişki şeması nedir? | Miro, erişim tarihi Ağustos 16, 2025, https://miro.com/tr/diagramming/what-is-an-er-diagram/
Chen Notasyonu İle Veritabanı Tasarımı – Aktif Elektroteknik, erişim tarihi Ağustos 16, 2025, https://aktif.net/chen-notasyonu-ile-veritabani-tasarimi/
Library management model – Entity-relationship diagram example ..., erişim tarihi Ağustos 16, 2025, https://www.gleek.io/templates/er-library-management
ER Diagram for Library Management System + Free Templates ..., erişim tarihi Ağustos 16, 2025, https://creately.com/guides/er-diagram-for-library-management-systems/
ER Diagrams for Library Management System: A Complete Tutorial ..., erişim tarihi Ağustos 16, 2025, https://www.edrawsoft.com/article/er-diagrams-for-library-management-system.html
Create a diagram with crow's foot database notation - Microsoft ..., erişim tarihi Ağustos 16, 2025, https://support.microsoft.com/en-us/office/create-a-diagram-with-crow-s-foot-database-notation-1ec22af9-3bd3-4354-b2b5-ed5752af6769
2.4. ERD alternatives and variations — A Practical Introduction to ..., erişim tarihi Ağustos 16, 2025, https://runestone.academy/ns/books/published/practical_db/PART2_DATA_MODELING/04-other-notations/other-notations.html
Mapping Attributes in Entity Framework Core, erişim tarihi Ağustos 16, 2025, https://www.learnentityframeworkcore.com/misc/mapping-attributes
One-to-many relationships - EF Core | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/ef/core/modeling/relationships/one-to-many
Changing Foreign Keys and Navigations - EF Core | Microsoft Learn, erişim tarihi Ağustos 16, 2025, https://learn.microsoft.com/en-us/ef/core/change-tracking/relationship-changes
Setting Up a Library Management System - Analytics Vidhya, erişim tarihi Ağustos 16, 2025, https://www.analyticsvidhya.com/blog/2022/07/library-management-system-using-mysql/
The Library – Entity Relationship Diagram (ERD) - 101 Computing, erişim tarihi Ağustos 16, 2025, https://www.101computing.net/the-library-entity-relationship-diagram-erd/
ER diagram of Library Management System - GeeksforGeeks, erişim tarihi Ağustos 16, 2025, https://www.geeksforgeeks.org/dbms/er-diagram-of-library-management-system/
