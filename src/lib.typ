#let version = version(0, 1, 1)

/// The ZUGFeRD / factur-x conformance profiles.
#let profiles = (
  minimum: "MINIMUM",
  basic-wl: "BASIC WL",
  basic: "BASIC",
  en16931: "EN 16931",
  extended: "EXTENDED",
  xrechnung: "XRECHNUNG",
)

/// Method to make the current document an electronic invoice following the ZUGFeRD standard
///
/// ```typst
/// #import "@preview/invoice-harness:0.1.1": *
///
/// #let factur-x = read("factur-x.xml")
/// #zugferd(factur-x, profiles.en16931)
/// ```
#let zugferd(
  /// The ZUGFeRD xml
  ///
  /// -> bytes | str
  factur-x,
  /// The conformance profile of the invoice. Use one of the values from
  /// `profiles`, e.g. `profiles.en16931`.
  ///
  /// -> str
  profile,
  /// The factur-x version, written to the metadata as `fx:Version`.
  ///
  /// Default: "1.0"
  ///
  /// -> str
  version: "1.0",
  /// Description of the file embedding
  ///
  /// Default: "ZUGFeRD Rechnung"
  ///
  /// -> str | none
  description: "ZUGFeRD Rechnung",
) = {
  assert(
    profile in profiles.values(),
    message: "Unknown ZUGFeRD profile: "
      + repr(profile)
      + ". Use one of the values from `profiles`, e.g. `profiles.en16931`.",
  )

  let factur-x = (
    pdf
      .xmp
      .namespace(
        prefix: "fx",
        url: "urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#",
        name: "Factur-X PDFA Extension Schema",
      )
      .schema(
        DocumentType: (type: str, description: "Type of the embedded XML"),
        DocumentFileName: (
          type: str,
          description: "File name of the embedded XML",
        ),
        Version: (type: str, description: "Version of the Factur-X profile"),
        ConformanceLevel: (
          type: str,
          description: "Conformance level of the invoice",
        ),
      )
  )

  set pdf.metadata(properties: (
    factur-x.document-type("INVOICE"),
    factur-x.document-file-name("factur-x.xml"),
    factur-x.version(version),
    factur-x.conformance-level(profile),
  ))

  pdf.embed(
    "../factur-x.xml",
    factur-x,
    mime-type: "text/xml",
    relationship: "alternative",
    description: description,
  )
}
