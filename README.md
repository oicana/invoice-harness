# invoice-harness

This plugin simplifies creating [factur-x/ZUGFeRD][factur-x] electronic invoices with [Typst].

```typst
#import "@preview/invoice-harness:0.1.1": *

#let invoice-xml = read("factur-x.xml")
#factur-x(invoice-xml, profiles.en16931)
```

To create a valid electronic invoice, be sure to export the PDF document as PDF/A-3b.

**This plugin is currently incompatible with the main branch of Typst (and any released versions). It depends on work-in-progress for [typst/typst#5667].**

## Development

For file formatting, use [`typstyle`][typstyle].

You can install the package locally with [`typship install local`][typship].

### E-invoice validation tests

`pdf.attach` / `pdf.xmp` / `pdf.metadata` only exist on the **custom-pdf-metadata**
branches of [typst][typst-repo] and [krilla] forks, so the
tests currently need a Typst built from those branches.

`tests/invoices/<profile>/` holds one sample invoice per conformance profile
(see [`tests/invoices/README.md`](tests/invoices/README.md)). The script compiles
each to a PDF/A-3b with the custom Typst and validates it with the
[Mustangproject][mustang] CLI.

## What's up with the package name?

The standard name "ZUGFeRD" echoes the German "Zugpferd" (draft horse). Every draft horse needs a harness, and here's yours, for strapping a ZUGFeRD to your invoice 🐎

## License

This package is licensed under the [MIT License](LICENSE).

The sample invoice XML files under `tests/invoices/` are not part of the
package and are not MIT-licensed. They are taken from the
[ZUGFeRD corpus](https://github.com/ZUGFeRD/corpus) (Apache-2.0) and remain under
their respective upstream licenses (see
[`tests/invoices/README.md`](tests/invoices/README.md)).


[Typst]: https://typst.app/
[typst-repo]: https://github.com/typst/typst
[krilla]: https://github.com/LaurenzV/krilla
[mustang]: https://www.mustangproject.org/
[factur-x]: https://fnfe-mpe.org/factur-x/factur-x_en/
[typst/typst#5667]: https://github.com/typst/typst/issues/5667
[typstyle]: https://github.com/Enter-tainer/typstyle
[typship]: https://github.com/sjfhsjfh/typship
