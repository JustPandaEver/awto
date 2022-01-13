clear
echo "Pilih OS yang ingin anda install / choose your select OS"
echo
echo "  1) Windows 2019(Default)"
echo "  2) Windows 2012"
echo "  3) Pakai link gz mu sendiri / your own gz link os"
echo
echo "  login Acces RDP windows please copy / screenshot"
echo "  Windows 2019 Username : Adminstrator Password  Botol123456789!"
echo "  Windows 2012 Username : Adminstrator Password  Nixpoin.com123!"
read -p "Pilih / Select [1]: " PILIHOS
case "$PILIHOS" in
1|"") PILIHOS="http://files.nixpoin.com/windows2019DO.gz";;
2) PILIHOS="http://files.nixpoin.com/windows2012v2.gz";;
3) read -p "Masukkan Link GZ mu / Your gz URL  : " PILIHOS;;
*) echo "pilihan salah"; exit;;
esac
IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')
cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
netsh -c interface ip set address name="Ethernet 2" source=static address=$IP4 mask=255.255.240.0 gateway=$GW
netsh -c interface ip add dnsservers name="Ethernet 2" address=1.1.1.1 index=1 validate=no
netsh -c interface ip add dnsservers name="Ethernet 2" address=1.0.0.1 index=2 validate=no
EOF
wget -O- $PILIHOS | gunzip | dd of=/dev/vda bs=3M status=progress
mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat
echo 'Your server will reboot in 10 second'
echo 'Thx for Builds RDP on This Script'
clear
sleep 5
poweroff
