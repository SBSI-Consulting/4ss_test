tableextension 50004 "WarehouseSetupExt" extends "Warehouse Setup"
{
    fields
    {
        field(50000; "4SS Supply Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
            Editable = true;
        }
    }

}