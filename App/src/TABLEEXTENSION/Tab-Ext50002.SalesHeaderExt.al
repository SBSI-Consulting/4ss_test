tableextension 50002 "SalesHeaderExt" extends "Sales Header"
{
    fields
    {
        field(50000; "4SS Offer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "4SS Estimation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "4SS Bill to Country Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "4SS Ship to Country Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "4SS Sell to Country Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "4SS Net Weight"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line"."Net Weight" where(Type = const(Item)));
        }
        field(50006; "4SS Tracking No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "4SS Shipment No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        //ne pas mettre de 50008
        field(50009; "4SS Package Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50010; "4SS Package Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."4SS Package Quantity" where("Document Type" = field("Document Type"), "Document No." = field("No."), Type = const("Charge (Item)")));
        }
        field(50106; "4SS Location Code (API)"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "4SS Shipping Agent Code (API)"; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "4SS Ship. Agent Serv. Code (API)"; Code[10])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }


    }

    trigger OnAfterInsert()
    begin
        if SellCountry.get(Rec."Sell-to Country/Region Code") then Rec."4SS Sell to Country Name" := SellCountry.name;
        if BillCountry.get(Rec."Bill-to Country/Region Code") then Rec."4SS bill to Country Name" := billCountry.name;
        if ShipCountry.get(Rec."Ship-to Country/Region Code") then Rec."4SS ship to Country Name" := ShipCountry.name;
    end;

    trigger OnAfterModify()
    begin

    end;

    procedure AssignItemCharge(var SalesHeader: record "sales header")

    var
        ItemChargeAssigntSales: Codeunit "Item Charge Assgnt. (Sales)";
        salesline: Record "Sales Line";
    begin
        salesline.setrange("Document Type", SalesHeader."Document Type");
        salesline.SetRange("Document No.", SalesHeader."No.");
        salesline.setrange(type, salesline.type::"Charge (Item)");
        salesline.CalcFields("Qty. to Assign");
        salesline.setfilter("Qty. to Assign", '%1', 0);
        if salesline.findset() then begin
            repeat
                ItemChargeAssgnt(salesline);
                ItemChargeAssigntSales.AssignItemCharges(salesline, salesline.Quantity, salesline.Amount, ItemChargeAssigntSales.AssignEquallyMenuText);
            until salesline.next = 0;
        end;
    end;

    local procedure ItemChargeAssgnt(var SalesLine: Record "sales line")
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        ItemChargeAssgnts: Page "Item Charge Assignment (Sales)";
        ItemChargeAssgntLineAmt: Decimal;
        IsHandled: Boolean;
        Currency: Record Currency;
    begin
        //Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");
        SalesLine.TestField("No.");
        SalesLine.TestField(Quantity);

        if SalesLine.Type <> SalesLine.Type::"Charge (Item)" then begin
            //Message(ItemChargeAssignmentErr);
            exit;
        end;

        //Rec.GetSalesHeader();
        Currency.Initialize(Rec."Currency Code");
        if (SalesLine."Inv. Discount Amount" = 0) and (SalesLine."Line Discount Amount" = 0) and
           (not Rec."Prices Including VAT")
        then
            ItemChargeAssgntLineAmt := SalesLine."Line Amount"
        else
            if Rec."Prices Including VAT" then
                ItemChargeAssgntLineAmt :=
                  Round(SalesLine.CalcLineAmount / (1 + SalesLine."VAT %" / 100), Currency."Amount Rounding Precision")
            else
                ItemChargeAssgntLineAmt := SalesLine.CalcLineAmount;

        ItemChargeAssgntSales.Reset();
        ItemChargeAssgntSales.SetRange("Document Type", SalesLine."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", SalesLine."Document No.");
        ItemChargeAssgntSales.SetRange("Document Line No.", SalesLine."Line No.");
        ItemChargeAssgntSales.SetRange("Item Charge No.", SalesLine."No.");
        if not ItemChargeAssgntSales.FindLast then begin
            ItemChargeAssgntSales."Document Type" := "Document Type";
            ItemChargeAssgntSales."Document No." := SalesLine."Document No.";
            ItemChargeAssgntSales."Document Line No." := SalesLine."Line No.";
            ItemChargeAssgntSales."Item Charge No." := SalesLine."No.";
            ItemChargeAssgntSales."Unit Cost" :=
              Round(ItemChargeAssgntLineAmt / SalesLine.Quantity, Currency."Unit-Amount Rounding Precision");
        end;

        IsHandled := false;
        //OnShowItemChargeAssgntOnBeforeCalcItemCharge(Rec, ItemChargeAssgntLineAmt, Currency, IsHandled, ItemChargeAssgntSales);
        if not IsHandled then
            ItemChargeAssgntLineAmt :=
              Round(ItemChargeAssgntLineAmt * (SalesLine."Qty. to Invoice" / SalesLine.Quantity), Currency."Amount Rounding Precision");

        if IsCreditDocType() then
            AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales, "Return Receipt No.")
        else
            AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales, SalesLine."Shipment No.");
        Clear(AssignItemChargeSales);
        Commit();

        /* ItemChargeAssgnts.Initialize(SalesLine, ItemChargeAssgntLineAmt);
        ItemChargeAssgnts.RunModal; */
        SalesLine.CalcFields("Qty. to Assign");
    end;

    var
        BillCountry: record "Country/Region";
        SellCountry: record "Country/Region";
        ShipCountry: record "Country/Region";
    //APISupplySubscriber: Codeunit APISupplySubscriber;



}