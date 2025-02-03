module StateManager
	extend ActiveSupport::Concern

	included do
		after_validation :rollback_state, if: :state_invalid?
		#validate :must_be_available
		scope :approveds, ->{where(state: ["Aprobado", "Confirmado"])}
		scope :confirmeds, -> {where(state: "Confirmado")}
		scope :canceled, ->{where(state: "Anulado")}
		#before_destroy :check_state
		def must_be_available
			errors.add(:base, "No puede modificar este documento") if disabled? && !state_changed?
		end

		STATES ||= ["Pendiente", "Rechazado", "Aprobado", "Anulado", "Finalizado", "Confirmado", "En revisión"]

		def destroy
		    errors.add(:base, "No se puede eliminar") unless pending?
		    super() unless errors.present?
		end

		def need_unmerge?
    		previous_changes[:state] == ["Finalizado", "Pendiente"] ||
    		previous_changes[:state] == ["Finalizado", "Anulado"]   ||
    		previous_changes[:state] == ["Confirmado", "Pendiente"] ||
    		previous_changes[:state] == ["Confirmado", "Anulado"]   ||
    		previous_changes[:state] == ["Aprobado", "Pendiente"]   ||
    		previous_changes[:state] == ["Aprobado", "Anulado"]
  		end

		def state_invalid?
			errors.any?
		end

		def rollback_state
			restore_state!
		end

		def pending?
		    state == "Pendiente"
		end

		def approved?
		    state == 'Aprobado' || state == 'Confirmado'
		end

		def finalized?
		    state == 'Finalizado'
		end

		def confirmed?
			state == 'Aprobado' || state == 'Confirmado'
		end

		def rejected?
			state == "Rechazado"
		end

		def rejected!
			update_columns(state: "Rechazado")
		end

		def editable?
		    pending?
		end

		def canceled?
			state == "Anulado"
		end

		def disabled?
		    !(editable? || new_record?)
		end

		def imprimible?
			confirmed? || finalized? || canceled?
		end

		def state_color
			case state
			when "Pendiente"
				'info'
			when "Rechazado"
				'warning'
			when "Anulado"
				'danger'
			when "Finalizado"
				'secondary'
			when "Aprobado"
				'sucess'
			when "Confirmado"
				'sucess'
			end
		end

		def available_states
			available = []
			can = current_user.can?(:reject, self.class) || current_user.can?(:approve, self.class) || current_user.can?(:manage, self.class)

			if pending?
				available.push({state: "Rechazado", action: "Rechazar", color: 'warning', can: can})
				available.push({state: "Aprobado", action: "Aprobar", color: 'success', can: can})
			end

			if approved?
				available.push({state: "Anulado", action: "Anular", color: 'danger', can: can})
			end

			return available
		end
	end
end
