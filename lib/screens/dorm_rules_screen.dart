import 'package:flutter/material.dart';

class DormRulesScreen extends StatelessWidget {
  const DormRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yurt Kuralları'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'YURTLARDA BARINMA VE YAŞAM KURALLARI\nTAAHHÜTNAMESİ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '''YURTLARDA BARINMA VE YAŞAM KURALLARI
TAAHHÜTNAMESİ
GİRİŞ
Bu taahhütname, yurtta kalan veya ziyaret eden kişilerin daha güvenli ve düzen içinde yaşamalarını sağlamak
için oluşturulmuştur. Yurtların kullanımı ve yurt yaşamı ile ilgili temel koşulları ve kuralları içermektedir.
Madde1 - Koşullar:
Üniversite, öğrencinin, bu belgede belirtilen koşullar altında kendisine tahsis edilen odada barınma hakkını
kabul etmektedir.
Yurtlara yerleştirilen, fakat geçerli bir mazeret belirtmeksizin ayrılmak isteyen öğrencilerin yurt başvurusu
yapması engellenir.
Madde 2 - Oda Atamaları:
Yurt yönetimi, odaların doluluklarını belirleme, odalardaki boşlukları doldurma, oda değişikliklerini onaylama ve
odalara atama yapma,iptal etme hakkına sahiptir.
Madde 3 - Konaklama Hizmetleri Yöneticisi ve/veya Yurt Görevlilerinin Odaya Girme Hakkı:
Konaklama Hizmetleri Yöneticisi ve/veya Yurt Görevlileri genel maksatlı, ihbara dayalı güvenlik veya disiplini
sağlama gerekçesi ile oda kontrolü yapabilirler.
Bakım-onarım amacıyla, gerekli onaya sahip olmadan herhangi bir eşyanın yurttaki yerinin değiştirildiğinin
tespiti veya acil bir tehlikenin mevcut olması halinde de odalara girme hakkına sahiptir.
Madde 4 - Kişisel Eşyalar.
Hiç bir şart altında, Üniversite öğrencinin kişisel eşyalarının kaybolmasından veya zarar görmesinden sorumlu
olmayacaktır.
Madde 5 - Kural ve Düzenlemeler:
Öğrenci, Konaklama Hizmetleri Birimi’nin kural ve düzenlemelerine uymakla yükümlüdür. Bu kural ve
düzenlemelerin ihlal edilmesi, gerekli disiplin işlemlerinin yapılmasına yol açabilir.
Madde 6 - Transfer:
Konaklama Hizmetleri Birimi, yurt binalarından bir diğer yurt binasına öğrenci kaydırma ve oda ataması yapma
hakkına sahiptir.
Madde 7 - Kişisel Sorumluluklar ve Kamusal Haklar:
8.1. Yurtların içinde veya çevresinde gürültü yapmamalı veya gürültünün yapılmasına katkıda bulunmamalıdır.
8.2. Diğer yurt sakinlerinin çalışmasına veya istirahatine engel olmamalıdır.
8.3. Diğer bir yurt sakininin veya bir yurt çalışanının, yurttaki odasına veya ofisine serbestçe girip çıkmasına
engel olmamalıdır.
8.4. Yurtlarda koridor ve odalarda spor oyunları oynamamalıdır.
8.5. Diğer yurt sakinlerinin temiz ve güvenli bir çevrede yaşama haklarına engel olmamalıdır.
8.6. Yurtlara hayvan sokmamalı ve beslememelidir (görme özürlüler için klavuz köpekler hariç).
8.7. Genel ahlak ölçülerinin dışında bir kıyafet ile genel alanlarda dolaşmamalıdır.
8.8. Kapalı tüm alanlarda sigara içilmemelidir.
8.9. Genel alanlarda ve pencere kenarlarında kişisel eşya bulundurmamalıdır.
8.10. Kumar oynamamalı ve oynatmamalıdır.
8.11. Yurt yönetimince belirlenenler dışındaki yerlere izinsiz olarak yazı yazmamalı veya asmamalıdır.
8.12. Konaklama Hizmetleri Yöneticisinin veya görevlilerinin çağrılarına uymalı, çağrı yazılarını almaktan
kaçınmamalıdır.
8.13. Yurt görevlisinin izini olmadan oda değişikliği yapmamalıdır.
Madde 8 - Birey ve Kamunun Güvenliği
9.1. Güvenliği tehlikeye düşürecek davranışlarda bulunmamalı veya bu tür davranışlara yardımcı
olunmamalıdır.
FOTS-C310-01-04
9.2. Yurt penceresinden dışarıya bir şey atmamalı, pencere dışlarına herhangi bir şey konulmamalıdır.
9.3. Ruhsatlı bile olsa, ateşli ve kesici silah, havai fişek, patlayıcı madde veya öldürücü veya yaralayıcı sınıftaki
diğer tehlikeli silahları yurtlarda bulundurmamalı ve kullanmamalıdır.
9.4. Yurtlarda kimyasal madde veya bileşik bulundurmamalı ve kullanmamalıdır.
9.5. Yurtlarda veya yakın çevresinde ateş yakmamalıdır.
9.6. Sahte yangın ihbarında bulunmamalı ve hazırlanmış güvenlik kurallarını ihlal etmemelidir.
9.7. Yangın söndürme cihazları ile oynamamalı ve bunları yangın önleme amacı dışında kullanmamalıdır.
9.8. Yurtlar bölgesindeki havuzları, yüzme, oyun, şakalaşma vb. gibi sebeplerle kullanmamalıdır.
9.9. Odalarda yemek pişirmemelidir.
9.10. Odalarda televizyon, klima cihazı, yemek pişirme cihazları bulundurmamalı ve kullanmamalıdır.
9.11. Yurt yönetimince belirlenen yerler dışındaki yerlere, izinsiz olarak girmemeli veya girilmesine meydan
vermemelidir.
9.12. Konaklama Hizmetleri Yöneticisinin izni olmadan toplantı düzenlememeli veya böyle bir toplantıya
katılmamalıdır.
9.13. Yurt başvurularında eksik, yanıltıcı ve gerçeğe aykırı beyanda bulunmamalıdır.
9.14. Yurdun bina ve bölümlerini izinsiz olarak amacı dışında kullanmamalı ve yönetimin hizmetlerini
engellememelidir.
9.15. Yurt odası kapı önüne ayakkabı ve kişisel eşya koymamalıdır.
9.16. Kopya anahtar bulundurmamalıdır.
Madde 9 - Yasaklanmış Malzemeler:
9.1. Öğrencilere tahsis edilen odalarda, televizyon, klima cihazı, yemek pişirme cihazları, yanıcı ve patlayıcı
maddeler ile, ruhsatlı bile olsa, ateşli ve kesici silahların bulundurulması yasaktır.
9.2. Yurtlarda alkollü içecek ve uyuşturucu madde bulundurmamalı, kullanmamalı ve kullanılan ortamlarda yer
almamalıdır. Alkollü içecek ve uyuşturucu madde kullanılan öğrenci aktivitesi düzenlememeli ve bunlara
katılmamalıdır.
Yurt odalarında, kullanımı yasak eşyaların listesi, her oda kapısının iç tarafında demirbaş olarak asılıdır.
Madde 10 - Tehdit ve Taciz:
10.1. Bir başkasını tehdit ve taciz etmemelidir (Irk, inanç, etnik köken, cinsiyet, yaş, siyasi görüş veya özürlülük
haline dayalı tehdit ve tacizler.)
10.2. Bir başkasının şahsına veya malına zarar verecek davranışlarda bulunmamalıdır.
10.3. Hiçbir yurt çalışanını tehdit ve taciz etmemeli veya zarar verici davranışta bulunmamalıdır.
10.4. Hiçbir şikayet sahibine, görgü şahidine veya disiplin kurulu üyesine disiplin görüşmesinden önce, görüşme
sırasında veya görüşmeden sonra tehdit ve taciz edici davranışlarda bulunmamalıdır.
Madde 11 - Kişisel ve Kamusal Mal:
11.1. Başkalarının eşyalarını izinsiz olarak ödünç almamalıdır.
11.2. Hırsızlık yapmamalı veya yapılmasına yardım etmemelidir.
11.3. Yurt yönetiminden gerekli onaya sahip olmadan, yurt odasındaki ve ortak kullanım alanlarındaki
demirbaşların yerini değiştirmemelidir.
11.4. Kullanmakta olduğu yatak numarasına ait aynı numaralı keson ve dolabı kullanmalıdır.
11.5. Herhangi bir mala zarar vermemelidir.
11.6. Ortak kullanım alanlarında ve bina çevresinde kişisel ve/veya ortak kullanım alanına ait eşya
bulundurmamalıdır.
Madde 12 - Kişilerin Kimlik Tespiti:
Yurtlarda barınmak bir ayrıcalıktır. Bu nedenle, yurtta kalanların esenliğini korumak açısından kimlik tespiti
konusu önem arzettiğinden, yurt sakinleri ve ziyaretçiler;
12.1.Kendi üniversite kimlik kartını ve oda anahtarını başkalarının kullanmasına izin vermemelidir.
12.2.Bir başkasının üniversite kimlik kartını ve oda anahtarını kullanmamalıdır.
12.3.Sorulması durumunda, yurt görevlilerine ismini söylemeyi ve uygun bir kimlik kartını göstermeyi
reddetmemelidir.
Madde 13 - Ziyaretçiler:
13.1. Yurt sakini olsun ya da olmasın, kimseyi odasında yatılı olarak misafir edemeyecektir. Öğrenciler, velilerini,
akrabalarını ve arkadaşlarını, Üniversite tarafından belirlenen kurallar ve zaman sınırlamaları dahilinde
odalarında ziyaretçi olarak kabul edebilirler.
FOTS-C310-01-04
13.2. Ziyaretçilerinin sorumluluğunu almaktan kaçınmamalıdır.
13.3. Kendi haklarına tecavüz etmedikçe, bir başkasının ziyaretçisine müdahale etmemeli, sorun yaşanması
halinde Yurtlar Yönetiminden yardım istenmelidir.
13.4. Saat 23:00’dan sonra yurtta kalsın veya kalmasın, odasında başka bir öğrenci bulundurmamalı veya
başkasının odasında bulunmamalıdır.
13.5. İzinli ziyaretçi olmayan misafirler, en geç, son servis saatine kadar kampüsten ayrılmalıdır.
Madde 14 - Yurttan Ayrılış:
 Bu belgenin yürürlükte olduğu süre içinde yurttan ayrılmak isteyen öğrencinin ayrılışı, oda anahtarlarını yurt
görevlisine geri vermediği ve Yurt Odası Anahtar Teslim Formu’nu (FOTS-C310-01-V04) doldurmadığı sürece
resmiyet kazanmaz.
 Akademik yıl sonlarındaki veya kesin ayrılışlarda, odalardaki mobilya ve mefruşatın, eksiksiz ve hasarsız bir
şekilde bırakılması gerekmektedir.
 Yurtlardan akademik yıl sonlarında veya kesin ayrılışlarda, ilgili yurt görevlilerinin ofislerinde, Yurt Odası
Anahtar Teslim Formu (FOTS-C310-01-V04) doldurulmakta ve öğrenci tarafından, ilgili form imza altına
alınmaktadır. Öğrencinin, bu form doldurulmadan yurttan ayrılması halinde, tespit edilecek tüm hasardan
öğrenci sorumlu tutulacaktır.
 Öğrenciye yurt yönetimi tarafından verilen tüm anahtarlar Üniversite'nin malıdır ve başkalarının
anahtarlarıyla değiştirilemez veya başka bir kimseye verilemez.
 Kayıp anahtar bedelleri, Başkanlık Divanı’nın belirlediği ücretler doğrultusunda öğrenciden talep edilecektir.
 Yurttan ayrılırken kopya anahtar teslim etmemelidir.
 Oda teslim süreci sona ermesine rağmen, yurt odasını boşaltmayan, anahtar teslimi yapmayan öğrencilerin,
bir sonraki yıl için yurt başvuruları değerlendirmeye alınmayacak, bıraktıkları tüm eşyalar çöp olarak işlem
görecektir.
Madde 15 - Yurda Verilen Zararlar:
 Öğrenci, yurttaki veya odasındaki her türlü hasar ve kayıplardan sorumlu olacak ve tamir veya yenileme
masraflarını bildirilen süre içerisinde ödemekle yükümlü olacaktır. Bildirilen süre içerisinde ödeme yapılmaz ise
sistem tarafından hold konulacaktır.
 Eğer odalarda meydana gelecek kayıp ve hasarların sorumlusu (veya sorumluları) tespit edilemiyorsa, tüm
oda sakinleri yapılan tamir veya yenileme masraflarından sorumlu olacaktır.
 Yukarıda belirtilen kayıp ve hasarların tazmini maksadıyla her akademik yılbaşında belirlenen depozito
bedeli, belirtilen tarihler içinde ödenmelidir.
 Öğrencinin odasına veya yurda hasar vermeksizin yurttan ayrılması halinde bu bedel kendisine tam olarak
iade edilecektir.
Madde 16 - Yurt Başvurusunu Engelleyecek Tutum ve Davranışlar:
Yurt Yaşam Kurulu’ndan herhangi bir ceza almamış olunsa dahi, yurt başvurusunu engelleyecek tutum ve
davranışlar şunlardır;
16.1. Yurda yerleşmiş olmasına rağmen yurt ücretini geç yatırmamalıdır,
16.2. Depozito ücretini bildirilen zamanda yatırmalıdır,
16.3. Oda teslimini bildirilen zamanda yapmalıdır,
16.4. Yurt başvurusu yapıldıktan sonra, bildirilen sonuca kayıtsız kalmamalıdır,
16.5. Saygısız, kaba, küstah davranış şekli ile görevlileri sözlü ve /veya yazılı taciz etmemelidir,
16.6. Kendisine tahsis edilen yurt odasını başkasına kullandırmamalıdır.
Madde 17 – Öğrencinin Yurt Odasında Ve Bina İçi/Çevresinde Bıraktığı Eşyaların Durumu :
17.1. Öğrenci, “Yurt Odası Anahtar Teslim Formu” nu doldurduktan ve yurt odasını boşaltarak anahtar teslim
ettikten sonra, kullandığı odada eşya bırakması halinde, bıraktığı eşyaların çöp olarak değerlendirilmesinin
bilgisi dahilinde olduğunu kabul edecektir. Bu durumda odada bıraktığı eşyalar hakkında Üniversite aleyhine
herhangi bir hak ve iddiada bulunmayacaktır.
17.2. Anahtar tesliminden ve/veya dönem içinde, yurt binası içinde veya çevresinde eşya bırakması halinde,
eşyaların çöp olarak değerlendirilmesinin bilgisi dahilinde olduğunu kabul edecektir. Bu durumda yurt binası
içinde veya çevresinde bıraktığı eşyalar hakkında Üniversite aleyhine herhangi bir hak ve iddiada
bulunmayacaktır.''',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
} 