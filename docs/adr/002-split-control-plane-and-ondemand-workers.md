# ADR 002: Szétválasztott K3s Control Plane és On-Demand Worker Node-ok

## Kontextus
A labor környezet (homelab) optimális energiafelhasználása és költséghatékonysága érdekében nem indokolt 3 nagyteljesítményű fizikai szervert (HP 840 G6, Asus PC, Dell O7010) 0-24 órában futtatni. Ugyanakkor az infrastrukturális szolgáltatások (Rancher, Nginx Proxy, stb.) a `10.8.8.11` (t320s) hoston folyamatosan (24/7) üzemelnek.

## Döntés
1. **Control Plane (24/7):** A K3s Control Plane-t a folyamatosan futó `10.8.8.11` hostra telepítjük, **natív systemd szolgáltatásként** (nem Docker konténerben, elkerülve a CNI routing problémákat a fizikai workerek felé). A node `--disable-agent` (taint) beállítással települ, így nem futtat lab workloadokat és Longhorn tárolót.
2. **Worker & Storage (On-Demand):** A három fizikai célgép (`10.8.8.88`, `10.8.8.89`, `10.8.8.91`) kizárólag worker node-ként csatlakozik a klaszterhez. Ezek hordozzák az elosztott Longhorn storage-ot és futtatják az alkalmazásokat. Csak a labor (fejlesztés) idejére kapcsoljuk be őket.

## Következmények
* **Előnyök:** Drasztikus energiamegtakarítás. A klaszter agya (API szerver) folyamatosan él, így a menedzsment (Rancher) nem dob hibát a workerek leállásakor (csak a podok lesznek Pending/Unavailable állapotban).
* **Kockázat és Kezelése:** A Longhorn adatintegritása miatt a worker node-okat "hideg" (hard) áramtalanítás helyett mindig szabályos (graceful) shutdown folyamattal kell leállítani. Indításkor 1-2 percet várni kell a kötetek (replikák) szinkronizációjára.
