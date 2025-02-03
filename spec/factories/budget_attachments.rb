FactoryBot.define do
  factory :budget_attachment do
    attachment { "MyString" }
    original_filename { "MyString" }
    active { false }
    file_id { "" }
  end
end
