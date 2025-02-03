# Prepara para ser implementada por modelos que tengan details.
module TrazabilidadValidator::QuieroReabrir
    extend ActiveSupport::Concern
    
    def quiero_reabrir?
      changes[:state] == ["Finalizado", "Pendiente"] || changes[:state] == ["Confirmado", "Pendiente"]
    end
  end
  