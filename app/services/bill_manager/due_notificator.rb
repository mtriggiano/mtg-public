module BillManager
  class DueNotificator
    
    include Rails.application.routes.url_helpers
  	include ActionView::Helpers::UrlHelper
  	include ActionDispatch::Routing::UrlFor

    def initialize bill, days_left
      @bill = bill
      @days_left = days_left
    end

    def call
      users = User.where(bill_due_notification: true)
      unless users.blank?
        gen_notifications(users)
      end
    end

    private

    def gen_notifications users
      notifications = []
      unless @bill.real_total_left == 0
        title = "Factura próxima a vencer"
        body = "La factura #{@bill.number} está proxima a vencer. Vence en #{@days_left} días (#{@bill.due_date}) por un total de $ #{@bill.total}"
        users.each do |user|
          notifications << build(title, body, @bill, user.id)
        end
      end
      Notification.import notifications unless notifications.blank?
    end

    def build(title, body, document, user_id)
      link = polymorphic_path([:edit, document])
        Notification.new(
        title: title,
        body: body.html_safe,
        link: link,
        parent: 'user',
        company_id: document.try(:company_id) || company_id,
        user_id: user_id,
        date: Date.today,
        color: "info")
    end
  end
end
