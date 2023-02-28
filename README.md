# AntiComCaveLauncher
[German Only] Ein Programm für den ComCave Launcher der die Anwesenheitskontrolle löst.
Dieser Arbeitet mit OCR um den Text auszulesen und Imagesearch um die Eingabe auf das Tastenfeld zu ermöglichen.

Achtung. Programm ist nicht bug frei.

Funktionsweise des Programm:
1. Wartet auf das Fenster "Anwesenheitskontrolle"
2. Überprüft ob sich die Maus bewegt in 5 Sekunden um festzustellen ob ein Anwender aktiv den PC verwendet.
3. Setzt das Fenster in den Vordergrund.
4. Bewegt die Maus ungefähr auf den Pixel 0,0.
5. Macht ein Screenshot vom Fenster.
6. Bewegt die Maus zurück auf vohriger Position.
7. OCR ließt Text aus.
8. Sucht die Tasten anhand ImageSearch raus.
9. Bewegt und klickt die Tasten an.
10. Wiederholt bei schritt 1.

Exe ausführen und rechte maustaste auf das Symbol im Tray. Dort dann Start oder Exit wählen.

![Start Hilfe](https://i.ibb.co/Tr4tjJs/Screenshot-2.png)

Verwendete Libary:

OCR von DanysysTeam - https://github.com/DanysysTeam/UWPOCR

Imagesearch von Dao Van Trong - TRONG.LIVE - https://www.autoitscript.com/forum/files/file/471-image-search-udf/
