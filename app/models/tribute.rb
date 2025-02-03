class Tribute < ApplicationRecord
  belongs_to :bill

  DESCRIPTION =[
        "Impuestos nacionales",
        "Impuestos provinciales",
        "Impuestos municipales",
        "Impuestos Internos",
        "IIBB",
        "Percepción de IVA",
        "Percepción de IIBB",
        "Percepción de IIBB Salta",
        "Percepción de IIBB Jujuy",
        "Percepción de IIBB Catamarca",
        "Percepción de IIBB Tucuman",
        "Percepciones por Impuestos Municipales",
        "Otras Percepciones",
        "Percepción de IVA a no Categorizado",
				"Retención de IIBB",
				"Retención de Ganancias",
        "Percepcion CABA"
    ]

end
