pageextension 50014 "BusinessRCExt" extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Sales Order")
        {
            action("Update Posted Entries")
            {
                ApplicationArea = all;
                RunObject = codeunit 50004;
            }
        }
    }

    var
        myInt: Integer;
}