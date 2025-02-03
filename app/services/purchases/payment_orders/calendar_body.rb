class Purchases::PaymentOrders::CalendarBody < SimpleCalendar::Calendar

  def url_for_next_view
    view_context.url_for(@params.merge(start_date_param => (date_range.last + 1.day).iso8601))
  end

  def url_for_previous_view
    view_context.url_for(@params.merge(start_date_param => (date_range.first - 1.day).iso8601))
  end
  
  private

    def date_range
      beginning = start_date.beginning_of_month
      ending    = start_date.end_of_month
      pp (beginning..ending).to_a
    end


end
