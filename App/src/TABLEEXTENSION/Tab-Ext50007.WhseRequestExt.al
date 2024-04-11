tableextension 50007 "WhseRequestExt" extends "Warehouse Request"
{
    fields
    {
        field(50000; "4SS Offer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "4SS Tracking No."; Code[20])
        {
            DataClassification = ToBeClassified;
            editable = false;
        }
    }

    var
        myInt: Integer;
}