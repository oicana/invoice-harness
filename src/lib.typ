#let version = version(0, 1, 1)

/// Method to make the current document an electronic invoice following the ZUGFeRD standard
///
/// ```typst
/// #import "@preview/invoice-harness:0.1.1": *
///
/// #let factur-x = read("factur-x.xml")
/// #zugferd(factur-x)
/// ```
#let zugferd(
  /// The ZUGFeRD xml
  ///
  /// -> bytes | str
  factur-x,
  /// Description of the file embedding
  ///
  /// Default: "ZUGFeRD Rechnung"
  ///
  /// -> str | none
  description: "ZUGFeRD Rechnung",
) = {
  pdf.embed(
    "../factur-x.xml",
    factur-x,
    mime-type: "text/xml",
    relationship: "alternative",
    description: description,
  )
}
