({
	init: function(component, event, helper) {
        // Set body to empty
        component.set("v.body",[]);
       	helper.getRelatedRecordView(component, event);
	}
})