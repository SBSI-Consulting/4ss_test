/* codeunit 50002 "APISupplySubscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Sales Release", 'OnBeforeCreateWhseRequest', '', true, true)]
    local procedure ModifyExternalDocumentFromSalesHeader(VAR WhseRqst: Record "Warehouse Request"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    begin
        if SalesHeader."4SS offer no." <> '' then begin
            WhseRqst."4SS offer no." := SalesHeader."4SS offer no.";
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseShptHeaderInsert', '', true, true)]
    local procedure OnBeforeWhseShptHeaderInsert(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; TransferLine: Record "Transfer Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if WarehouseRequest."4SS Offer No." <> '' then begin
            WarehouseShipmentHeader."4SS Offer No." := WarehouseRequest."4SS Offer No.";
        end;
        if WarehouseRequest."Shipping Agent Code" <> '' then begin
            WarehouseShipmentHeader."Shipping Agent Code" := WarehouseRequest."Shipping Agent Code";
        end;

        if (SalesHeader.get(WarehouseRequest."Source Document", WarehouseRequest."Source No."))
        and
            (salesheader."Shipping Agent Service Code" <> '')

        then begin
            WarehouseShipmentHeader."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
        end

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', true, true)]
    local procedure OnAfterReleaseSalesDoc(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean)
    begin
        SalesHeader.AssignItemCharge(SalesHeader);
    end;

    procedure PerformManualEstimation(var SalesHeader: Record "Sales Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SellCountry: Record "Country/Region";
        BillCountry: Record "Country/Region";
        ShipCountry: Record "Country/Region";
    begin
        //SalesHeader.Status := SalesHeader.status::Estimation;
        SalesHeader."4SS Estimation" := true;
        SalesHeader.TestField("Sell-to Phone No.");
        SalesHeader.TestField("Sell-to E-Mail");

        if SellCountry.get(SalesHeader."Sell-to Country/Region Code") then SalesHeader."4SS Sell to Country Name" := SellCountry.name;
        if BillCountry.get(SalesHeader."Bill-to Country/Region Code") then SalesHeader."4SS bill to Country Name" := billCountry.name;
        if ShipCountry.get(SalesHeader."Ship-to Country/Region Code") then SalesHeader."4SS ship to Country Name" := ShipCountry.name;

        if SalesHeader."Location Code" <> '' then begin
            SalesHeader."4SS Location Code (API)" := SalesHeader."Location Code";
        end;

        if SalesHeader."Shipping Agent Code" <> '' then begin
            SalesHeader."4SS Shipping Agent Code (API)" := SalesHeader."Shipping Agent Code";
        end;

        if SalesHeader."Shipping Agent Service Code" <> '' then begin
            SalesHeader."4SS Ship. Agent Serv. Code (API)" := SalesHeader."Shipping Agent Service Code";
        end;

        SalesHeader.MODIFY();
    end;

      [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
     local procedure OnAfterInsertSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean)
     begin
         if rec."Document Type" = Rec."Document Type"::quote then
             SetStatusToSalesQuoteEntityBuffer(rec);
     end; 

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if rec."Document Type" = Rec."Document Type"::quote then
            SetStatusToSalesQuoteEntityBuffer(rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if rec."Document Type" = Rec."Document Type"::quote then
            SetStatusToSalesQuoteEntityLine(rec);
    end;

    procedure SetStatusToSalesQuoteEntityBuffer(var SalesHeader: Record "Sales Header")
    var
        SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer";
        RecordExists: Boolean;
    begin

        SalesQuoteEntityBuffer.LockTable();
        RecordExists := SalesQuoteEntityBuffer.Get(SalesHeader."No.");
        //if SalesHeader.Status = SalesHeader.Status::Estimation then begin
        if SalesHeader."4SS Estimation" then begin
            SalesQuoteEntityBuffer."4SS Estimation" := SalesHeader."4SS Estimation";
        end;
        if SalesHeader."4SS Sell to Country Name" <> '' then begin
            SalesQuoteEntityBuffer."4SS Sell to Country Name" := SalesHeader."4SS Sell to Country Name";
        end;
        if SalesHeader."4SS Bill to Country Name" <> '' then begin
            SalesQuoteEntityBuffer."4SS Bill to Country Name" := SalesHeader."4SS Bill to Country Name";
        end;
        if SalesHeader."4SS Ship to Country Name" <> '' then begin
            SalesQuoteEntityBuffer."4SS Ship to Country Name" := SalesHeader."4SS Ship to Country Name";
        end;
        if SalesHeader."Location Code" <> '' then begin
            SalesQuoteEntityBuffer."4SS Location Code (API)" := SalesHeader."Location Code";
        end;
        if SalesHeader."Shipping Agent Code" <> '' then begin
            SalesQuoteEntityBuffer."4SS Shipping Agent Code (API)" := SalesHeader."Shipping Agent Code";
        end;
        if SalesHeader."Shipping Agent Service Code" <> '' then begin
            SalesQuoteEntityBuffer."4SS Ship. Agent Serv. Code (API)" := SalesHeader."Shipping Agent Service Code";
        end;


        if RecordExists then
            SalesQuoteEntityBuffer.Modify(true)
        else
            SalesQuoteEntityBuffer.Insert(true);
    end;

    procedure SetStatusToSalesQuoteEntityLine(var SalesLine: Record "Sales Line")
    var
        SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate";
        SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer";
        RecordExists: Boolean;
        TempFieldBuffer: Record "Field Buffer" temporary;
    begin

        if SalesQuoteEntityBuffer.get(SalesLine."Document No.") then;

        if SalesLine.Get(SalesLine."Document Type"::Quote, SalesQuoteEntityBuffer."No.", SalesLine."Line No.") then begin

            TransferFromSalesLine(SalesInvoiceLineAggregate, SalesQuoteEntityBuffer, SalesLine);
        end;
                     SalesInvoiceLineAggregate.LockTable();
                    SalesInvoiceLineAggregate.setrange("Document Id", SalesQuoteEntityBuffer.id);
                    SalesInvoiceLineAggregate.setrange("Line No.", SalesLine."Line No.");
                    if SalesInvoiceLineAggregate.Find() then
                        RecordExists := true;
                    //if SalesHeader.Status = SalesHeader.Status::Estimation then begin
                end;

                if SalesLine."Location Code" <> '' then begin
                    SalesInvoiceLineAggregate."Location Code" := SalesLine."Location Code";
                end;



                if RecordExists then
                    SalesInvoiceLineAggregate.Modify(true)
                else
                    SalesInvoiceLineAggregate.Insert(true); 
    end;

    procedure LoadLines(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; DocumentIdFilter: Text)
    var
        SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer";
        DocumentIDNotSpecifiedForLinesErr: Label 'You must specify a document id to get the lines.';
    begin
        if DocumentIdFilter = '' then
            Error(DocumentIDNotSpecifiedForLinesErr);

        SalesQuoteEntityBuffer.SetFilter(Id, DocumentIdFilter);
        if not SalesQuoteEntityBuffer.FindFirst then
            exit;

        LoadSalesLines(SalesInvoiceLineAggregate, SalesQuoteEntityBuffer);
    end;

    local procedure LoadSalesLines(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; var SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
        SalesLine.SetRange("Document No.", SalesQuoteEntityBuffer."No.");

        if SalesLine.FindSet(false, false) then
            repeat
                TransferFromSalesLine(SalesInvoiceLineAggregate, SalesQuoteEntityBuffer, SalesLine);
                SalesInvoiceLineAggregate.Insert(true);
            until SalesLine.Next() = 0;
    end;

    local procedure TransferFromSalesLine(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; var SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer"; var SalesLine: Record "Sales Line")
    var
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
    begin
        Clear(SalesInvoiceLineAggregate);
        SalesInvoiceLineAggregate.TransferFields(SalesLine, true);
        SalesInvoiceLineAggregate.Id :=
          SalesLine.SystemId;
        SalesInvoiceLineAggregate.SystemId := SalesLine.SystemId;
        SalesInvoiceLineAggregate."Document Id" := SalesQuoteEntityBuffer.Id;
        SalesInvoiceAggregator.SetTaxGroupIdAndCode(
          SalesInvoiceLineAggregate,
          SalesLine."Tax Group Code",
          SalesLine."VAT Prod. Posting Group",
          SalesLine."VAT Identifier");
        if SalesLine."Location Code" <> '' then begin
            SalesInvoiceLineAggregate."4SS Location Code" := SalesLine."Location Code";
        end;
        SalesInvoiceLineAggregate."VAT %" := SalesLine."VAT %";
        SalesInvoiceLineAggregate."Tax Amount" := SalesLine."Amount Including VAT" - SalesLine."VAT Base Amount";
        SalesInvoiceLineAggregate.SetDiscountValue;
        SalesInvoiceLineAggregate.UpdateReferencedRecordIds;
        //UpdateLineAmountsFromSalesLine(SalesInvoiceLineAggregate, SalesLine);
        SalesInvoiceAggregator.SetItemVariantId(SalesInvoiceLineAggregate, SalesLine."No.", SalesLine."Variant Code");
    end;


         [EventSubscriber(ObjectType::Table, Database::"Sales Quote Entity Buffer", 'OnAfterInsertEvent', '', false, false)]
        local procedure OnAfterInsertSalesQuoteEntityBuffer(var Rec: Record "Sales Quote Entity Buffer"; RunTrigger: Boolean)
        begin
            if rec."Document Type" = Rec."Document Type"::quote then
                SetStatusToSalesHeader(Rec);
        end; 

     [EventSubscriber(ObjectType::Table, Database::"Sales Quote Entity Buffer", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesQuoteEntityBuffer(var Rec: Record "Sales Quote Entity Buffer"; var xRec: Record "Sales Quote Entity Buffer"; RunTrigger: Boolean)
    begin
        if rec."Document Type" = Rec."Document Type"::quote then
            SetStatusToSalesHeader(Rec);
    end; 

    procedure SetStatusToSalesHeader(var SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer")
    var
        SalesHeader: Record "Sales Header";
        RecordExists: Boolean;
    begin

        SalesHeader.LockTable();
        RecordExists := SalesHeader.Get(SalesQuoteEntityBuffer."Document Type", SalesQuoteEntityBuffer."No.");
        //if SalesHeader.Status = SalesHeader.Status::Estimation then begin
                 if SalesHeader.Estimation then begin
                    SalesQuoteEntityBuffer.Estimation := SalesHeader.Estimation;
                end;
                if SalesHeader."Sell to Country Name" <> '' then begin
                    SalesQuoteEntityBuffer."Sell to Country Name" := SalesHeader."Sell to Country Name";
                end;
                if SalesHeader."Bill to Country Name" <> '' then begin
                    SalesQuoteEntityBuffer."Bill to Country Name" := SalesHeader."Bill to Country Name";
                end;
                if SalesHeader."Ship to Country Name" <> '' then begin
                    SalesQuoteEntityBuffer."Ship to Country Name" := SalesHeader."Ship to Country Name";
                end; 
        if SalesHeader."4SS Location Code (API)" <> '' then begin
            SalesHeader."Location Code" := SalesHeader."4SS Location Code (API)";
        end;
        if SalesHeader."4SS Shipping Agent Code (API)" <> '' then begin
            SalesHeader."Shipping Agent Code" := SalesHeader."4SS Shipping Agent Code (API)";
        end;
        if SalesHeader."4SS Ship. Agent Serv. Code (API)" <> '' then begin
            SalesHeader."Shipping Agent Service Code" := SalesHeader."4SS Ship. Agent Serv. Code (API)";
        end;

        if RecordExists then
            SalesHeader.Modify(true);
    end;
     else
        SalesHeader.Insert(true); 
    //end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', true, true)]
    local procedure UpdatePostedWarehouseShipmentHeader(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")

    begin
        PostedWhseShipmentHeader."4SS Offer No." := WarehouseShipmentHeader."4SS Offer No.";
        PostedWhseShipmentHeader."4SS Tracking No." := WarehouseShipmentHeader."4SS Tracking No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify', '', false, false)]
    local procedure OnPostSourceDocumentOnBeforePostSalesHeader(var SalesHeader: Record "Sales Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var ModifyHeader: Boolean; Invoice: Boolean; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    begin
        if WarehouseShipmentHeader."4SS Tracking No." <> '' then begin
            SalesHeader."4SS Tracking No." := WarehouseShipmentHeader."4SS Tracking No.";
        end;

        //SalesHeader."Shipment No." := SalesHeader."Shipping No.";

    end;

       [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
  local procedure OnAfterInsertSalesHeaderInvoice(var Rec: Record "Sales Header"; RunTrigger: Boolean)
  begin
  if rec."Document Type" = Rec."Document Type"::Invoice then
      SetStatusToSalesinvoiceEntityBuffer(rec);
  end; 

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesHeaderInvoice(var Rec: Record "Sales Invoice Header"; var xRec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    begin
        //if rec."Document Type" = Rec."Document Type"::Invoice then
        SetStatusToSalesInvoiceEntityBuffer(rec);
    end;

    procedure SetStatusToSalesInvoiceEntityBuffer(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceEntityAgreggate: Record "Sales Invoice Entity Aggregate";
        RecordExists: Boolean;
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
    begin
        InsertOrModifyFromSalesInvoiceHeader(SalesInvoiceHeader);
    end;

         [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Entity Aggregate", 'OnAfterInsertEvent', '', false, false)]
        local procedure OnAfterInsertSalesInvoiceEntityBuffer(var Rec: Record "Sales Invoice Entity Aggregate"; RunTrigger: Boolean)
        begin
            if rec."Document Type" = Rec."Document Type"::invoice then
                SetStatusToSalesHeaderInvoice(Rec);
        end; 



    procedure CallPDF();
    var

        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        HttpRequestMessage: HttpRequestMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;

        JsonText: text;
        i: Integer;
        RequestJson: Text;
        GoodJson: text;
        JArrayvalue: JsonArray;
        JReponse: JsonObject;
        jData: JsonObject;

        JOvalue: JsonObject;
        WDialog: Dialog;
        TotalCounter: Integer;
        ModuloCounter: Integer;
        CurrentCounter: Integer;
        CommitCounter: Integer;
        StartDate: DateTime;
        EndDate: DateTime;

        j: integer;
        JOvcligne: JsonObject;
        JArrayvcligne: JsonArray;
        identete: guid;
        Idligne: guid;
        //InterfaceLog: record "Interface Log";

        RequestDate: text;
        file: File;
        f: Integer;
        CompanyName: Text;
        ErrorText: Text;


    begin


        HttpClient.Clear();

        HttpContent.Clear();
        RequestJson := '{"ShippingAgentCode": "DHL","ShippingAgentServicesCode": "","externalDocumentNumber": "123"}';
        HttpContent.WriteFrom(RequestJson);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.clear;
        HttpHeaders.Add('Content-Type', 'application/json');
        //HttpHeaders.Add('If-Match', 'W/"JzQ0O254cGJjbUxWNUM2bGpCYS9kWmNwV3ljaTdXWFZsczBMRXF0TnhTbVlCTFk9MTswMDsn"');
        //HttpHeaders.Add('If-Match', '*');
        AddHttpBasicAuthHeader('CAMALET', 'SVdyHJaR09dAcUAjQ1RwSWjpHjKK8M8mYwUn7MyUKuY=', HttpClient);
        HttpClient.DefaultRequestHeaders.Add('If-Match', '*');
        //        Add('If-Match', 'W/"JzQ0O254cGJjbUxWNUM2bGpCYS9kWmNwV3ljaTdXWFZsczBMRXF0TnhTbVlCTFk9MTswMDsn"');
        HttpRequestMessage.Content := HttpContent;


        HttpRequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/6bc0bdda-9426-471f-a6cc-968322588dee/Sandbox/api/sbsiconsulting/Supply/v2.0/companies(f7cfbd17-e1d8-ea11-a814-000d3a898443)/salesQuotes(908b82af-2f5a-eb11-89f9-000d3ae71161)');
        //message('http://webservices.cavavin.eu:7077/CAVAVINNAS2/ODataV4/Company(' + '''CAVAVIN''' + ')/Ecritures_Articles');
        HttpRequestMessage.Method := 'PATCH';
        HttpClient.Timeout(300000);

        HttpClient.Send(HttpRequestMessage, ResponseMessage);
        //HttpClient.SetBaseAddress('https://api.businesscentral.dynamics.com/v2.0/6bc0bdda-9426-471f-a6cc-968322588dee/Sandbox/api/sbsiconsulting/Supply/v2.0/companies(f7cfbd17-e1d8-ea11-a814-000d3a898443)/salesQuotes(908b82af-2f5a-eb11-89f9-000d3ae71161)');
        // HttpClient.Put(HttpClient.GetBaseAddress, HttpContent, ResponseMessage);
                 CompanyName := HttpClient.GetBaseAddress;
                message(CompanyName); 
         if not HttpClient.Send(HttpRequestMessage, ResponseMessage)
        then begin
            ErrorText := 'The call to the web service failed.';
            exit(false);
        end; 

        //Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then begin
            ErrorText := StrSubstNo('The web service returned an error message:Status code: %1 - Description: %2',
            ResponseMessage.HttpStatusCode,
            ResponseMessage.ReasonPhrase);
            //exit(false);
        end;
        //error('The web service returned an error message:\' +
        //  'Status code: %1' +
        //'Description: %2',
        //ResponseMessage.HttpStatusCode,
        //ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);

        // Process JSON response
                 if not JsonArray.ReadFrom(JsonText) then begin
                    // probably single object
                    JsonToken.ReadFrom(JsonText);
                    Insertvcentete(JsonToken);
                end else begin 
        // array
        //JsonObject.ReadFrom(JsonText);
        //JsonObject.SelectToken('"reponse"."data"."vcentete"', JsonToken);
        //JsonObject.ReadFrom(JsonText);
        //hyperlink('https://api.businesscentral.dynamics.com/v2.0/6bc0bdda-9426-471f-a6cc-968322588dee/Sandbox/api/sbsiconsulting/Supply/v2.0/companies(f7cfbd17-e1d8-ea11-a814-000d3a898443)/salesInvoices(c79342f4-4f56-eb11-89f9-000d3ae716bc)/pdfDocument/pdfDocumentContent');
        //Hyperlink(JsonText);
        //JReponse := GetTokenAsObject(JsonObject, '', 'pas de données');
        //jData := GetTokenAsObject(JReponse, 'datas', 'data pas trouvé');
        //JArrayvalue := GetTokenAsArray(JsonObject, 'value', 'pas de données');
        //if JsonArray.SelectToken('"reponse"."data"."vcentete"', JsonToken) then begin
        if GUIALLOWED then begin
            StartDate := CURRENTDATETIME;
            TotalCounter := JArrayvalue.Count;
            ModuloCounter := ROUND(TotalCounter * 1 / 100, 1, '>');
            CurrentCounter := 0;
            WDialog.UPDATE(1, FORMAT(StartDate));
            //WDialog.UPDATE(2, Text001);
        end;
        CommitCounter := 0;
        for i := 0 to JArrayvalue.Count - 1 do begin
            if GUIALLOWED then begin
                CurrentCounter += 1;
                if CurrentCounter mod ModuloCounter = 1 then begin
                    if GUIALLOWED then begin
                        WDialog.UPDATE(3, ROUND(CurrentCounter / TotalCounter * 9999, 1, '>'));
                    end;
                end;
            end;
             JOvalue := getarrayelementasobject(jArrayvalue, i, '');
            identete := CreateGuid();

            //vcligne
             JArrayvcligne := GetTokenAsArray(JOvcentete, 'vcligne', 'vcligne pas trouvé');

            for j := 0 to JArrayvcligne.Count - 1 do begin
                JOvcligne := getarrayelementasobject(jArrayvcligne, j, '');
                Insertvcligne(JOvcligne, identete);
            end; 
            // InsertEcrituresArticles(JOvalue, identete); 
        end;
        if GUIALLOWED then begin
            WDialog.CLOSE;
            EndDate := CURRENTDATETIME;
            //MESSAGE(STRSUBSTNO(Text003, FORMAT(StartDate), FORMAT(EndDate)));
        end;
        EndDate := CURRENTDATETIME;
          ProcessingTime := EndDate - Startdate;
         exit(true); 

    end;

    procedure AddHttpBasicAuthHeader(UserName: Text[50]; Password: Text[50]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := Base64Helpers.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        message(AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;

    procedure FromBase64(UserName: Text) PDF: Text;
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
         AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := Base64Helpers.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        message(AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString); 
        PDF := Base64Helpers.FromBase64(UserName);

    end;

    procedure InsertOrModifyFromSalesInvoiceHeader(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate";
        RecordExists: Boolean;
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
    begin
        SalesInvoiceEntityAggregate.LockTable();
        RecordExists := SalesInvoiceEntityAggregate.Get(SalesInvoiceHeader."No.", true);
        SalesInvoiceEntityAggregate.TransferFields(SalesInvoiceHeader, true);
        SalesInvoiceEntityAggregate.Id := SalesInvoiceAggregator.GetSalesInvoiceHeaderId(SalesInvoiceHeader);

        SalesInvoiceEntityAggregate.Posted := true;
        SetStatusOptionFromSalesInvoiceHeader(SalesInvoiceHeader, SalesInvoiceEntityAggregate);
        AssignTotalsFromSalesInvoiceHeader(SalesInvoiceHeader, SalesInvoiceEntityAggregate);
        SalesInvoiceEntityAggregate.UpdateReferencedRecordIds;
        if SalesInvoiceHeader."Location Code" <> '' then begin
            SalesInvoiceEntityAggregate."4SS Location Code" := SalesInvoiceHeader."Location Code";
        end;

        if RecordExists then
            SalesInvoiceEntityAggregate.Modify(true)
        else
            SalesInvoiceEntityAggregate.Insert(true);
    end;

    procedure SetStatusOptionFromSalesInvoiceHeader(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeSetStatusOptionFromSalesInvoiceHeader(SalesInvoiceHeader, SalesInvoiceEntityAggregate, IsHandled);
        if IsHandled then
            exit;

        SalesInvoiceHeader.CalcFields(Cancelled, Closed, Corrective);
        if SalesInvoiceHeader.Cancelled then begin
            SalesInvoiceEntityAggregate.Status := SalesInvoiceEntityAggregate.Status::Canceled;
            exit;
        end;

        if SalesInvoiceHeader.Corrective then begin
            SalesInvoiceEntityAggregate.Status := SalesInvoiceEntityAggregate.Status::Corrective;
            exit;
        end;

        if SalesInvoiceHeader.Closed then begin
            SalesInvoiceEntityAggregate.Status := SalesInvoiceEntityAggregate.Status::Paid;
            exit;
        end;

        SalesInvoiceEntityAggregate.Status := SalesInvoiceEntityAggregate.Status::Open;
    end;

    procedure AssignTotalsFromSalesInvoiceHeader(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");

        if not SalesInvoiceLine.FindFirst then begin
            //BlankTotals(SalesInvoiceLine."Document No.", true);
            exit;
        end;

        //AssignTotalsFromSalesInvoiceLine(SalesInvoiceLine, SalesInvoiceEntityAggregate);
    end;

    procedure PropagateOnModify(var SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    var
        SalesHeader: Record "Sales Header";
        TypeHelper: Codeunit "Type Helper";
        TargetRecordRef: RecordRef;
        Exists: Boolean;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        GraphMgtSalesQuoteBuffer: Codeunit "Graph Mgt - Sales Quote Buffer";
    begin
        if SalesQuoteEntityBuffer.IsTemporary or (not GraphMgtGeneralTools.IsApiEnabled) then
            exit;

        Exists := SalesHeader.Get(SalesHeader."Document Type"::Quote, SalesQuoteEntityBuffer."No.");
        if Exists then
            TargetRecordRef.GetTable(SalesHeader)
        else
            TargetRecordRef.Open(DATABASE::"Sales Header");

        TypeHelper.TransferFieldsWithValidate(TempFieldBuffer, SalesQuoteEntityBuffer, TargetRecordRef);
        //GraphMgtSalesQuoteBuffer.SetStatusOptionToSalesHeader(TempFieldBuffer, SalesQuoteEntityBuffer, TargetRecordRef);

        TargetRecordRef.SetTable(SalesHeader);
        SalesHeader.CopySellToAddressToBillToAddress;

        if SalesHeader."4SS Location Code (API)" <> '' then begin
            SalesHeader."Location Code" := SalesHeader."4SS Location Code (API)";
        end;
        if SalesHeader."4SS Shipping Agent Code (API)" <> '' then begin
            SalesHeader."Shipping Agent Code" := SalesHeader."4SS Shipping Agent Code (API)";
        end;
        if SalesHeader."4SS Ship. Agent Serv. Code (API)" <> '' then begin
            SalesHeader."Shipping Agent Service Code" := SalesHeader."4SS Ship. Agent Serv. Code (API)";
        end;

        if Exists then
            SalesHeader.Modify(true)
        else begin
            SalesHeader.SetDefaultPaymentServices;
            SalesHeader.Insert(true);
        end;
    end;

         [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptHeaderInsert', '', false, false)]

        local procedure OnAfterSalesShptHeaderInsert(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; SuppressCommit: Boolean)
        begin
            SalesHeader."Shipment No." := SalesShipmentHeader."No.";
            SalesHeader.Modify();
        end;
     

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]

    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        SalesInvHeader."4SS Shipment No." := SalesHeader."Shipping No.";
        //SalesHeader.Modify();
    end;


     local procedure FilterPstdDocLineValueEntries(var ValueEntry: Record "Value Entry")
    var


    begin
        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.", SalesInvoiceLine."Line No.");
    end;

    procedure GetSalesShptLines2() ShipmentNo: Code[20]
    var
        SalesShptLine: Record "Sales Shipment Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Sales

    begin
        

        
        /TempSalesShptLine.Reset(); 
    //TempSalesShptLine.DeleteAll();

     SalesInvoiceLine.setrange("Document No.", rec."Document No.");
    SalesInvoiceLine.setrange(Type, SalesInvoiceLine.Type::Item);
    if SalesInvoiceLine.findfirst then; 

             if SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item then
                exit; 

     FilterPstdDocLineValueEntries(ValueEntry);
    if ValueEntry.FindSet then
        repeat
            ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
            if ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Shipment" then
                if SalesShptLine.Get(ItemLedgEntry."Document No.", ItemLedgEntry."Document Line No.") then begin

                    exit(SalesShptLine."Document No.")
                end;
        until ValueEntry.Next = 0; 
    //end;


         begin
            if SalesInvoiceHeader.get(rec."Document No.") then begin
                SalesInvoiceHeader."Shipment No." := GetSalesShptLines2();
                SalesInvoiceHeader.modify;
            end;
        end;
     
    [EventSubscriber(ObjectType::Report, Report::"Get Item Ledger Entries", 'OnBeforeInsertItemJnlLine', '', false, false)]
    procedure OnBeforeInsertItemJnlLine(var IntrastatJnlLine: Record "Intrastat Jnl. Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean)
    begin
        case ItemLedgerEntry."Source Type" of
            ItemLedgerEntry."Source Type"::Customer:
                begin
                    IntrastatJnlLine."4SS Third Party Type" := IntrastatJnlLine."4SS Third Party Type"::Customer;
                    IntrastatJnlLine."4SS Third Party No." := ItemLedgerEntry."Source No.";
                    ItemLedgerEntry.CalcFields("Source Name");
                    IntrastatJnlLine."4SS Third Party Name" := ItemLedgerEntry."Source Name";
                end;
            ItemLedgerEntry."Source Type"::Vendor:
                begin
                    IntrastatJnlLine."4SS Third Party Type" := IntrastatJnlLine."4SS Third Party Type"::Vendor;
                    IntrastatJnlLine."4SS Third Party No." := ItemLedgerEntry."Source No.";
                    ItemLedgerEntry.CalcFields("Source Name");
                    IntrastatJnlLine."4SS Third Party Name" := ItemLedgerEntry."Source Name";
                end;
        end

    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";

}
 */