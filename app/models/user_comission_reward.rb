class UserComissionReward < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :percentage, scope: :user_id, message: 'Ya se asignó este premio para el porcentaje indicado'

  PERCENTAGES = {
    "80% del objetivo" => "80%",
    "100% del objetivo" => "100%"
   }

   AMOUNT_PERCENTAGES = (0..100)

   def percentage_float
     if percentage == "80%"
       0.8
     else
       1
     end
   end

   def amount_percentage_float
     return reward_percentage / 100
   end
end
