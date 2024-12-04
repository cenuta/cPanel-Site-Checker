
# cPanel-Site-Checker

**cPanel-Site-Checker**, cPanel tabanlı sunucular için geliştirilmiş bir bash scriptidir. Bu araç, sunucudaki tüm hesapları tarayarak hangi sitelerin bu sunucudan çalıştığını belirler. Özellikle sistem yöneticileri için site durumu takibini kolaylaştırmak amacıyla tasarlanmıştır.

---

**cPanel-Site-Checker** is a bash script designed to monitor and verify which sites are actively running on your cPanel-based server. It automates the process of checking all cPanel accounts, identifying whether the sites are served from your server or another one, and categorizing them accordingly.

---

## Version History / Sürüm Geçmişi

- **v1.2** (2024-12-04):  
  - Ana ve addon domain kontrolleri tüm sunucu IP adreslerine karşı yapılarak doğruluk oranı artırıldı.  
  - Aynı domain için ardışık tekrar eden uyumsuzluk kayıtları tek bir satıra indirildi.  
  - Pasif siteler listesine eklemeden önce ikinci bir IP uyumluluğu kontrolü eklendi.  
  - Uyumluluk kontrolleri için sunucudaki IP adresleri `ip addr` komutu ile alınıyor.  

- **v1.1** (2024-12-03):  
  - Ana domain kontrolü tamamlandıktan sonra addon domainler için detaylı kontrol eklendi.  
  - Doğrulama dosyası (`cenuta-dogrulama.txt`) üzerinden kontrol yapılmaya devam edilmekte.  
  - Daha detaylı hata logları ve performans iyileştirmeleri sağlandı.  

- **v1.0** (2024-12-01):  
  - Script, ana domainlerin çalışıp çalışmadığını kontrol ederek sonuçları ilgili dosyalara yazmaktadır.  
  - İlk doğrulama yöntemi olarak doğrulama dosyası kullanıldı ve işlemler sonunda dosyalar otomatik olarak temizleniyor.  

---

## Features / Özellikler

- **Multi-IP Compatibility:** Checks the compatibility of both main and addon domains with all IPs assigned to the server.  
- **Optimized Logging:** Combines repeated mismatch logs into a single, cleaner entry for better readability.  
- **Detailed Categorization:** Domains are categorized into **Active**, **Inactive**, and **Error** based on their validation status.  
- **Automated Validation Process:** Creates and validates a temporary file (`cenuta-dogrulama.txt`) for each domain and removes it automatically after the check.  
- **User-Friendly Output Files:** Generates organized logs:  
  - `site_aktif.txt` for active domains.  
  - `site_pasif.txt` for inactive domains.  
  - `hatalar.txt` for errors.  

---

- **Çoklu IP Uyumluluğu:** Ana ve addon domainlerin sunucuya bağlı tüm IP adresleriyle uyumluluğu kontrol edilir.  
- **Optimize Edilmiş Loglama:** Aynı uyumsuzluk tekrarları tek bir satırda birleştirilerek daha okunabilir raporlama sağlanır.  
- **Detaylı Kategorilendirme:** Domainler; **Aktif**, **Pasif** ve **Hatalı** olarak kategorilere ayrılır.  
- **Otomatik Doğrulama Süreci:** Her domain için doğrulama dosyası oluşturulup, kontrol tamamlandıktan sonra otomatik olarak temizlenir.  
- **Kullanıcı Dostu Çıktı Dosyaları:**  
  - `site_aktif.txt`: Aktif domainler.  
  - `site_pasif.txt`: Pasif domainler.  
  - `hatalar.txt`: Hatalar.  

---

## How It Works / Nasıl Çalışır

1. The script lists all cPanel accounts and their main domains.  
2. It creates a unique validation file (`cenuta-dogrulama.txt`) in the root directory of each domain.  
3. The script sends a HTTP request to the domain to check if the validation file is accessible.  
4. The response is compared to the expected content. Based on the result, the site is categorized:  
   - **Active**: Site is running from the server.  
   - **Inactive**: Site is likely hosted elsewhere.  
   - **Error**: The validation file could not be accessed or returned an unexpected result.  
5. After the check, the validation files are automatically removed from the domains.  

---

1. Script, tüm cPanel hesaplarını ve ana domainlerini listeler.  
2. Her domainin kök dizinine benzersiz bir doğrulama dosyası (`cenuta-dogrulama.txt`) oluşturur.  
3. Script, doğrulama dosyasının erişilebilir olup olmadığını kontrol etmek için domain'e HTTP isteği gönderir.  
4. Gelen cevap, beklenen içerik ile karşılaştırılır. Sonuçlara göre site aşağıdaki kategorilere ayrılır:  
   - **Aktif**: Site sunucudan çalışıyor.  
   - **Pasif**: Site başka bir sunucuda barınıyor.  
   - **Hatalı**: Doğrulama dosyasına ulaşılamaz veya beklenmeyen bir sonuç dönülür.  
5. Kontrol işlemi tamamlandıktan sonra, doğrulama dosyaları otomatik olarak silinir.  

---

## Requirements / Gereksinimler

- **Bash**: The script is written in Bash, so it requires a Linux-based server (e.g., CentOS, Ubuntu) to run.  
- **cPanel/WHM**: The script is specifically designed to work with cPanel accounts.

- **Bash**: Script Bash ile yazılmıştır, bu yüzden çalışabilmesi için Linux tabanlı bir sunucuya (örneğin, CentOS, Ubuntu) ihtiyaç vardır.  
- **cPanel/WHM**: Script, özellikle cPanel hesaplarıyla uyumlu olarak çalışacak şekilde tasarlanmıştır.

---

## Installation / Kurulum

1. Clone the repository to your server:  
   ```bash
   git clone https://github.com/cenuta/cPanel-Site-Checker.git  
   cd cPanel-Site-Checker  
   ```

2. Make the script executable:  
   ```bash
   chmod +x checker.sh  
   ```

3. Run the script:  
   ```bash
   ./checker.sh  
   ```

4. Check the results:  
   - **`site_aktif.txt`**: Sites running on this server.  
   - **`site_pasif.txt`**: Sites that are inactive or hosted elsewhere.  
   - **`hatalar.txt`**: Errors or issues with specific sites.

---

## Example Output / Örnek Çıktı

- **`site_aktif.txt`**:  
  - example1.com - user1  
  - example2.com - user2

- **`site_pasif.txt`**:  
  - example3.com - user3

- **`hatalar.txt`**:  
  - example4.com - user4: Error: 404 Not Found

---

## Contact / İletişim

For more information or support, please contact [mertcenikut@cenuta.com](mailto:mertcenikut@cenuta.com).  

Daha fazla bilgi veya destek için lütfen [mertcenikut@cenuta.com](mailto:mertcenikut@cenuta.com) ile iletişime geçin.
