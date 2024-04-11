tableextension 50010 "SalesInvoiceLineAggregateExt" extends "Sales Invoice Line Aggregate"
{
    fields
    {
        field(50001; "4SS Location Code"; Code[10])
        {
            //Caption = 'Location Code';

        }
        field(50000; "4SS Package Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}