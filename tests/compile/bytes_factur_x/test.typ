#import "../../../src/lib.typ": *

#let invoice-xml = read("factur-x.xml", encoding: none)
#zugferd(invoice-xml, profiles.en16931)
