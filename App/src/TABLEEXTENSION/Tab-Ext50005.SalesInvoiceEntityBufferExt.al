tableextension 50005 "SalesInvoiceEntityBufferExt" extends "Sales Invoice Entity Aggregate"
{
    fields
    {

        field(50000; "4SS Offer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "4SS Sell to Country Name"; Text[20])
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

        field(50005; "4SS Estimation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50006; "4SS Tracking No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }





        field(50007; "4SS Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}

