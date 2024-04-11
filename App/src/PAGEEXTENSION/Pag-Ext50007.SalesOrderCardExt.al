pageextension 50007 "SalesOrderCardExt" extends "Sales Order"
{
    layout
    {
        addafter("No.")
        {
            field("Offer No."; Rec."4SS Offer No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}