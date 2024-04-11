/* page 50000 "API Warehouse Shipment"
{
    PageType = API;
    Caption = 'API Warehouse Shipment';
    APIPublisher = 'SBSIConsulting';
    APIGroup = 'Supply';
    APIVersion = 'v2.0';
    EntityName = 'warehouseShipment';
    EntitySetName = 'warehouseShipments';
    SourceTable = "Warehouse Shipment Header";
    DelayedInsert = true;
    ODataKeyFields = "4SS Id";
    ChangeTrackingAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; Rec."4SS Id")
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
                                                 commit;
                                                if Rec."Tracking No." <> '' then
                                                    PostWarehouseShipment;
                                                //message('je suis là'); 
                    end;
                }
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    caption = 'ShippingAgentCode';
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

    trigger OnModifyRecord(): Boolean
    begin
         if Rec."Tracking No." <> '' then
            PostWarehouseShipment; 
    end;

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

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Post(var ActionContext: WebServiceActionContext)
    var
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        WhseShptLine: record "warehouse shipment line";
        WhseShptheader: Record "warehouse shipment header";
        WhseShipHeaderNo: Code[20];
        WhseShipLineSourceNo: Code[20];
        PostedWhseShipHeader: Record "Posted Whse. Shipment Header";

    begin
        //GetDraftInvoice(SalesHeader);
        //PostInvoice(SalesHeader, SalesInvoiceHeader);
        //SetActionResponse(ActionContext, SalesInvoiceAggregator.GetSalesInvoiceHeaderId(SalesInvoiceHeader));
        WhseShptheader.SetRange("4SS id", Rec."4SS id");

        if WhseShptheader.findfirst then begin
            WhseShipHeaderNo := WhseShptheader."No.";
            WhseShptLine.setrange("No.", WhseShptheader."No.");
            if WhseShptLine.FindSet() then begin
                WhseShipLineSourceNo := WhseShptLine."Source No.";
                repeat
                    //WhsePostShipment.SetPostingSettings(true);
                    WhsePostShipment.SetPrint(FALSE);
                    WhsePostShipment.RUN(WhseShptLine);
                    WhsePostShipment.GetResultMessage;
                    CLEAR(WhsePostShipment);
                until WhseShptLine.next = 0;
            end;

        end;
        ShipAndInvoice(ActionContext, WhseShipLineSourceNo);
        //SetActionResponse(ActionContext, GetWarehouseShipmentNo(PostedWhseShipHeader, WhseShipHeaderNo))
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; InvoiceId: Guid)
    var
    begin
        SetActionResponse(ActionContext, Page::"API Warehouse Shipment", InvoiceId);
    end;

    local procedure GetWarehouseShipmentNo(var PostedWhseShipHeader: Record "Posted Whse. Shipment Header"; No: Code[20]): Code[20]
    begin
        PostedWhseShipHeader.setrange("Whse. Shipment No.", No);
        if PostedWhseShipHeader.FindFirst() then
            exit(PostedWhseShipHeader.SystemId)
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; PageId: Integer; DocumentId: Guid)
    var
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(PageId);
        ActionContext.AddEntityKey(Rec.FieldNo("4SS Id"), DocumentId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;

    procedure ShipAndInvoice(var ActionContext: WebServiceActionContext; SalesOrderNo: code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
    begin
        //GetOrder(SalesHeader);

        if SalesHeader.get(SalesHeader."Document Type"::Order, SalesOrderNo) then begin
            PostWithShipAndInvoice(SalesHeader, SalesInvoiceHeader);
            SetActionResponse(ActionContext, Page::"APIV2 - Sales Invoices", SalesInvoiceAggregator.GetSalesInvoiceHeaderId(SalesInvoiceHeader));
        end;
    end;

    local procedure PostWithShipAndInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        DummyO365SalesDocument: Record "O365 Sales Document";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        O365SendResendInvoice: Codeunit "O365 Send + Resend Invoice";
        OrderNo: Code[20];
        OrderNoSeries: Code[20];
    begin
        O365SendResendInvoice.CheckDocumentIfNoItemsExists(SalesHeader, false, DummyO365SalesDocument);
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
        OrderNo := SalesHeader."No.";
        OrderNoSeries := SalesHeader."No. Series";
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        SalesHeader.SendToPosting(Codeunit::"Sales-Post");
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetRange("Pre-Assigned No. Series", '');
        SalesInvoiceHeader.SetRange("Order No. Series", OrderNoSeries);
        SalesInvoiceHeader.SetRange("Order No.", OrderNo);
        SalesInvoiceHeader.FindFirst();
    end;

} */