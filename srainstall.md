### Work-around zur Installation des SRA-Toolkits auf dem Mac

*falls die Installation mit Conda nicht funktioniert*

- Laden Sie die Binaries des Pakets [hier](https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit) herunter.

- Entpacken Sie die tar.gz-Datei und suchen Sie darin (im Unterverzeichnis `bin`) die Datei `fastq-dump`. Sie werden mehrere
Versionen finden, die aber alle Verweise auf dieselbe Datei sind, `fastq-dump-orig.3.3.0`. Kopieren Sie diese in ein neues 
leeres Verzeichnis und benennen Sie sie um zu `fastq-dump`.

- Starten Sie ein Terminal, wechseln Sie mit `cd` in das eben erstellte Verzeichnis mit der `fastq-dump`-Datei

- Tippen Sie: `./fastq-dump`. Wenn dies funktioniert, können Sie nun fastq-dump verwenden (mit vorangestellten `./`, was
in der Kommandozeile bedeutet, dass die Datei mit dem gewünschtem Programm im aktuellen Verzeichnis ist)

- Eventuell weigert sich Ihr Mac, die Datei auszuführen, weil Sie sie vom Internet herunter geladen haben. In diesem Fall 
gehen Sie in Ihrer Systemsteuerung in den Bereich "Privatsphäre und Sicherheit" und suchen dort den Abschnitt zur Ausführung
von Apps. Dort sollte nun fastq-dump aufgeführt sein, mit einem Button daneben, um die Ausführung dieser Datei ausnahmsweise
zuzulassen. Klicken Sie den Button, und probieren Sie dann nochmals `./fastq-dump` im Terminal.