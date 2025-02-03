class Purchases::Devolution < ExpedientDevolution
  belongs_to :file, class_name: 'Purchases::File', foreign_key: :file_id
  belongs_to :supplier, class_name: "Supplier", foreign_key: :entity_id
  has_many   :devolutions_external_arrivals, class_name: 'Purchases::DevolutionsArrival',dependent: :destroy, inverse_of: :devolution, foreign_key: :devolution_id
  has_many   :external_arrivals, class_name: "ExternalArrival", through: :devolutions_external_arrivals, source: :external_arrival
  # has_many   :batches,    through: :details
  # has_many   :unit_gtins, through: :batches

  has_many   :budgets, through: :file
  has_many   :orders, through: :file
  #has_many   :arrivals, through: :file
  has_many   :returns, through: :file
  has_many   :bills, through: :file
  has_many   :devolutions, through: :file
  has_many   :requests, through: :file

  accepts_nested_attributes_for :devolutions_external_arrivals, allow_destroy: true, reject_if: :all_blank

  inherit_details_from :external_arrival

  before_validation :at_least_one_arrival


  def at_least_one_arrival
    devolutions_external_arrivals.build if devolutions_external_arrivals.reject(&:marked_for_destruction?).size == 0
  end


  def has_pdf?
    true
  end

  def for_assign(documents, number)
    if documents
      ids = documents.map(&hash_accessor('id'))
      parent_class = self.class.name.deconstantize.blank? ? nil : "#{self.class.name.deconstantize.singularize.snakecase}_"
      #from = "#{parent_class}#{self.class.inherit_details_from.pluralize}"
      from = "#{self.class.reflect_on_association(self.class.inherit_details_from.pluralize.to_sym).class_name.snakecase.gsub("/", "_").pluralize}"
      documents = eval("company.#{from}").where(id: ids)
      assign(documents, number)
    end
  end
end
