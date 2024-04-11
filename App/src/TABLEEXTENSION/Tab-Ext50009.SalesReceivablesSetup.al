tableextension 50009 "SalesReceivablesSetup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "4SS Footer Standard Text Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
        }
        field(50001; "4SS CGV Standard Text Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";

        }
    }



    var
        myInt: Integer;
}