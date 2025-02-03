class ProvincesImporter < ApplicationService


  def get_provincias
    response = JSON.parse(%x(curl -X GET https://apis.datos.gob.ar/georef/api/provincias))
    provincias = response['provincias'].map{|p| p['nombre']}
    provincias.each do |provincia|
      current = Province.where(name: provincia, country_id: 1).first_or_create
      r = JSON.parse(%x(curl -X GET https://apis.datos.gob.ar/georef/api/departamentos?provincia=#{provincia}&max=100))
      departamentos = r["departamentos"].map{|d| d["nombre"]}
      departamentos.each do |departamento|
        current.localities.where(name: departamento).first_or_create
      end
    end
  end

  def get_provincias_afip
    provinces = Afip::CTG.new().consultar_provincias
    provinces_import = []
    provinces.each do |province|
      localities = Afip::CTG.new().consultar_localidades(province.first)
      province_import = Province.new(province_name: province.last.to_s, country_id: 1)
      localities.each do |locality|
        province_import.localities.build(locality_name: locality.last.to_s)
      end
      provinces_import << province_import
    end
    Province.import provinces_import, recursive: true
  end
end
