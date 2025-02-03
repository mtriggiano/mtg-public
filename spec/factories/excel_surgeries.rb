FactoryBot.define do
  factory :excel_surgery do
    paciente { "MyString" }
    material { "MyString" }
    fecha { "2021-08-10" }
    lugar { "MyString" }
    transporte { "MyString" }
    quirofano { "MyString" }
    horario { "MyString" }
    buscar_quirofano { "MyString" }
    estado { "MyString" }
    tipo_cx { "MyString" }
    vendedor { "MyString" }
    tecnico { "MyString" }
    medico { "MyString" }
    obs { "MyText" }
  end
end
