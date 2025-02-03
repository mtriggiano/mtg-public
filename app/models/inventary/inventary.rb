class Inventary < ApplicationRecord
  self.table_name = :products
  self.abstract_class = true
  include Virtus.model(constructor: false, mass_assignment: false)
  has_many :shipment_details, class_name: "ExpedientShipmentDetail", foreign_key: :product_id
  has_many :arrival_details, class_name: "ExpedientArrivalDetail", foreign_key: :product_id

  MEASUREMENT_UNITS = {
    '1' => 'kilogramos',
    '2' => 'metros',
    '3' => 'metros cuadrados',
    '4' => 'metros cúbicos',
    '5' => 'litros',
    '6' => '1000 kWh',
    '7' => 'unidad',
    '8' => 'pares',
    '9' => 'docenas',
    '10' => 'quilates',
    '11' => 'millares',
    '14' => 'gramos',
    '15' => 'milimetros',
    '16' => 'mm cúbicos',
    '17' => 'kilómetros',
    '18' => 'hectolitros',
    '20' => 'centímetros',
    '25' => 'jgo. pqt. mazo naipes',
    '27' => 'cm cúbicos',
    '29' => 'toneladas',
    '30' => 'dam cúbicos',
    '31' => 'hm cúbicos',
    '32' => 'km cúbicos',
    '33' => 'microgramos',
    '34' => 'nanogramos',
    '35' => 'picogramos',
    '41' => 'miligramos',
    '47' => 'mililitros',
    '48' => 'curie',
    '49' => 'milicurie',
    '50' => 'microcurie',
    '51' => 'uiacthor',
    '52' => 'muiacthor',
    '53' => 'kg base',
    '54' => 'gruesa',
    '61' => 'kg bruto',
    '62' => 'uiactant',
    '63' => 'muiactant',
    '64' => 'uiactig',
    '65' => 'muiactig',
    '66' => 'kg activo',
    '67' => 'gramo activo',
    '68' => 'gramo base',
    '96' => 'packs',
    '98' => 'otras unidades'
  }.freeze

  TYPES = ["child", "regular", "box"]

  belongs_to :company
  belongs_to :product_category, optional: true
	has_many   :purchase_price_histories, foreign_key: :product_id
	has_many   :sale_price_histories, foreign_key: :product_id
  #has_many   :stocks, foreign_key: :product_id
  has_many   :arrival_details, class_name: "ExpedientArrivalDetail", foreign_key: :product_id #ingreso de stock

  has_many   :images, class_name: "ProductImage", foreign_key: :product_id, inverse_of: :inventary

  after_initialize :build_default_image
  attribute  :current_user, User

  before_save :set_code
  after_save :update_category_counter
  #after_touch :set_available_stock

  def self.search(search, excluded = nil, own)
    own ||= true
    if search && !excluded.nil?
      where(own: own).where('products.name ILIKE ? OR products.code ILIKE ?', "%#{search}%", "%#{search}%").where.not(id: excluded)
    elsif search && excluded.nil?
      where(own: own).where('products.name ILIKE ? OR products.code ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(own: own)
    end
  end

  def update_category_counter
    product_category.update(products_count: product_category.inventaries.size)
  end

  def company
    product_category&.company
  end

  def self.get_or_create(name, company)
    prod = company.inventaries.where(name: name).first_or_initialize
    if prod.new_record?
      category = company.product_categories.where(name: "Generada por el sistema").first_or_create
      prod.product_category_id = category.id
      prod.type = "Product"
      prod.save
    end
    return prod
  end

  def iva_aliquot_number
    Afip::ALIC_IVA.map { |code, text| text if code == iva_aliquot }.compact.first
  end

  def build_default_image
    images.build unless images
  end

  def default_image
    read_attribute('default_image') || '/images/default_product.png'
  end

  def is_a_child?
    box_products.blank?
  end

  def is_a_box?
    self.type == "Box"
  end

  def is_a_product?
    self.type == "Product"
  end

  def set_code
    if code.blank?
      begin
        self.code = SecureRandom.hex(3).upcase
      end while !company.inventaries.select(:code).where(code: code).empty?
    end
  end

  def medida
    MEASUREMENT_UNITS[measurement_unit]
  end

  # def set_available_stock
  #   update_column(:available_stock, available_batches.size)
  # end

  def supplier_code(supplier_id = nil)
    if supplier_id
      supplier_products.find_by(supplier_id: supplier_id).try(:code)
    else
      ''
    end
  end

  def full_name
    "#{name} - #{code}"
  end

end
