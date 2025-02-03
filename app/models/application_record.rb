class ApplicationRecord < ActiveRecord::Base
  class InsuficientStockError < StandardError; end
  self.abstract_class = true

  default_scope {where(
  	if self.model.column_names.include?("active")
		  {active: true }
		else
			"1=1"
		end
	)}

  def destroy(mode = :soft)
  	if mode == :soft && self.class.column_names.include?("active")
  		update_column(:active, false)
      run_callbacks(:destroy) { true }
  	else
  		super()
  	end
  end

  def is_number?
    to_f.to_s == to_s || to_i.to_s == to_s
  end

  def dig(*args)
    result = "self"
    args.each do |arg|
      result << ".try(:#{arg})"
    end
    eval result
  end
end
