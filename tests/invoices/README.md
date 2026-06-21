# Sample invoices for validation tests

Each subdirectory is one conformance profile supported by `factur-x` /
`zugferd` (see `src/lib.typ` `profiles`). A directory contains:

- `factur-x.xml` — a valid Cross Industry Invoice (CII) for that profile.
- `invoice.typ` — renders a placeholder visual invoice and embeds the XML via
  `factur-x(read("factur-x.xml"), profiles.<profile>)`.

`scripts/validate-invoices.sh` compiles each `invoice.typ` to a PDF/A-3b and
validates the result with the Mustangproject CLI (PDF/A
conformance via veraPDF + CII schema + EN 16931 Schematron).

## Provenance of the XML samples

The `factur-x.xml` files are sample invoices from the [ZUGFeRD corpus](https://github.com/ZUGFeRD/corpus), chosen so they validate against the
current Mustangproject release:

| Profile     | Source PDF / file (extracted with `Mustang --action extract`)                              |
|-------------|-------------------------------------------------------------------------------------------|
| `minimum`   | `ZUGFeRDv2/correct/FNFE-factur-x-examples/Facture_FR_MINIMUM.pdf`                          |
| `basic-wl`  | `ZUGFeRDv2/correct/symtrax/Beispiele/BASIC WL/zugferd_2p1_BASIC-WL_Einfach.pdf`            |
| `basic`     | `ZUGFeRDv2/correct/symtrax/Beispiele/BASIC/zugferd_2p1_BASIC_Einfach.pdf`                  |
| `en16931`   | `ZUGFeRDv2/correct/symtrax/Beispiele/EN16931/zugferd_2p1_EN16931_Einfach.pdf`              |
| `extended`  | `ZUGFeRDv2/correct/symtrax/Beispiele/EXTENDED/zugferd_2p1_EXTENDED_Warenrechnung.pdf`      |
| `xrechnung` | `XML-Rechnung/CII/XRECHNUNG_Einfach.cii.xml`                  |

To refresh a sample, download the source from the corpus and, for PDFs, extract
the embedded XML:

```sh
java -jar tools/Mustang-CLI.jar --action extract --source <file>.pdf --out factur-x.xml
```

## Licensing

These `factur-x.xml` samples are not covered by this project's MIT license.
They are taken from the [ZUGFeRD corpus](https://github.com/ZUGFeRD/corpus)
(Apache-2.0), which aggregates samples from third parties — the `minimum` sample
originates from the [FNFE-MPE Factur-X examples](https://fnfe-mpe.org/factur-x/),
and others are derived from AWV's ZUGFeRD Infopaket.
