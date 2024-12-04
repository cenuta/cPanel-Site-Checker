#!/bin/bash

# Doğrulama dosyasının adı ve içeriği
VALIDATION_FILE="cenuta-dogrulama.txt"
VALIDATION_CONTENT="Bu site Cenuta sunucularından çalışmaktadır."

# Çıktı dosyaları
AKTIF="site_aktif.txt"
PASIF="site_pasif.txt"
HATALI="hatalar.txt"

# Eski dosyaları temizle
> $AKTIF
> $PASIF
> $HATALI

echo "Hesaplar kontrol ediliyor..."

# Sunucudaki tüm cPanel hesaplarını listele
for USER in $(/usr/local/cpanel/bin/whmapi1 listaccts | grep -oP '(?<=user: ).*'); do
    DOMAIN=$(/usr/local/cpanel/bin/whmapi1 accountsummary user=$USER | grep -oP '(?<=domain: ).*')

    if [ -z "$DOMAIN" ]; then
        echo "Hesap $USER için ana domain bulunamadı. Atlama yapılıyor..." >> $HATALI
        continue
    fi

    echo "Hesap: $USER, Domain: $DOMAIN kontrol ediliyor..."

    # Kullanıcının ana dizin yolunu belirle
    USER_HOME=$(grep "^$USER:" /etc/passwd | cut -d: -f6)
    PUBLIC_HTML="$USER_HOME/public_html"

    # Doğrulama dosyasını oluştur
    if [ -d "$PUBLIC_HTML" ]; then
        echo "$VALIDATION_CONTENT" > "$PUBLIC_HTML/$VALIDATION_FILE"
        echo "Doğrulama dosyası oluşturuldu: $PUBLIC_HTML/$VALIDATION_FILE"
    else
        echo "$DOMAIN - $USER için public_html dizini bulunamadı." >> $HATALI
        continue
    fi

    # Doğrulama dosyasını test et
    URL="http://$DOMAIN/$VALIDATION_FILE"
    RESPONSE=$(curl -s --max-time 5  --user-agent "Cenuta Checker" $URL)

    if [ "$RESPONSE" == "$VALIDATION_CONTENT" ]; then
        echo "$DOMAIN - $USER aktif (site bu sunucudan çalışıyor)" >> $AKTIF
    elif [ -z "$RESPONSE" ]; then
        echo "$DOMAIN - $USER pasif (dosya erişilemedi)" >> $PASIF
    else
        echo "$DOMAIN - $USER hatalı yanıt: $RESPONSE" >> $HATALI
    fi

    # Doğrulama dosyasını sil
    rm -f "$PUBLIC_HTML/$VALIDATION_FILE"
    echo "Doğrulama dosyası silindi: $PUBLIC_HTML/$VALIDATION_FILE"
done

echo "Kontrol tamamlandı. Sonuçlar:"
echo "Aktif Siteler: $AKTIF"
echo "Pasif Siteler: $PASIF"
echo "Hatalı Yanıtlar: $HATALI"
