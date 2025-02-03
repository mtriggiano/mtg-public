module Notificable
  extend ActiveSupport::Concern

  included do
    after_save :notificate, if: :need_to?

    def need_to?
      if self.class.column_names.include?("state")
        (saved_change_to_state? || saved_change_to_id?) && (!reopened? || !pending?)
      else
        false
      end
    end

    def notificate
      if saved_change_to_id?
        notificator.for_created
      elsif canceled?
        notificator.for_disable
      else
        notificator.for_updated
      end
    end

    def notificator
      eval("Notification::#{itself.class.name}").new(self, current_user)
    end
  end
end
