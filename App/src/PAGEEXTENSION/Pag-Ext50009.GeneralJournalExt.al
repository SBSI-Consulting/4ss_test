pageextension 50009 "GeneralJournalExt" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(ImportPayrollFile)
        {
            Visible = true;
            trigger OnBeforeAction()
            begin

            end;
        }
    }

    var
        myInt: Integer;
}