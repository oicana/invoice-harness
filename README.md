# invoice-harness

This plugin simplifies creating [factur-x/ZUGFeRD][factur-x] electronic invoices with [Typst].

```typst
#import "@preview/invoice-harness:0.1.0": *

#let factur-x = read("factur-x.xml")
#zugferd(factur-x)
```

To create a valid electronic invoice, be sure to export the PDF document as PDF/A-3b.

**This plugin currently only works with the main branch of Typst. The created files are not completely valid ZUGFeRD invoices yet! A missing requirement on Typst's end is [typst/typst#5667]**

## Development

The package includes automated tests using [`typst-test`][typst-test]. Run them with `typst-test run` after following
the package's installation instructions.

For file formatting, use [`typstyle`][typstyle].

You can install the package locally with [`typship install local`][typship].

## What's up with the package name?

The [ZUGFeRD][factur-x] standard is named close to the German word "Zugpferd", which means "draft horse". This package is the harness to attach a ZUGFeRD to your invoice ;)


[Typst]: https://typst.app/
[factur-x]: https://fnfe-mpe.org/factur-x/factur-x_en/
[typst/typst#5667]: https://github.com/typst/typst/issues/5667
[typst-test]: https://github.com/tingerrr/typst-test
[typstyle]: https://github.com/Enter-tainer/typstyle
[typship]: https://github.com/sjfhsjfh/typship
