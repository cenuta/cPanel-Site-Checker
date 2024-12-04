#!/bin/bash

# Doğrulama dosyasının adı ve içeriği
VALIDATION_FILE=".well-known/cenuta-dogrulama.txt"
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
    WELL_KNOWN_DIR="$PUBLIC_HTML/.well-known"

    # .well-known dizini var mı, yoksa oluştur
    if [ ! -d "$WELL_KNOWN_DIR" ]; then
        mkdir -p "$WELL_KNOWN_DIR"
        echo ".well-known dizini oluşturuldu: $WELL_KNOWN_DIR"
    fi

    # Doğrulama dosyasını oluştur
    echo "$VALIDATION_CONTENT" > "$WELL_KNOWN_DIR/cenuta-dogrulama.txt"
    echo "Doğrulama dosyası oluşturuldu: $WELL_KNOWN_DIR/cenuta-dogrulama.txt"

    # Ana domainin yönlü olup olmadığını kontrol et
    URL="http://$DOMAIN/.well-known/cenuta-dogrulama.txt"
    RESPONSE=$(curl -sL --max-time 5 --user-agent "Cenuta Checker" $URL)

    # Ana domain kontrolü sonrası durum
    if [ "$RESPONSE" == "$VALIDATION_CONTENT" ]; then
        echo "$DOMAIN - $USER aktif (site bu sunucudan çalışıyor)" >> $AKTIF
    elif [ -z "$RESPONSE" ]; then
        echo "$DOMAIN - $USER pasif (dosya erişilemedi)" >> $PASIF
    else
        echo "$DOMAIN - $USER hatalı yanıt: $RESPONSE" >> $HATALI
        # Hatalı cevap alınan domain için IP uyumsuzluğu kontrolü
        DOMAIN_IPS=$(dig +short $DOMAIN)
        
        # Sunucuda bulunan tüm aktif IP adreslerini al
        SERVER_IPS=$(ip addr show | grep inet | grep -v inet6 | awk '{print $2}' | cut -d/ -f1)

        # IP uyumsuzluklarını toplayalım
        MISMATCHED_IPS=()

        for DOMAIN_IP in $DOMAIN_IPS; do
            for SERVER_IP in $SERVER_IPS; do
                if [ "$DOMAIN_IP" != "$SERVER_IP" ]; then
                    MISMATCHED_IPS+=("$DOMAIN_IP vs $SERVER_IP")
                fi
            done
        done

        if [ ${#MISMATCHED_IPS[@]} -gt 0 ]; then
            MISMATCHED_IPS_STR=$(IFS=, ; echo "${MISMATCHED_IPS[*]}")
            echo "$DOMAIN - $USER (Ana Domain) IP uyumsuzluğu: $MISMATCHED_IPS_STR" >> $PASIF
        else
            echo "$DOMAIN - $USER aktif (site bu sunucudan çalışıyor)" >> $AKTIF
        fi
    fi

    # Addon domainlerini kontrol et (sadece ana domain yönlü değilse)
    ADDON_DOMAINS=$(/usr/local/cpanel/bin/whmapi1 addon_domains user=$USER | grep -oP '(?<=domain: ).*')

    if [ ! -z "$ADDON_DOMAINS" ]; then
        for ADDON in $ADDON_DOMAINS; do
            echo "Addon Domain: $ADDON kontrol ediliyor..."

            URL="http://$ADDON/.well-known/cenuta-dogrulama.txt"
            RESPONSE=$(curl -sL --max-time 5 --user-agent "Cenuta Checker" $URL)

            # Addon domain kontrolü sonrası durum
            if [ "$RESPONSE" == "$VALIDATION_CONTENT" ]; then
                echo "$ADDON - $USER aktif (site bu sunucudan çalışıyor)" >> $AKTIF
            elif [ -z "$RESPONSE" ]; then
                echo "$ADDON - $USER pasif (dosya erişilemedi)" >> $PASIF
            else
                echo "$ADDON - $USER hatalı yanıt: $RESPONSE" >> $HATALI
                # Hatalı cevap alınan addon domain için IP uyumsuzluğu kontrolü
                ADDON_IPS=$(dig +short $ADDON)
                
                # Sunucuda bulunan tüm aktif IP adreslerini al
                IP_MISMATCH=false
                for ADDON_IP in $ADDON_IPS; do
                    for SERVER_IP in $SERVER_IPS; do
                        if [ "$ADDON_IP" != "$SERVER_IP" ]; then
                            MISMATCHED_IPS+=("$ADDON_IP vs $SERVER_IP")
                            IP_MISMATCH=true
                        fi
                    done
                done

                if [ "$IP_MISMATCH" = true ]; then
                    MISMATCHED_IPS_STR=$(IFS=, ; echo "${MISMATCHED_IPS[*]}")
                    echo "$ADDON - $USER (Addon Domain) IP uyumsuzluğu: $MISMATCHED_IPS_STR" >> $PASIF
                fi
            fi
        done
    fi

    # Doğrulama dosyasını sil
    rm -f "$WELL_KNOWN_DIR/cenuta-dogrulama.txt"
    echo "Doğrulama dosyası silindi: $WELL_KNOWN_DIR/cenuta-dogrulama.txt"
done

echo "Kontrol tamamlandı. Sonuçlar:"
echo "Aktif Siteler: $AKTIF"
echo "Pasif Siteler: $PASIF"
echo "Hatalı Yanıtlar: $HATALI"
