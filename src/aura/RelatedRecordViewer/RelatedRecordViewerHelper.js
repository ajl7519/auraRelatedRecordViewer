({
    getData : function(component, event) {
        let relatedRecordId = null;
        let action = component.get("c.getRelatedRecordId");
        action.setParams({
            recordId: component.get("v.recordId"),
            fieldApiName: component.get("v.fieldApiName")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                relatedRecordId = response.getReturnValue();
                this.createRecordView(component, relatedRecordId);
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                let errors = response.getError();
                this.handleErrors(errors);
            }        
        });
        $A.enqueueAction(action);
    },
    createRecordView : function(component, relatedRecordId) {
        const invalidRelatedRecordMsg = component.get("v.invalidRelatedRecordMsg");
        let componentType, componentAttributes;
            if (relatedRecordId !== null) {
                componentType = "force:recordView";
                componentAttributes = {
                    "recordId": relatedRecordId,
                    "type": "FULL",
                    "aura:id": "recordView"
                };
            } else {
                componentType = "lightning:formattedText";
                componentAttributes = {"value": invalidRelatedRecordMsg};
            }
            $A.createComponent(
                componentType,
                componentAttributes,
                function(recordView, status, errorMessage) {
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        body.push(recordView);
                        component.set("v.body", body);
                    } else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    } else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
                }
            );
    },
    handleErrors : function(errors) {
        // Configure error toast
        let toastParams = {
            title: "Error",
            message: "Unknown error",
            type: "error"
        };
        // Pass the error message if any
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})