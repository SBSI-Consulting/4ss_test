report 50101 "Report eoricountry PTE"
{
    // Make the report searchable from Tell me under the Reports and Analysis category.
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    CaptionML = ENU = 'Customer List';
    WordLayout = 'Customer List  Report.docx';
    RDLCLayout = 'Customer List  Report.rdlc';
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
        dataitem(Item; Item)
        {
            column(Tariff_No.; Tariff No.)
            {
                IncludeCaption = true;

            }
        }
        /*   dataitem(Totals; "Integer")
           {
               // maybe some dataitem properties here

               column(TotalNetAmount; Format(vTotalAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
               {
               }
               column(TotalVATBaseLCY; vTotalVATBaseLCY)
               {
               }
           }
   */
    }



}