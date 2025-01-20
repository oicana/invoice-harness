#let version = version(0, 1, 0)

/// Method to make the current document an electronic invoice followign the ZUGFeRD standard
///
/// ```typst
/// #import "@preview/invoice-harness:0.1.0": *
///
/// #let factur-x = read("factur-x.xml")
/// #zugferd(factur-x)
/// ```
#let zugferd(
  /// The ZUGFeRD xml
  ///
  /// -> bytes | str
  factur-x,
) = {
  pdf.embed("../factur-x.xml", factur-x, mime-type: "text/xml", relationship: "data")
  // Todo: ZUGFeRD metadata after typst/typst#5667
}
