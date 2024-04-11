query 50004 "ItemCategory"
{
    Caption = 'ItemCategory';
    QueryType = Normal;

    elements
    {
        dataitem(ItemCategory; "Item Category")
        {
            column("Code"; "Code")
            {
            }
            column(Description; Description)
            {
            }
            column(HasChildren; "Has Children")
            {
            }
            /* column(Id; Id)
            {
            } */
            column(Indentation; Indentation)
            {
            }
            column(LastModifiedDateTime; "Last Modified Date Time")
            {
            }
            column(ParentCategory; "Parent Category")
            {
            }
            column(PresentationOrder; "Presentation Order")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
