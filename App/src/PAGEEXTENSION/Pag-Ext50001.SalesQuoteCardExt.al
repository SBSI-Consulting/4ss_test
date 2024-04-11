pageextension 50001 "SalesQuoteCardExt" extends "Sales Quote"
{
    layout
    {
        addafter("No.")
        {
            field("Offer No."; Rec."4SS Offer No.")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
        addafter(Status)
        {
            field(Estimation; Rec."4SS Estimation")
            {
                ApplicationArea = All;
            }

        }
        addafter(Estimation)
        {
            field("Package Qty"; Rec."4SS Package Qty")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }



    actions
    {

        /* addafter(release)
        {
            action(EstimationAction)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedOnly = true;
                //Visible = false;
                trigger OnAction()
                var
                    APISupplySubscriber: Codeunit "APISupplySubscriber";
                begin
                    APISupplySubscriber.PerformManualEstimation(Rec);
                end;
            }
        }
        addafter(EstimationAction)
        {
            action(CallPDF)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedOnly = true;
                //Visible = false;
                trigger OnAction()
                var
                    APISupplySubscriber: Codeunit "APISupplySubscriber";
                begin
                    APISupplySubscriber.CallPDF();
                end;
            }
        } */
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.testfield("4SS Estimation", false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.testfield("4SS Estimation", false);
    end;

    var
        myInt: Integer;
}