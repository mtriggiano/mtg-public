class HumanResources::NonPresentUsersController < ApplicationController

    expose :non_present_users, -> {NonPresentUser.all.order("date DESC")}
    expose :non_present_user, scope: ->{non_present_users}
    include Indexable

end
