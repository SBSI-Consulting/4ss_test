tableextension 50003 "PostedSalesInvoiceExt" extends "Sales Invoice Header"
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
        field(50004; "4SS Net Weight"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line"."Net Weight" where(Type = const(Item)));
        }
        field(50005; "4SS Estimation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "4SS Tracking No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "4SS Shipment No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "4SS Package Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50010; "4SS Package Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line"."4SS Package Quantity" where("Document No." = field("No."), Type = const("Charge (Item)")));
        }





    }







}