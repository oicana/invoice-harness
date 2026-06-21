#import "../../../src/lib.typ": *

#let invoice-xml = read("factur-x.xml")
#factur-x(invoice-xml, profiles.en16931)
