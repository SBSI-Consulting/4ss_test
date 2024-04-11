/* page 50005 "warehouseShipmentsList"
{
    PageType = List;
    SourceTable = "warehouse shipment header";
    CaptionML = ENU = 'List of warehouseShipments';
    Editable = false;
    SourceTableView = order(descending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                 field("@odata.context"; "@odata.context")
                {
                    ApplicationArea = All;
                }
                field("@odata.etag"; "@odata.etag")
                {
                    ApplicationArea = All;
                } 
                field("Id"; Rec."4SS Id")
                {
                    ApplicationArea = All;
                }
                field("OfferNo"; Rec."4SS Offer No.")
                {
                    ApplicationArea = All;
                }
                field("TrackingNo"; Rec."4SS Tracking No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshwarehouseShipmentsAction)
            {
                CaptionML = ENU = 'Refresh warehouseShipments';
                Promoted = true;
                PromotedCategory = Process;
                Image = RefreshLines;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    RefreshwarehouseShipments();
                    CurrPage.Update;
                    if Rec.FindFirst then;
                end;
            }
        }
    }

    local procedure RefreshwarehouseShipments();
    var
        CallAPI: Codeunit RefreshwarehouseShipments;
    begin
        CallAPI.Refresh();
    end;
}
 */