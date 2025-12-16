---
title: "Alignment von RNA-Seq-Reads"
---

Dieses Dokument führt Sie Schritt für Schritt durch einen Beispiel-Workflow,
um mit RNA-Seq-Daten zu arbeiten.

Ich liste hier nur die Schritte auf; die Erklärung der Schritte erfolgt mündlich in der Vorlesung.

### Windows und MacOS

Windows-Nutzer können das "Windows Subsystem for Linux" (WSL) verwenden, dass es ermöglicht,
eine Minimal-Version von Ubuntu-Linux zu installieren, die sich (sehr im Gegensatz zum vollen
Ubuntu) nur über Kommandozeile bedienen lässt. Innerhalb dieser Linux-Installation können wir
die benötigte Software dann mit APT installieren.

Mac-Nutzer können hingegen Conda verwenden.

### WSL

Windows-Nutzer müssen erst das "Windows Subsystem for Linux" (WSL) installieren. 

Prüfen Sie zunächst, ob auf Ihrem Computer die Virtualisierungs-Funktion aktiv ist,
die es erlaubt, zwei Betriebssysteme gleichzeitig laufen zu lassen. Starten Sie dazu den Task Manager und klicken Sie auf "Performance" (das kleine Symbol links mit dem Graph). Im CPU-Panel können Sie dann ablesen, ob bei "Virtualisation" "enabled" steht.

Wenn nicht, dann müssen Sie die Virtualisierung im BIOS aktivieren. Google zeigt Ihnen, wie das geht.

Wenn die Virtualisierung zugelassen ist, können Sie WSL installieren: Suchen Sie dazu im Startmenü nach "WSL". Starten Sie WSL und lassen Sie es installieren. 
Möglicherweise müssen Sie danach Windows neu starten.

Starten Sie dann die Kommandozeile ("command prompt" oder "Eingabeaufforderung") und geben Sie ein:

```
wsl --install
```

Windows lädt dann eine Minimal-Version von Ubuntu Linux herunter und installiert es. 

Von nun an können Sie eine Linux-Kommandozeile erhalten, indem Sie in der Windows-Kommandozeile eingeben: `wsl`

Versuchen Sie, Software zu installieren:

```
sudo apt install sra-toolkit
```

### Conda

Laden Sie [hier](https://www.anaconda.com/download) den Miniconda-Installer herunter. 

*Für MacOS* ist es am einfachsten, den graphischen Installer zu verwenden. Danach starten die die Kommandozeile wie gewöhnlich, d.h., indem Sie die "Terminal"-App starten. Im Prompt sollte nun `(base)` erscheinen, um anzuzeigen, dass Conda mit seiner "Basis-Umgebung" aktiv ist.

Versuchen Sie nun, Software über Conda zu installieren.

Geben Sie ein:
```
conda install bioconda::sra-tools
```
um das SRA-Toolkit zu installieren, das u.a. den Befehl `fastq-dump` enthält.

*Anmerkung*: Das Conda-Paket mit dem SRA-Toolkit scheint derzeit defekt zu sein.
Für eine Behelfslösung, [siehe hier](srainstall.html).

### Reads herunterladen

Legen Sie ein Verzeichnis an (`mkdir` -- make directory), in dem Sie arbeiten
werden und wechseln Sie in das Verzeichnis (`cd` -- change directory):

```
mkdir fly
cd fly
```

Nun können Sie einige  FASTQ-Dateien herunter laden, z.B. aus dem Projekt mit Accession
[PRJNA207813](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA207813).

```
fastq-dump --split-3 -X 1000000 SRR891601
fastq-dump --split-3 -X 1000000 SRR891602
```

Hier bedeutete `--split-3`, dass die gepaarten Reads in zwei Dateien aufgespalten
werden sollen (was man stets so braucht), und `-X 10000000`, dass wir (um Zeit zu
sparen) nur die ersten 1,000,000 Read-Paare herunter laden möchten.

Die Metadaten zu den SRR-Nummern findet man (nach einigem Suchen), wenn man auf der
Projekt-Seit ganz unten auf "SRA Run Selector" klickt.

Sehen Sie sich den Inhalt der Dateien an, z.B. mit
```
less SRR891602_1.fastq
```

(Um "less" wieder zu verlassen, drücken Sie "q".)

### Genom herunter laden

Nun benötigen wir das Genom der Fliege. Gehen Sie zu ensembl.org, klicken Sie dort
auf "Downloads" (ganz oben), dann auf "FTP site" (linker unterer Kasten).

Auf dem FTP-Server wählen Sie nun das Verzeichnis `current_fasta`, dass die auf Ensembl
verfügbaren Genom-Sequenzen enthält. Wählen Sie dort `drosophila_melanogaster`, dann
`dna`, und laden Sie dann die Datei herunter, die auf `dna.toplevel.fa.gz` endet. Schieben
Sie diese Datei in das Verzeihnis, in dem Sie auch die Read-Dateien haben.

Entpacken Sie die Datei mit

```
gunzip Drosophila_melanogaster.BDGP6.54.dna.toplevel.fa.gz
```

### Genom-Index bauen

Nun installieren wir unseren Aligner, mit

```
sudo apt install hisat2
```

bzw.

```
conda install bioconda::hisat2
```

Rufen Sie mit `hisat2-build` die Hilfe-Seite zu `hisat2-build` auf.

Bauen Sie nun das Genom, mit

```
hisat2-build -p 2 Drosophila_melanogaster.BDGP6.54.dna.toplevel.fa Dmel
```

### Alignment

Nun können Sie mit 

```
hisat2 -x Dmel -1 SRR891601_1.fastq -2 SRR891601_2.fastq -S SRR891601.sam
```

die Reads von einer Probe gegen das Genom alinieren.

Sehen Sie sich mit
```
less -S SRR891601.sam
```
die Ausgabe an.

Erzeugen Sie SAM-Dateien von mindestens 2 Proben.

### Feature-Counting

Laden Sie vom Ensembl-FTP-Server die Datei mit den Gen-Annotationen für die Fliege
herunter. Sie finden Sie unter `current_gtf`. Wählen Sie die Version der Datei
ohne "chr" oder "abinitio" im Namen.

Installieren Sie dann das Subread-Paket, dass u.a. `featureCounts` enthält, 
mit `sudo apt install subread` bzw. `conda install bioconda::subread`.

Rufen Sie `featureCount` auf mit
```
featureCounts -p -a Drosophila_melanogaster.BDGP6.54.115.gtf.gz -o counts.tsv SRR891601.sam SRR891602.sam  
```

Sehen Sie sich die erzeugte Datei mit `less` an.

### Weiter in R

Lesen Sie die eben erzeugte Datei `counts.tsv` in R ein (mit `read_tsv`) und 
verwenden Sie Tidyverse, um ein Streudiagramm zu erzeugen, dass die Read-Zahlen
aus zwei Proben vergleicht. Finden Sie auch für eine der Proben heraus, welches
Gen die meisten Reads-Counts hat.
