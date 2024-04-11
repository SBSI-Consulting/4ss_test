pageextension 50005 "SalesOrdersExt" extends "Sales Order List"
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