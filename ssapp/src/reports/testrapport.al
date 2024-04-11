report 50101 "Report eoricountry PTE"
{
    // Make the report searchable from Tell me under the Reports and Analysis category.
    RDLCLayout = './StandardSalesInvoice.rdlc';
    WordLayout = './StandardSalesInvoice.docx';
    Caption = 'Sales - Invoice';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(Country_Region_Code; "Country/Region Code")
            {
                IncludeCaption = true;

            }
            column(EORI_Number; "EORI Number")
            {
                IncludeCaption = true;

            }
        }
        dataitem(Totals; "Integer")
        {
            // maybe some dataitem properties here

            /*column(TotalNetAmount; Format(vTotalAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
            {
            }
            column(TotalVATBaseLCY; vTotalVATBaseLCY)
            {
            }*/
        }

    }



}