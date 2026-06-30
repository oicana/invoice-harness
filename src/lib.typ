#let version = version(0, 1, 1)

#let pdf-keys = dictionary(pdf).keys()
#let supports-pdf-metadata = "metadata" in pdf-keys and "xmp" in pdf-keys

/// The Factur-X / ZUGFeRD conformance profiles.
#let profiles = (
  minimum: "MINIMUM",
  basic-wl: "BASIC WL",
  basic: "BASIC",
  en16931: "EN 16931",
  extended: "EXTENDED",
  xrechnung: "XRECHNUNG",
)

/// Method to make the current document an electronic invoice following the
/// Factur-X / ZUGFeRD standard.
///
/// Also available under the alias `zugferd`.
///
/// ```typst
/// #import "@preview/invoice-harness:0.1.1": *
///
/// #let invoice-xml = read("factur-x.xml")
/// #factur-x(invoice-xml, profiles.en16931)
/// ```
#let factur-x(
  /// The invoice XML to embed (the Factur-X / ZUGFeRD CII document).
  ///
  /// -> bytes | str
  xml,
  /// The conformance profile of the invoice. Use one of the values from
  /// `profiles`, e.g. `profiles.en16931`.
  ///
  /// -> str
  profile,
  /// The Factur-X version, written to the metadata as `fx:Version`.
  ///
  /// Default: "1.0"
  ///
  /// -> str
  fx-version: "1.0",
  /// Description of the file embedding
  ///
  /// Default: "ZUGFeRD Rechnung"
  ///
  /// -> str | none
  description: "ZUGFeRD Rechnung",
) = {
  assert(
    profile in profiles.values(),
    message: "Unknown Factur-X / ZUGFeRD profile: "
      + repr(profile)
      + ". Use one of the values from `profiles`, e.g. `profiles.en16931`.",
  )

  let data-only-profiles = (profiles.minimum, profiles.basic-wl)
  let relationship = if profile in data-only-profiles {
    "data"
  } else {
    "alternative"
  }

  // The XMP metadata relies on `pdf.metadata` / `pdf.xmp`, which currently only exist in
  // the temporary Typst fork (https://github.com/oicana/typst). On "normal"
  // Typst we skip it and embed the XML below without the metadata; the document
  // still compiles, but the PDF is not a fully conformant Factur-X invoice.
  if supports-pdf-metadata {
    let fx-schema = pdf
      .xmp
      .namespace(
        prefix: "fx",
        uri: "urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#",
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

    set pdf.metadata(properties: (
      fx-schema.document-type("INVOICE"),
      fx-schema.document-file-name("factur-x.xml"),
      fx-schema.version(fx-version),
      fx-schema.conformance-level(profile),
    ))
  }

  pdf.attach(
    "../factur-x.xml",
    bytes(xml),
    mime-type: "text/xml",
    relationship: relationship,
    description: description,
  )
}

/// Alias for `factur-x`, using the German name for the standard.
#let zugferd = factur-x
