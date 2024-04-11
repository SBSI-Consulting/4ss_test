pageextension 50004 "PostedWarehouseShipmentCard" extends "Posted Whse. Shipment"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Offer No."; Rec."4SS Offer No.")
            {
                ApplicationArea = all;

            }
            field("Tracking No."; Rec."4SS Tracking No.")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    /*    commit;
                       if Rec."Tracking No." <> '' then
                           PostWarehouseShipment; */
                end;
            }
        }
    }

    actions
    {
    }
}