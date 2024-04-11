pageextension 50002 "WarehouseSetupPageExt" extends "Warehouse Setup"
{
    layout
    {
        addafter("Shipment Posting Policy")
        {
            field("Supply Location Code"; Rec."4SS Supply Location Code")
            {
                ApplicationArea = all;
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