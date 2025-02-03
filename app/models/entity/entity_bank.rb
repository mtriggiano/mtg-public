class EntityBank < ApplicationRecord
  	belongs_to :entity
  	include Virtus.model(mass_assignment: false, constructor: false)
  	attribute :current_user, User

  	TYPES = ["CUENTA CORRIENTE EN PESOS", "CAJA DE HORRO EN PESOS", "CUENTA CORRIENTE EN DOLARES", "CAJA DE HORRO EN DOLARES"]

  	validates :name, length: {minimum: 3, maximum: 200, message: "El nombre debe contener entre 3 y 200 caracteres"}, presence: {message: "Debe ingresar"}
  	validates :cbu, length: {is: 22, message: "Debe contener 22 caracteres"}, presence: {message: "Debe ingresar"}
  	validates :alias, length: {minimum: 3, maximum: 200, message: "El alias debe contener entre 3 y 200 caracteres", allow_blank: true}
  	validates :cuit, length: {is: 11, message: "Debe contener 11 caracteres", allow_blank: true}
  	validates :account_type, presence: {message: "Debe ingresar"}, inclusion: {in: TYPES, message: "Tipo inválido"}
  	validates :branch_office, length: {minimum: 3, maximum: 200, message: "El nombre debe contener entre 3 y 200 caracteres", allow_blank: true}
  	validates :denomination, length: {minimum: 3, maximum: 200, message: "El nombre debe contener entre 3 y 200 caracteres", allow_blank: true}
end
