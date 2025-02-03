module HumanResources::AttendancesHelper

  def turn_days_toggle builder, text, sym
    builder.input sym,
			label: "#{text}",
			input_html: {
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: 'danger',
					on: "Si",
					off: "No"
				}
			},
			wrapper_html: {
				class: 'flex-grow-1',
				style: 'margin-left: -1.25rem; padding-right: 1.25rem;'
			}
  end

  def approve_toggle builder, sym
    builder.input sym,
			label: "Aprobar?",
			input_html: {
        onchange: 'toggleRejectReason()',
        class: 'approve_toggle',
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: 'danger',
					on: "Si",
					off: "No"
				}
			},
			wrapper_html: {
				class: 'flex-grow-1',
				style: 'margin-left: -1.25rem; padding-right: 1.25rem;'
			}
  end

  def yes_no_toggle builder, sym, label
    builder.input sym,
			label: "#{label}",
			input_html: {
        onchange: 'toggleRejectReason()',
        class: 'approve_toggle',
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: 'danger',
					on: "Si",
					off: "No"
				}
			},
			wrapper_html: {
				class: 'flex-grow-1',
				style: 'margin-left: -1.25rem; padding-right: 1.25rem;'
			}
  end

end
