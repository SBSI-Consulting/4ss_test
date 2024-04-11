tableextension 50012 "PostedSalesInvoiceLineExt" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "4SS Package Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }


    var
        myInt: Integer;
}