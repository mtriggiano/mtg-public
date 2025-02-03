class ExpedientBillTribute < ApplicationRecord
	self.table_name = :tributes

	belongs_to :bill, class_name: "ExpedientBill", inverse_of: :tributes

	TRIBUTOS = {
        "1" => "Impuestos nacionales",
        "2" => "Impuestos provinciales",
        "3" => "Impuestos municipales",
        "4" => "Impuestos Internos",
        "5" => "IIBB",
        "6" => "Percepción de IVA",
        "7" => "Percepción de IIBB",
        "8" => "Percepciones por Impuestos Municipales",
        "9" => "Otras Percepciones",
        "13" => "Percepción de IVA a no Categorizado",
				"97" => "Retención de IIBB",
				"98" => "Retención de Ganancias",
				"99" => "Otros",
    }

	## LOS ID 97,98,99 se corrigen automaticamente a 99 en el metodo set_afip_id

	validates_presence_of :afip_id, message: "Debe especificar un tributo."
	validates_inclusion_of :afip_id, in: TRIBUTOS, message: "Tributo inválido"
	validates_presence_of :alic, message: "Debe especificar"
	validates_numericality_of :alic, message: "Debe ser un número"
	validates_presence_of :base_imp, message: "Debe especificar"
	validates_numericality_of :base_imp, message: "Debe ser un número"
	validates_presence_of :amount
	validates_numericality_of :amount

	before_validation :set_afip_id

	def set_afip_id
		equivalent = TRIBUTOS.rassoc(description)
		if equivalent.nil?
			self.afip_id = 99
		else
			self.afip_id = equivalent.first
		end
	end

  def desc
      TRIBUTOS[afip_id]
  end



end
