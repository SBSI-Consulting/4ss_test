codeunit 50005 "GenericSubscriber"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Item Ledger Entries", 'OnBeforeInsertItemJnlLine', '', false, false)]
    procedure OnBeforeInsertItemJnlLine(var IntrastatJnlLine: Record "Intrastat Jnl. Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean)
    begin
        case ItemLedgerEntry."Source Type" of
            ItemLedgerEntry."Source Type"::Customer:
                begin
                    IntrastatJnlLine."4SS Third Party Type" := IntrastatJnlLine."4SS Third Party Type"::Customer;
                    IntrastatJnlLine."4SS Third Party No." := ItemLedgerEntry."Source No.";
                    ItemLedgerEntry.CalcFields("SCGEN Source Name");
                    IntrastatJnlLine."4SS Third Party Name" := ItemLedgerEntry."SCGEN Source Name";
                end;
            ItemLedgerEntry."Source Type"::Vendor:
                begin
                    IntrastatJnlLine."4SS Third Party No." := ItemLedgerEntry."Source No.";
                    ItemLedgerEntry.CalcFields("SCGEN Source Name");
                    IntrastatJnlLine."4SS Third Party Name" := ItemLedgerEntry."SCGEN Source Name";
                end;
        end

    end;

    var
        myInt: Integer;
}