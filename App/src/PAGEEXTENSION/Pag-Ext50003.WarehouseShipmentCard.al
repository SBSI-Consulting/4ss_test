pageextension 50003 "WarehouseShipmentCard" extends "Warehouse Shipment"
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

    local procedure PostWarehouseShipment()
    var
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        WhseShptLine: record "warehouse shipment line";
    begin
        WhseShptLine.setrange("No.", Rec."No.");
        if WhseShptLine.FindSet() then begin
            repeat
                WhsePostShipment.SetPostingSettings(true);
                WhsePostShipment.SetPrint(FALSE);
                WhsePostShipment.RUN(WhseShptLine);
                WhsePostShipment.GetResultMessage;
                CLEAR(WhsePostShipment);
            until WhseShptLine.next = 0;
        end;
    end;
}