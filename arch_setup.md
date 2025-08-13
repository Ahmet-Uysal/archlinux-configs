Harika! O zaman sana **Archinstall ile sıfırdan başlayan, Hyprland + Intel/Nvidia hibrit laptop için tam kurulum rehberi** hazırlayacağım.
README.md formatında olacak, direkt GitHub repona koyabilirsin.

---

# Arch Linux + Hyprland + Intel/Nvidia Hibrit GPU – Tam Kurulum Rehberi

## 1️⃣ Başlangıç: Archinstall ile Kurulum

Archinstall ile kuruluma başlarken şu adımları takip et:

### 1.1. Disk ve Bölümlendirme

* `archinstall` çalıştır:

```bash
archinstall
```

* **Guided** veya **Manual** partitioning seçebilirsin.
* EFI varsa `ESP` ve root (`/`) oluştur. Swap gerekirse ekle.

### 1.2. Sistem Seçimi

* **Profile**: `desktop` (Wayland destekli)
* **CPU Microcode**: `intel-ucode` seç.
* **Graphics driver**:

  * Eğer hibrit (Intel + Nvidia) → `NVIDIA (proprietary)`
  * Masaüstü Nvidia tek GPU ise → `NVIDIA (proprietary)` yeterli

> Bu adım Archinstall’ın temel paketleri yüklemesini sağlar: `nvidia`, `nvidia-utils`, `nvidia-prime`, `mesa`, `intel-media-driver`.

### 1.3. Bootloader

* `systemd-boot` veya `grub` önerilir.
* EFI kurulumlu sistemlerde `systemd-boot` hızlı ve stabil.

### 1.4. Kullanıcı ve Parola

* Root parolasını belirle
* Yeni kullanıcı oluştur ve sudo yetkisi ver

---

## 2️⃣ Kurulum Sonrası Paket Kontrolü

Kurulumdan sonra TTY’ye geçip eksik paketleri yükle:

```bash
sudo pacman -Syu \
nvidia-dkms nvidia-utils nvidia-prime \
mesa libva-intel-driver intel-media-driver \
vulkan-icd-loader vulkan-tools \
acpi_call tlp brightnessctl networkmanager pulseaudio pavucontrol
```

> `nvidia-dkms` kernel güncellemelerinde stabil kalır.
> `tlp` pil optimizasyonu için, `brightnessctl` ekran parlaklığı için.

---

## 3️⃣ Hyprland Kurulumu

1. Hyprland yükle:

```bash
sudo pacman -S hyprland waybar swaylock swayidle foot kitty
```

2. Config dosyası oluştur:

```bash
mkdir -p ~/.config/hypr
cp /etc/hypr/hyprland.conf ~/.config/hypr/
```

3. Nvidia Wayland uyumu için `hyprland.conf` içine ekle:

```ini
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_RENDERER,vulkan
```

---

## 4️⃣ PRIME Offload Kullanımı

Intel GPU varsayılan, Nvidia gerekli uygulamalarda çalışır:

```bash
prime-run glxinfo | grep "OpenGL renderer"
prime-run steam
prime-run blender
```

Test:

```bash
glxinfo | grep "OpenGL renderer"      # Intel
prime-run glxinfo | grep "OpenGL renderer"  # Nvidia
```

---

## 5️⃣ Hibrit GPU Opsiyonları (İsteğe Bağlı)

* **Sürekli Nvidia için**:

```bash
yay -S supergfxctl
sudo systemctl enable --now supergfxd
supergfxctl --set Hybrid   # Intel + Nvidia
supergfxctl --set Integrated   # Sadece Intel
```

* **Optimus Manager (X11)** kullanılabilir ama Wayland için supergfxctl daha stabil.

---

## 6️⃣ Monitör ve Çözünürlük

Mevcut monitörleri listele:

```bash
hyprctl monitors
```

Örnek config:

```ini
monitor=HDMI-A-1,1920x1080@60,0x0,1
```

---

## 7️⃣ Sistem Güncelleme ve Kernel Uyumu

Her kernel güncellemesinden sonra:

```bash
sudo pacman -Syu
```

`nvidia-dkms` kullanıyorsan:

```bash
sudo pacman -S linux-headers
sudo mkinitcpio -P
```

> Böylece modül uyumu korunur.

---

## 8️⃣ Güç Tüketimi ve Pil Optimizasyonu

```bash
sudo systemctl enable --now tlp
```

* Nvidia GPU kapatma: `bbswitch`
* Parlaklık: `brightnessctl`
* Ses: `pavucontrol`
* Ağ: `networkmanager`

---

## 9️⃣ Sorun Giderme

* Siyah ekran → TTY ile giriş → `mkinitcpio -P`, reboot
* Çözünürlük yanlış → `hyprctl monitors` ile config güncelle

---

## 🔗 Kaynaklar

* [Arch Wiki - NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
* [Arch Wiki - PRIME](https://wiki.archlinux.org/title/PRIME)
* [Hyprland Wiki](https://wiki.hyprland.org/)

---

Bu rehber **archinstall adımlarını da kapsıyor**, dolayısıyla tamamen sıfırdan kurulumu anlatıyor.

İstersen ben bunu sana **doğrudan GitHub için README.md hazır Markdown dosyası** olarak da oluşturabilirim, böylece tek seferde reponun içine atıp kullanırsın. Bunu yapayım mı?
