module BillManager
  class AfipBill
    attr_accessor :bill, :company, :entity

    def initialize(bill, args={})
      @bill     = bill
      @company  = args[:company] || @bill.company
      @entity   = args[:entity] || @bill.client
    end

    def get_ptos_vta
    	Afip::Bill.get_ptos_vta
    end

    def available_cbte_tipos
      return [] if entity.nil?
      return Afip::CBTE_TIPO.select{|tipo| available_types.include?(tipo)}.map(&:reverse)
    end

    def available_types
      Afip::AVAILABLE_TYPES[company.iva_cond_sym][entity.iva_cond_sym]
    end

    def self.establece_constantes(company)
      if company.environment == "production" && Rails.env.production?
        #PRODUCCION
        Afip.pkey               = "#{Rails.root}/app/afip/privada.key"
        Afip.cert               = "#{Rails.root}/app/afip/production.crt"
        Afip.auth_url           = "https://wsaa.afip.gov.ar/ws/services/LoginCms"
        Afip.service_url        = "https://servicios1.afip.gov.ar/wsfev1/service.asmx?WSDL"
        Afip.cuit               = company.cuit || raise(Afip::NullOrInvalidAttribute.new, "Please set CUIT env variable.")
        Afip::AuthData.environment = :production
        Afip.environment        = :production
        #http://ayuda.egafutura.com/topic/5225-error-certificado-digital-computador-no-autorizado-para-acceder-al-servicio/
      else
        #TEST
        Afip.cuit = "20368642682"
        Afip.pkey = "#{Rails.root}/app/afip/magnus.key"
        Afip.cert = "#{Rails.root}/app/afip/magnus.crt"
        Afip.auth_url = "https://wsaahomo.afip.gov.ar/ws/services/LoginCms"
        Afip.service_url = "https://wswhomo.afip.gov.ar/wsfev1/service.asmx?WSDL"
        Afip::AuthData.environment = :test
        Afip.environment        = :test
      end
      Afip.default_concepto   = Afip::CONCEPTOS.key(company.concept)
      Afip.default_documento  = "CUIT"
      Afip.default_moneda     = :peso
      Afip.own_iva_cond       = company.iva_cond.parameterize.underscore.gsub(" ", "_").to_sym
    end

    def neto_aplica_descuentos(detail)
      detail.neto - detail.bonus_amount
    end

    def cbte_types
      Afip::CBTE_TIPO
        .map { |code, cbte_type| {text: cbte_type, id: code} if avilables_cbte_types.include?(code) }
        .compact
    end

    def avilables_cbte_types
      Afip::AVAILABLE_TYPES[company_iva_cond][entity_iva_cond]
    end

    def company_iva_cond
      @company.iva_cond_sym
    end

    def entity_iva_cond
      @entity.iva_cond_sym
    end
  end
end
