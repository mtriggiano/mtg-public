class BuyIvaMovement

  def self.collection
    union = bills.union(expenses)
    ExternalBill.inheritance_column = :_type_disabled
    ActiveRecordUnion.new(
      ExternalBill
        .unscoped
        .from(external_bills.create_table_alias(union, :bills)
        .to_sql)
    )
  end

  def self.external_bills
    ExternalBill.arel_table
  end

  def self.expense_details
    ExpenseDetail.arel_table
  end

  def self.bills
    ExternalBill
      .unscoped
      .select(
          external_bills[:id],
          external_bills[:entity_id],
          external_bills[:active],
          external_bills[:cbte_tipo],
          external_bills[:sale_point],
          external_bills[:number],
          external_bills[:date],
          external_bills[:iva_amount],
          external_bills[:state],
          external_bills[:total],
          external_bills[:note],
          external_bills[:cbte_fch],
          external_bills[:gross_amount],
          external_bills[:total_pay],
          external_bills[:total_left],
          external_bills[:header_result],
          external_bills[:authorized_on],
          external_bills[:cae_due_date],
          external_bills[:cae],
          external_bills[:concept],
          external_bills[:imp_tot_conc],
          external_bills[:imp_op_ex],
          external_bills[:imp_trib],
          external_bills[:imp_neto],
          external_bills[:imp_iva],
          external_bills[:cbte_desde],
          external_bills[:cbte_hasta],
          external_bills[:iva_cond],
          external_bills[:parent_bill],
          external_bills[:fch_ser_desde],
          external_bills[:fech_ser_hasta],
          external_bills[:fch_vto_pago],
          external_bills[:observation],
          external_bills[:expired],
          external_bills[:company_id],
          external_bills[:user_id],
          external_bills[:created_at],
          external_bills[:updated_at],
          external_bills[:custom_attributes],
          external_bills[:surgery_file_id],
          external_bills[:reception_date],
          external_bills[:receptor_name],
          external_bills[:estimated_days_to_pay],
          external_bills[:type],
          external_bills[:file_id],
          external_bills[:flow],
          external_bills[:due_date],
          external_bills[:due_days],
          external_bills[:total_trib],
          external_bills[:registration_date],
          external_bills[:total_usd],
          external_bills[:usd_price],
          external_bills[:currency],
          external_bills[:manual],
          external_bills[:afip_error],
          external_bills[:payment_type_id],
          external_bills[:document_type],
          external_bills[:document_number],
          external_bills[:canceled],
          "NULL as percep_iibb",
          "NULL as percep_iva",
          "NULL as archived"
      )
      .where("bills.active = true AND flow = 'discharge' AND (state = 'Aprobado' OR state = 'Confirmado')")
  end

  def self.expenses
    ExpenseDetail
      .unscoped
      .select(
          expense_details[:id],
          expense_details[:entity_id],
          expense_details[:active],
          expense_details[:cbte_tipo],
          expense_details[:punto_venta].as("sale_point"),
          expense_details[:num_comprobante].as("number"),
          expense_details[:fecha].as("date"),
          expense_details[:sum_iva].as("iva_amount"),
          "'Confirmado' as state",
          expense_details[:total],
          "NULL as note",
          "to_char( expense_details.fecha, 'DD/MM/YY') as cbte_fch",
          expense_details[:total].as("gross_amount"),
          "0 as total_pay",
          "0 as total_left",
          "NULL as header_result",
          "NULL as authorized_on",
          "NULL as cae_due_date",
          "NULL as cae",
          "NULL as concept",
          "no_gravados as imp_tot_conc",
          "exento as imp_op_ex",
          "NULL as imp_trib",
          "NULL as imp_neto",
          "sum_iva as imp_iva",
          "NULL as cbte_desde",
          "NULL as cbte_hasta",
          "NULL as iva_cond",
          "NULL as parent_bill",
          "NULL as fch_ser_desde",
          "NULL as fech_ser_hasta",
          "NULL as fch_vto_pago",
          "NULL as observation",
          "NULL as expired",
          "NULL as company_id",
          "NULL as user_id",
          "NULL as created_at",
          "NULL as updated_at",
          "NULL as custom_attributes",
          "NULL as surgery_file_id",
          "NULL as reception_date",
          "NULL as receptor_name",
          "NULL as estimated_days_to_pay",
          expense_details[:type],
          "NULL as file_id",
          "NULL as flow",
          "NULL as due_date",
          "NULL as due_days",
          "NULL as total_trib",
          expense_details[:fecha_registro].as("registration_date"),
          "NULL as total_usd",
          "NULL as usd_price",
          "NULL as currency",
          "NULL as manual",
          "NULL as afip_error",
          "NULL as payment_type_id",
          "NULL as document_type",
          "NULL as document_number",
          "NULL as canceled",
          "percep_iibb as percep_iibb",
          "percep_iva as percep_iva",
          expense_details[:archived]
      )
      .where("expense_details.letra = 'A' AND expense_details.disabled_time is NULL AND expense_details.entity_id IS NOT NULL")
      .where("expense_details.archived = ?", false)
      .where(active: true)
  end
end
