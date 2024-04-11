pageextension 50012 "SalesInvoices" extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        /* addafter(Post)
        {
            action("Update from Excel File")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    UpdateEntries: Codeunit "Update Posted Entries";
                begin
                    UpdateEntries.ImportExcel();
                end;
            }
        } */
    }

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure AssignItemCharge(var ActionContext: WebServiceActionContext)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
    begin
        GetDraftInvoice(SalesHeader);
        Rec.AssignItemCharge(SalesHeader);
        //SetActionResponse(ActionContext, SalesInvoiceAggregator.GetSalesInvoiceHeaderId(SalesInvoiceHeader));
    end;

    local procedure GetDraftInvoice(var SalesHeader: Record "Sales Header")
    begin
        /*     if Rec.Posted then
                Error(DraftInvoiceActionErr); */

        SalesHeader.SetRange(SystemId, Rec.SystemId);
        if not SalesHeader.FindFirst() then
            Error('This invoice does not exist');

        SalesHeader.SetRange(SystemId);
    end;


    var
        myInt: Integer;
}