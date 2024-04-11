report 50008 "CorrectionReport"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Permissions = tabledata 5802 = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ValueEntry; "Value Entry")


        {
            DataItemTableView = where("Item Charge No." = filter(<> ''), "Item Ledger Entry Type" = const(sale));
            trigger OnAfterGetRecord()
            var
                SalesInvoiceLine: Record "Sales Invoice Line";
                SalesCreditMemoLine: record "Sales Cr.Memo Line";
            begin
                if SalesInvoiceLine.get("Document No.", "Document Line No.") then begin
                    if SalesInvoiceLine.Type = SalesInvoiceLine.Type::"Charge (Item)" then begin
                        "Item Charge No." := SalesInvoiceLine."No.";
                        Modify;
                    end;
                end;
                if SalesCreditMemoLine.get("Document No.", "Document Line No.") then begin
                    if SalesCreditMemoLine.Type = SalesCreditMemoLine.Type::"Charge (Item)" then begin
                        "Item Charge No." := SalesCreditMemoLine."No.";
                        Modify;
                    end;
                end
            end;
        }
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = where("Document Type" = filter(''), "Item Ledger Entry Type" = const(sale));
            trigger OnAfterGetRecord()
            begin
                "Document Type" := "Document Type"::"Sales Invoice";
                Modify;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /*                     field(Name; SourceExpression)
                                        {
                                            ApplicationArea = All;

                                        } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}