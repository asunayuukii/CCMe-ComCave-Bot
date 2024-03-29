# CCMe-ComCave-Bot v2.1
**[German Only]** 
# Comcave nutzt eine neue Zeiterfassung.
# Hier findet ihr die neue Lösung: https://github.com/asunayuukii/CCLogMeOut
CCMe ist ein Bot der für dich die Anwesenheitskontrolle löst.
Dies macht er indem er mit OCR das Fenster scannt und den Pin ausließt.
Danach sucht er via Imagesearch die für ihn relevanten Tasten und gibt den Pin mit MouseMove ein.

Sollte das durch Fehler mal nicht gehen, probiert der Bot das 2 weitere male aus. Wenn auch diese Versuche scheitern, startet der Bot den ComCave Launcher neu und loggt dich ein (Wie (Even)BetterComCave).

Somit ist der Bot 100% ausfallsicher.

![Log Fenster](https://i.ibb.co/crr3zw4/Screenshot-Log.png)
![Tray Einstellungen](https://i.ibb.co/CH3kd88/Screenshot-3.png)

**Seit Version 2.0 neu:**
- EvenBetterComCave implementiert.
- Voller Autostart. Nur CCMe starten und der Bot loggt dich automatisch im ComCave Launcher an.
- Notfallsicherung nach 3 gescheiterten versuchen. (EvenBetterComCave)
- Log Fenster, damit du siehst was der Bot gemacht hat und welche Zahlen er erkannt hatte.
- Config.ini jetzt hast du die Kontrolle. Konfiguriere die Toleranz oder nutze nur noch EvenBetterComCave (In der Config muss der Pfad zu dem Launcher stehen und auch deine Login Daten.) 
- Und weitere Einstellungen. Mehr Infos below

**Kann Ich auch nur EvenbetterCC / CCMe nutzen?**

Kurzgesagt: **Ja**. Du musst nur in der `Config.ini` die jeweilige Funktion, die du nicht verwenden möchtest, deaktivieren. Das geht wenn du den Wert, zum Beispiel, von `CCme`  auf `0` stellst.
Das Programm versucht dennoch bei wiederholten Fehlern die andere Methoden mit zu verwenden.

**Wie funktioniert die Ausfallsicherung?**

Sobald der Bot 3x einen Programmfehler zählt, zum beispiel es konnten nur 3 Zahlen von der PIN eingelesen werden, dann wird mit EvenBetterComCave versucht die Anwesenheitskontrolle zu umgehen. Dies macht der Bot nur wenn EvenBetterComCave, in der `Config.ini`, aktiviert ist.
Natürlich wird erst überprüft ob auch die Logindaten angegeben sind. Die Ausfallsicherung funktioniert auch in die andere Richtung, sprich wenn CCMe aus ist und EvenBetterComCave Fehler generiert wird die Methode CCMe erzwungen.

**Was ist CheckLog / CC_Log?**

Ihr kennt ja auch die Ausfälle des CCLaunchers. Mit Checklog überprüft CCMe die Log Datei vom ComCave Launcher alle 3 Minuten und liest die letzten 5 Zeilen aus. Wenn er nach 10 Minuten keine Zeile liest mit dem Inhalt "Ping erfolgreich" wird mit EvenbetterComCave der Launcher neugestartet. Um die Funktion zu verwenden muss der Pfad zur Log Datei in der Config.ini angegeben werden unter `[CCInfo] -> CC_Log=C:\Pfad\zum\Log\app.log`. Üblicherweise befindet sich die Log Datei unter `Laufwerk C -> Benutzer -> dein Benutzername -> CC_Launcher_Client -> .controlgui -> logs -> app.log`

Der Bot arbeitet komplett Offline. Wenn du mir nicht traust schau dir den Code an und kompelliere ihn selbst.

**Installation:**
Einfach entpacken, die `Config.ini` editieren und Exe ausführen.
Wenn du EvenBetterComCave verwenden möchtest musst du folgende Infos angeben.

![Config](https://i.ibb.co/k3YMfNm/Screenshot-2023-04-07-135211.png)

Die Config hat folgende Einstellungen:

| Name | Beschreibung |
|--|--|
|**Autostart**|Mit Autostart musst du beim öffnen des Programms nicht mehr selbstständig den Bot starten. Standardwert ist 0 (1 gleich an / 0 gleich aus)* |
| **LP_X / LP_Y** | Dies sind die Koordinaten für das Fenster Log. Sobald das Fenster geschlossen wird, werden die alten mit den neuen werten Überschrieben. Standardwert ist für beide Werte 0 (Oberste Linke Ecke deines Setups) |
|**Screenshot**|Wenn Screenshot aktiviert ist werden beim beenden des Bots nicht mehr die Bilder gelöscht. Standardwert ist 0 (1 gleich an / 0 gleich aus)*|
|**LogOpenOnStart**|Öffnet direkt das Log Fenster wenn der Bot startet. Sonst muss man rechte Maustaste auf das Tray Symbol klicken und dort dann "Log" auswählen. Standardwert ist 1 (1 gleich an / 0 gleich aus)*|
|**Toleranz**|Dieser Wert geht zwischen 0 und 255. Dieser beschreibt wie weit bei Imagesearch die Bilder unterschiedlich sein dürfen. 100 ist der Standardwert aber ihr dürft natürlich gerne mit diesem Wert spielen.|
|**CC_Pfad**|Der Speicher Ort für den ComCaveLauncher. Dieser Wert muss angegeben werden wenn du EvenBetterComCave Funktion nutzen möchtest. Standardwert ist 0.|
|**CC_Log**|Der Pfad zur CC Log Datei. Dieser Wert muss angegeben werden wenn du CheckLog Funktion nutzen möchtest. Standardwert ist 0.|
|**CC_Nutzername**|Dein Nutzername für den ComCaveLauncher. Dieser Wert muss angegeben werden wenn du EvenBetterComCave nutzen möchtest. Standardwert ist 0.|
|**CC_Passwort**|Dein Passwort für den ComCaveLauncher. Dieser Wert muss angegeben werden wenn du EvenBetterComCave nutzen möchtest. Standardwert ist 0.|
|**EvenBetterCCPort**|Muss 1 sein wenn du diese Funktion nutzen möchtest. Standardwert ist 1. (1 gleich an / 0 gleich aus)*|
|**CCme**|Wenn du die Funktion nutzen möchtest das der Pin via OCR und Imagesearch gelesen und eingegeben wird. Standardwert ist 1. (1 gleich an / 0 gleich aus)*|


Folgende Einstellung wirken zusammen:
- **Autostart** und **EvenBetterCCPort**: Wenn auch die anderen Werte ausgefüllt sind startet der Bot für dich den ComCave Launcher und meldet dich an.
- **CCMe** und **EvenBetterCCPort**: Mindestens 1 dieser Funktion muss an sein. Es sollten im besten Fall beide aktiviert sein für die Ausfallsicherung. Solltest du dich unwohl fühlen das du deine Daten in ein Programm eintragen musst so kannst du auch nur die CCme Methode verwenden. Solltest du beide deaktivieren, wird nur CCme verwendet.

*Andere Werte, wie zum Beispiel 2, werden ignoriert. Es wird der Standardwert benutzt.


**Bekannter Bug:**

Bei verschiedene Auflösungen findet Imagesearch nicht immer die Tasten. Arbeite derzeit an einer Lösung.
Bis dahin kannst du einen Screenshot von den Tastenfeld machen und die Tasten ausschneiden und in diesem Stil `1.png` speichern und im `img` Folder ersetzen. Wichtig, bitte nur PNG und keine anderen Formate. Und bitte ohne Kompremierung. Imagesearch sucht nach dem Exakten Bild. Wenn dies nicht existiert wird er keine Taste finden. Im Ordner `img` befinden sich verschiedene Varianten du kannst Sie gerne austauschen und ausprobieren.

Wenn du Fragen hast oder Vorschläge immer her damit. Versteht sich von selbst das Ich das Programm nur unter einen Alias veröffentlichen kann. Aus diesem Grund einfach per Github melden.

Weitere Funktionen sind erst einmal nicht geplant. Fehler werden korrigiert.

Das Original zu EvenBetterComCave findet ihr hier:
https://github.com/L-Pow/EvenBetterComcave
https://github.com/scysys/Better-Comcave

Verwendete Libary:

 - OCR von DanysysTeam - https://github.com/DanysysTeam/UWPOCR
 - Imagesearch von Dao Van Trong - TRONG.LIVE -
   https://www.autoitscript.com/forum/files/file/471-image-search-udf/

