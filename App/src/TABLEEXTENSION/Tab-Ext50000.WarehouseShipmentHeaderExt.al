tableextension 50000 "WarehouseShipmentHeaderExt" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50000; "4SS Offer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "4SS Tracking No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }


        field(50002; "4SS Id"; Guid)
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnAfterInsert()
    begin
        "4SS id" := CreateGuid();
        modify;
    end;

    trigger OnAfterModify()
    begin
        /* if Rec."Tracking No." <> '' then
            PostWarehouseShipment; */
    end;

    var
        myInt: Integer;

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