query 50003 "ValueEntries"
{
    QueryType = Normal;

    elements
    {
        dataitem(ValueEntry; "Value Entry")
        {
            column(AppliestoEntry; "Applies-to Entry")
            {
            }
            column(AverageCostException; "Average Cost Exception")
            {
            }
            column(CapacityLedgerEntryNo; "Capacity Ledger Entry No.")
            {
            }
            column(CostAmountActualACY; "Cost Amount (Actual) (ACY)")
            {
            }
            column(CostAmountActual; "Cost Amount (Actual)")
            {
            }
            column(CostAmountExpectedACY; "Cost Amount (Expected) (ACY)")
            {
            }
            column(CostAmountExpected; "Cost Amount (Expected)")
            {
            }
            column(CostAmountNonInvtbl; "Cost Amount (Non-Invtbl.)")
            {
            }
            column(CostAmountNonInvtblACY; "Cost Amount (Non-Invtbl.)(ACY)")
            {
            }
            column(CostperUnitACY; "Cost per Unit (ACY)")
            {
            }
            column(CostperUnit; "Cost per Unit")
            {
            }
            column(CostPostedtoGLACY; "Cost Posted to G/L (ACY)")
            {
            }
            column(CostPostedtoGL; "Cost Posted to G/L")
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(DiscountAmount; "Discount Amount")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentLineNo; "Document Line No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DropShipment; "Drop Shipment")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(ExpCostPostedtoGLACY; "Exp. Cost Posted to G/L (ACY)")
            {
            }
            column(ExpectedCostPostedtoGL; "Expected Cost Posted to G/L")
            {
            }
            column(ExpectedCost; "Expected Cost")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup; "Gen. Prod. Posting Group")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(InventoryPostingGroup; "Inventory Posting Group")
            {
            }
            column(InvoicedQuantity; "Invoiced Quantity")
            {
            }
            column(ItemChargeNo; "Item Charge No.")
            {
            }
            column(ItemLedgerEntryNo; "Item Ledger Entry No.")
            {
            }
            column(ItemLedgerEntryQuantity; "Item Ledger Entry Quantity")
            {
            }
            column(ItemLedgerEntryType; "Item Ledger Entry Type")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(JobLedgerEntryNo; "Job Ledger Entry No.")
            {
            }
            column(JobNo; "Job No.")
            {
            }
            column(JobTaskNo; "Job Task No.")
            {
            }
            column(JournalBatchName; "Journal Batch Name")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(No; "No.")
            {
            }
            column(OrderLineNo; "Order Line No.")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(OrderType; "Order Type")
            {
            }
            column(PartialRevaluation; "Partial Revaluation")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PurchaseAmountActual; "Purchase Amount (Actual)")
            {
            }
            column(PurchaseAmountExpected; "Purchase Amount (Expected)")
            {
            }
            column(ReasonCode; "Reason Code")
            {
            }
            column(ReturnReasonCode; "Return Reason Code")
            {
            }
            column(SalesAmountActual; "Sales Amount (Actual)")
            {
            }
            column(SalesAmountExpected; "Sales Amount (Expected)")
            {
            }
            column(SalespersPurchCode; "Salespers./Purch. Code")
            {
            }
            column(SourceCode; "Source Code")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(SourcePostingGroup; "Source Posting Group")
            {
            }
            column(SourceType; "Source Type")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(ValuationDate; "Valuation Date")
            {
            }
            column(ValuedByAverageCost; "Valued By Average Cost")
            {
            }
            column(ValuedQuantity; "Valued Quantity")
            {
            }
            column(VarianceType; "Variance Type")
            {
            }
            column(VariantCode; "Variant Code")
            {
            }
            column(Adjustment; Adjustment)
            {
            }
            column(Description; Description)
            {
            }
            column(Inventoriable; Inventoriable)
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
            column(Type; Type)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
