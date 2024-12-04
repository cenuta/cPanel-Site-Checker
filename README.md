%100 doğru sonuç vermemektedir. Geliştirme aşamasında olup, manuel kontrol önerilmektedir.

# cPanel-Site-Checker

**cPanel-Site-Checker**, cPanel tabanlı sunucular için geliştirilmiş bir bash scriptidir. Bu araç, sunucudaki tüm hesapları tarayarak hangi sitelerin bu sunucudan çalıştığını belirler. Özellikle sistem yöneticileri için site durumu takibini kolaylaştırmak amacıyla tasarlanmıştır.

---

**cPanel-Site-Checker** is a bash script designed to monitor and verify which sites are actively running on your cPanel-based server. It automates the process of checking all cPanel accounts, identifying whether the sites are served from your server or another one, and categorizing them accordingly.

## Version History / Sürüm Geçmişi

- **v1.1** (2024-12-04): 
  - Ana domain kontrolü sağlandıktan sonra, yalnızca ana domain yönlü değilse addon domainler tek tek kontrol edilecektir.
  - Hatalı yanıtlar ve dosya erişim sorunları için daha detaylı loglama eklendi.

- **v1.0** (2024-12-01):
  - Script, ana domainin çalışıp çalışmadığını kontrol eder ve sonuçları dosyalara yazar.
  - Doğrulama dosyası oluşturulur ve ardından silinir.
 
  - 
## Features / Özellikler

- Scans all cPanel accounts automatically.  
- Verifies the active status of domains by checking a custom validation file placed in the root directory.  
- Categorizes sites as **Active**, **Inactive**, or **Error** based on the file validation response.  
- Uses a custom **User-Agent** ("Cenuta Checker") for curl requests.  
- Automatically cleans up the validation files after checking.  
- Lightweight and efficient, designed for server administrators and hosting companies.  

- Tüm cPanel hesaplarını otomatik tarar.  
- Ana domain üzerinden oluşturulan doğrulama dosyası ile sitenin sunucudan çalışıp çalışmadığını kontrol eder.  
- Aktif (çalışan), pasif (başka sunucuda) ve hatalı (eksik veya yanlış yapılandırılmış) siteleri ayırır.  
- Curl ile gönderilen isteklerde özel bir **User-Agent** ("Cenuta Checker") kullanarak kontrol yapar.  
- Doğrulama işlemi sonunda oluşturulan dosyaları otomatik temizler.  
- Kullanıcı dostu ve hızlıdır; sistem kaynaklarını verimli kullanır.  

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

## Requirements / Gereksinimler

- **Bash**: The script is written in Bash, so it requires a Linux-based server (e.g., CentOS, Ubuntu) to run.  
- **cPanel/WHM**: The script is specifically designed to work with cPanel accounts.

- **Bash**: Script Bash ile yazılmıştır, bu yüzden çalışabilmesi için Linux tabanlı bir sunucuya (örneğin, CentOS, Ubuntu) ihtiyaç vardır.  
- **cPanel/WHM**: Script, özellikle cPanel hesaplarıyla uyumlu olarak çalışacak şekilde tasarlanmıştır.

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

1. Depoyu sunucunuza klonlayın:  
   ```bash
   git clone https://github.com/cenuta/cPanel-Site-Checker.git  
   cd cPanel-Site-Checker  
   ```

2. Script'i çalıştırılabilir hale getirin:  
   ```bash
   chmod +x checker.sh  
   ```

3. Script'i çalıştırın:  
   ```bash
   ./checker.sh  
   ```

4. Sonuçları kontrol edin:  
   - **`site_aktif.txt`**: Bu sunucuda çalışan siteler.  
   - **`site_pasif.txt`**: Başka bir sunucuda barınan veya çalışmayan siteler.  
   - **`hatalar.txt`**: Hatalar veya sorunlar yaşayan siteler.

## Example Output / Örnek Çıktı

- **`site_aktif.txt`**:  
  - example1.com - user1  
  - example2.com - user2

- **`site_pasif.txt`**:  
  - example3.com - user3

- **`hatalar.txt`**:  
  - example4.com - user4: Error: 404 Not Found

---

- **`site_aktif.txt`**:  
  - example1.com - user1  
  - example2.com - user2

- **`site_pasif.txt`**:  
  - example3.com - user3

- **`hatalar.txt`**:  
  - example4.com - user4: Hata: 404 Bulunamadı
  - 

## Contact / İletişim

For more information or support, please contact [mertcenikut@cenuta.com](mailto:mertcenikut@cenuta.com).  

Daha fazla bilgi veya destek için lütfen [mertcenikut@cenuta.com](mailto:mertcenikut@cenuta.com) ile iletişime geçin.
