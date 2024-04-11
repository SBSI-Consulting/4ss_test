pageextension 50006 "SalesQuoteSubformEx" extends "Sales Quote Subform"
{
    layout
    {

    }

    trigger OnModifyRecord(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        /* if rec.Type = rec.type::"Charge (Item)" then
            AssignItemCharge() */
        if SalesHeader.get(rec."Document Type", rec."Document No.") then begin
            salesheader.testfield("4SS Estimation", false);
        end
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        /* if rec.Type = rec.type::"Charge (Item)" then
            AssignItemCharge() */
        if SalesHeader.get(rec."Document Type", rec."Document No.") then begin
            salesheader.testfield("4SS Estimation", false);
        end
    end;

    local procedure AssignItemCharge()

    var
        ItemChargeAssigntSales: Codeunit "Item Charge Assgnt. (Sales)";
        salesline: Record "Sales Line";
    begin
        if salesline.GetBySystemId(rec.SystemId) then begin
            ItemChargeAssigntSales.AssignItemCharges(salesline, Rec.Quantity, Rec.Amount, ItemChargeAssigntSales.AssignEquallyMenuText);
        end;
    end;
}