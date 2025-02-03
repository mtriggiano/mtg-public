// Habilita para seleccionar el contacto hijo del cliente seleccionado
$(document).on("select2:select", "select[name$='[entity_id]']", function(){
    checkEntityContact()
})

$(document).bind("ready ajaxComplete pjax:complete", function(){
    checkEntityContact()
})

checkEntityContact = () => {
    const file = $("#file_select")
    if (!file.is(":disabled")){
        const contact = $("select[name$='[entity_contact_id]']");
        contact.removeAttr("disabled")
    }
    
}

