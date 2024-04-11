tableextension 50001 "SalesQuoteEntityBufferExt" extends "Sales Quote Entity Buffer"
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
        field(50006; "4SS Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50007; "4SS Shipping Agent Code"; code[10])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;

        }
        field(50008; "4SS Shipping Agent Service Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50009; "4SS Package Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }

        field(50106; "4SS Location Code (API)"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50107; "4SS Shipping Agent Code (API)"; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "4SS Ship. Agent Serv. Code (API)"; Code[10])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
    }

}