# Presentation_Paragraph_14_a
Eine kurze Präsentation zu §14a EnWG - Steuerbare Verbraucher

Der einfachste Weg, die Präsentation zu ändern und zu bauen ist die Verwendung von devcontainer.
Dazu Visual Studio Code installieren und (unter Linux oder WSL) das Repository auschecken und in dessen Stammverzeichnis `code .` ausführen.

Visual Studio Code startet. Es erscheint rechts unten ein kleiner Dialog `Reopen in devcontainer`. Dies bestätigen.

Falls irgendwann Probleme mit dem Container auftauchen, dann `CTRL-SHIFT-P` tippen und `Rebuild Container without Cache` auswählen.

Um ein PDF zu generieren genügt es, eine Datei abzuspeichern. Der Build startet automatisch.

# Anpassungen des LaTeX devcontainers

## Probleme mit chktex

Das Dockerfile wurde angepasst, um die fehlerhafte Zeile der globalen `chktexrc` zu deaktivieren.