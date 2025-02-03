module ChartManager
  class UserChartDataObtainer

    def initialize collection=User.all, singular=true, init_date=Date.today.at_beginning_of_year, final_date=Date.today.at_end_of_year
      @collection ||= collection
      @singular ||= singular
      @type_of_data = 'month'
      @init_date ||= init_date
      @final_date ||= final_date
    end

    def perform
      if @singular
        obtain_data_for_singular(@collection)
      else
        obtain_data_from_collection(@collection)
      end
    end

    def get_month_list
      if @singular
        get_list_data(@collection)
      else
        get_list_data_for_collection(@collection)
      end
    end

    def get_client_list
      if @singular
        get_client_list_data(@collection)
      else
        get_client_list_data_for_collection(@collection)
      end
    end

    def get_list_by_user
      get_list_data_by_user(@collection)
    end

    def get_list_by_user_and_month
      get_list_data_by_user_and_month(@collection)
    end

    def get_client_list_quantity
      if @singular
        get_client_list_data_quantity(@collection)
      else
        get_client_list_data_quantity_for_collection(@collection)
      end
    end

    private

    def obtain_data_for_singular user
      data = Sales::Bill.joins(orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: user.id}).distinct.group_by_month("bills.cbte_fch", format: "%b de %Y").count
      return data
    end

    def obtain_data_from_collection users
      data = Sales::Bill.joins(orders: [:details, details: :user]).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: users.ids}).distinct.group("UPPER(users.first_name) || ', ' || UPPER(users.last_name)").group_by_month("bills.cbte_fch", format: "%b de %Y").count
      return data
    end

    def get_list_data user
      data = Sales::Bill.joins(orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: user.id}).distinct.group_by{|a| I18n.l(a.cbte_fch.to_date, format: "%b de %Y")}.map{|month, records|[month, records.map(&:total).reduce(:+)]}
      return data
    end

    def get_list_data_for_collection users
      data = Sales::Bill.joins(orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: users.ids}).distinct.group_by{|a| I18n.l(a.cbte_fch.to_date, format: "%b de %Y")}.map{|month, records|[month, records.map(&:total).reduce(:+)]}
      return data
    end

    def get_client_list_data user
      data = Sales::Bill.joins(:client, orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: user.id}).distinct.group_by{|a| "#{a.client.name}"}.map{|client, records|[client, records.map(&:total).reduce(:+)]}
      return data
    end

    def get_client_list_data_for_collection users
      data = Sales::Bill.joins(:client, orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: users.ids}).distinct.group_by{|a| "#{a.client.name}"}.map{|client, records|[client, records.map(&:total).reduce(:+)]}
      return data
    end

    def get_list_data_by_user user
      data = Sales::Bill.joins(orders: [:details, details: :user]).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: user.id}).distinct.group("UPPER(users.first_name) || ', ' || UPPER(users.last_name)").sum("bills.total")
      return data
    end

    def get_list_data_by_user_and_month users
      data = Sales::Bill.joins(:orders, orders: [details: :user]).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: users.ids}).group("UPPER(users.first_name) || ', ' || UPPER(users.last_name)").group_by_month("DATE(bills.cbte_fch)", format: "%b/%Y").sum("orders.total")
      return data
    end

    def get_client_list_data_quantity user
      data = Sales::Bill.joins(:client, orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: user.id}).distinct.group("entities.name").count
      return data
    end

    def get_client_list_data_quantity_for_collection users
      data = Sales::Bill.joins(:client, orders: :details).where(state: "Confirmado").where("DATE(bills.cbte_fch) BETWEEN ? AND ? ", @init_date, @final_date).where(order_details: {user_id: users.ids}).distinct.group("entities.name").count
      return data
    end

  end
end
