$(document).on("select2:select", "select#user_role_role_id", function(){
	setAbilities($(this))
})

$(document).on("nested:fieldAdded:abilities", function(e) {
	const role = $("#user_role_role_id");
	field = e.field.find(".user_role_abilities_id")
	setNewFieldAbilities(role, field)
})

const setAbilities = (role) => {
	form = role.closest("form");
	url = form.attr("action") + "/descriptions_by_role"
	params = {role_id: role.val()}
	description_select = role.closest("fieldset").find(".user_role_abilities_id");
	$.get(url, params, null, "json")
	.done(function(data){
		$.each(description_select, function(){
			populateSelect(data, "#" + $(this).find("select").attr("id"))
		})
	})
}

const setNewFieldAbilities = (role, field) => {
	form = role.closest("form");
	url = form.attr("action") + "/descriptions_by_role"
	params = {role_id: role.val()}
	description_select = field
	$.get(url, params, null, "json")
	.done(function(data){
		$.each(description_select, function(){
			populateSelect(data, "#" + $(this).find("select").attr("id"))
		})
	})
}


function changeUser(user_id){
	$.post("/users/become", {user_id: user_id}, null, "html")
		.done(function(data){
				location.reload()
			}
		)
}
