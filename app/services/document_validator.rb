class DocumentValidator
	include Virtus.model
	include ActiveModel::Validations
	attribute :document_type, String
  	attribute :document_number, String

	validates_numericality_of :document_number, message: 'Ingrese un numero de documento valido.'
	validates_presence_of :document_type, message: "El tipo de documento no puede estar en blanco"
  	validates_inclusion_of :document_type, in: Afip::DOCUMENTOS.values, message: "Tipo de documento inválido"
	validates :document_number, length: { is: 11, message: 'Numero de documento inválido, verifique.' }, if: :cuit_cuil_cdi
	validates :document_number, length: { maximum: 11, message: 'Numero de documento inválido, verifique.' }, if: :le_lc_etc
	validates :document_number, length: { maximum: 8, message: 'Numero de documento inválido, verifique.' }, if: :tramite
	validates :document_number, length: { is: 8, message: 'Numero de documento inválido, verifique.' }, if: :dni

	def document_number=(val)
		super val.gsub(/\D/, '') unless val.nil?
	end

	def cuit_cuil_cdi
		["CUIT", "CUIL", "CDI"].include?(document_type)
	end

	def le_lc_etc
		['LE', 'LC', 'CI Extranjera', 'Acta Nacimiento', 'CI Bs. As. RNP', 'CI Salta', 'CI Policía Federal',
		'CI BsAs', 'CI Mendoza', 'CI La Rioja', 'CI San Juan', 'CI San Luis', 'CI Santa Fe', 'CI Santiago del Estero',
		'CI Tucumán', 'CI Chaco', 'CI Chubut', 'CI Formosa', 'CI Misiones', 'CI Neuquén','Pasaporte'].include?(document_type)
	end

	def tramite
		document_type == "en tramite"
	end

	def dni
		document_type == 'DNI'
	end
end
