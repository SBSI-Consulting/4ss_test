pageextension 50013 "IntrastatJnlPageExt" extends "Intrastat Journal"
{
    layout
    {
        addbefore("Partner VAT ID")
        {
            field("Third Party Type"; Rec."4SS Third Party Type")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Third Party Type")
        {
            field("Third Party No."; Rec."4SS Third Party No.")
            {
                ApplicationArea = all;
                Editable = false;


            }
        }
        addafter("Third Party No.")
        {
            field("Third Party Name"; Rec."4SS Third Party Name")
            {
                ApplicationArea = all;
                Editable = false;

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