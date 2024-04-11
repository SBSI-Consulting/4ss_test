report 50101 "Report eoricountry PTE"
{
    // Make the report searchable from Tell me under the Reports and Analysis category.
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
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
    }
}