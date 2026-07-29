# Word template for isodoc-ech

Place the file `ech.dotx` here.

## How to prepare `ech.dotx`

1. Open the original eCH template `XXXX_d_DRA_JJJJ-MM-TT_eCH-0XXX_Vx_x_x_Titel.docx`
   in Microsoft Word.
2. Strip all placeholder body content (keep only cover-page fields, headers, footers,
   and style definitions).
3. Save as **Word Template (.dotx)** → `ech.dotx`.
4. Copy `ech.dotx` into this directory.

The `WordConvert` class in `isodoc/ech/word_convert.rb` will use this as the
base template and inject the generated content, applying the correct paragraph
styles (Überschrift 1–5, Tabellentext, Aufzählung 1_CDB …) that are already
defined in the original eCH `.docx`.

## Style mapping

| AsciiDoc element          | Word style name              |
|---------------------------|------------------------------|
| Heading 1                 | berschrift1 (Überschrift 1)  |
| Heading 2                 | berschrift2                  |
| Heading 3–5               | berschrift3–5                |
| Annex heading             | Anhang-Überschrift           |
| Bullet list level 1       | Aufzählung 1_CDB             |
| Bullet list level 2       | Aufzählung 2_CDB             |
| Bullet list level 3       | Aufzählung 3_CDB             |
| Alpha list level 1        | Aufzählung a1_CDB            |
| Numbered list level 1     | Aufzählung Numm 1_CDB        |
| Table body text           | Tabellentext                 |
| Figure/table caption      | Abbildung/Tabelle Beschriftung |
| Exchange format box       | Austauschformat              |
| Note/placeholder          | Platzhalter                  |
