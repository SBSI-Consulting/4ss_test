tableextension 50013 "IntrastatJnlLine" extends "Intrastat Jnl. Line"
{
    fields
    {
        field(50000; "4SS Third Party No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("4SS Third Party Type" = CONST(Customer)) Customer ELSE
            IF ("4SS Third Party Type" = const(Vendor)) Vendor;
        }
        field(50001; "4SS Third Party Name"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "4SS Third Party Type"; Enum ThirdPartyType)
        {
            DataClassification = CustomerContent;
        }
    }


    var
        myInt: Integer;
}