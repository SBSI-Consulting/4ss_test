tableextension 50011 "SalesLineExt" extends "Sales Line"
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