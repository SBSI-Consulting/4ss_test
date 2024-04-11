/* page 50006 "API Posted Warehouse Shipment"
{
    PageType = API;
    Caption = 'API Warehouse Shipment';
    APIPublisher = 'SBSIConsulting';
    APIGroup = 'Supply';
    APIVersion = 'v2.0';
    EntityName = 'postedWarehouseShipment';
    EntitySetName = 'postedWarehouseShipments';
    SourceTable = "Posted Whse. Shipment Header";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'Id';

                }
                field(OfferNo; Rec."4SS Offer No.")
                {
                    Caption = 'OfferNo';

                }
                field(TrackingNo; Rec."4SS Tracking No.")
                {
                    Caption = 'TrackingNo';
                    trigger OnValidate()
                    begin

                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        WarehouseSetup: Record "warehouse setup";
    begin
        WarehouseSetup.get;
        Rec.SetRange("Location Code", WarehouseSetup."4SS Supply Location Code");
    end;

} */