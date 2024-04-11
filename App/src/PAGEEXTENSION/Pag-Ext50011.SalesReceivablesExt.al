pageextension 50011 "SalesReceivablesExt" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Copy Line Descr. to G/L Entry")
        {
            field("Footer Standard Text Code"; Rec."4SS Footer Standard Text Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Footer Standard Text Code")
        {
            field("CGV Standard Text Code"; Rec."4SS CGV Standard Text Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}