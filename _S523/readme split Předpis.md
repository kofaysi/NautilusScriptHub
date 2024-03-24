### Manuál pro roční úkony se soubory

 Po obdržení souboru "Předpisy" nebo "Vyúčtování", který obsahuje zálohové listy pro všechny jednotky, prověď následujícíc úkony za účelem rozdělení tohoto souboru na zálohové listy pro jednotlivé jednotly a jejich přeřazení do příslušných adresářů.

1. **Uložení souboru:**
   - Vlož soubor do adresáře "5230000 04FDAC6"/`<rok>`/.
   - Také vlož soubor do nově vytvořeného adresáře /split/.

2. **Přejmenování souboru:**
   - Přejmenuj soubor na formát: `<datum vzniku> S523 Přepis <rok> <datum platnosti od>`.

3. **Extrakce variabilních symbolů:**
   - pro extrakci sloupce variabiních symbolů použij skript: `/home/milan/.local/share/nautilus/scripts/_convert/PDF extract _symboly.sh`.

4. **Rozdělení souboru na listy:**
   - Rozděl soubor na jednotlivé listy pomocí skriptu: `/home/milan/.local/share/nautilus/scripts/s_plit and merge/split PDFs into pages.sh`.

5. **Nastavení náhledu ve správci souborů Nautilus:**
   - Ve správci souborů nastav náhled na stránky (thumbnails).

6. **Spojování souvisejících souborů:**
   - Identifikuj a spoj související soubory pomocí skriptu: `/home/milan/.local/share/nautilus/scripts/s_plit and merge/merge PDFs and delete originals.sh`.
   - Tyto jednotlivé listy patřící jednomu zálohovému listu jsou v pořadí za sebou a v náhledu se lehce identifikují.

7. **Přejmenování zálohových listů:**
   - Zkopíruj sloupec variabilních symbolů do clipboardu.
   - Přejmenuj zálohové listy pomocí skriptu: `/home/milan/.local/share/nautilus/scripts/re_name/based on clipboard.sh`.
   - Alternativně, vytvoř soubor `names.txt` se sloupcem variabilních symbolů a přejmenuj soubory pomocí skriptu: `/home/milan/.local/share/nautilus/scripts/re_name/based on _names.txt.sh`.
   - Použij funkci Rename v Nautilu pro doplnění předpony a koncovky.
   - Nový název souborů: `<datum vzniku> S523 Přepis <rok> <variabilní symbol>`.

8. **Přesun souborů:**
   - Přenes všechny dílčí soubory, tedy zálohové listy, do kořenového adresáře jednotky, vedle "523#### hashhas".
   - Označ všechny soubory a přejmenuj je pomocí skriptu: `/home/milan/.local/share/nautilus/scripts/re_name/based on filename w 7d symbol and year.sh`.
   - Soubory budou automaticky přesunuty do jednotlivých adresářů jednotek a do podadresáře dle roku.

9. **Úklid:**
   - Smaž adresář /split.
