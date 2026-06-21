#import "/src/lib.typ": *

#set document(title: "invoice-harness sample (en16931 profile)")

= Sample invoice

Profile: `en16931`. This document is a fixture for automated Factur-X /
ZUGFeRD validation; the embedded XML is an official sample from the ZUGFeRD
corpus (see tests/invoices/README.md).

#factur-x(read("factur-x.xml"), profiles.en16931)
